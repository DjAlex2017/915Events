import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_paso_events/data/placeholder_images.dart';
import 'dart:math';

class createTab extends StatefulWidget {
  final void Function(int)? onTabChange;
  const createTab({super.key, this.onTabChange});

  @override
  State<createTab> createState() => _createTabState();
}

class _createTabState extends State<createTab> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  final Color mainColor = const Color(0xFFF5E9DC);

  DateTime? _selectedDate;
  // ignore: unused_field
  TimeOfDay? _selectedTime;

  Future<void> _pickTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = pickedTime.format(context);
      });
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat.yMMMd().format(pickedDate);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be logged in to create an event.'),
          ),
        );
        return;
      }
      final newEvent = {
        'name': _nameController.text,
        'date': _selectedDate?.toIso8601String() ?? '',
        'time': _timeController.text,
        'location': _locationController.text,
        'imageUrl':
            _imageUrlController.text.trim().isNotEmpty
                ? _imageUrlController.text.trim()
                : placeholderImages[Random().nextInt(placeholderImages.length)],
        'description': _detailController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user.uid,
      };

      try {
        await FirebaseFirestore.instance.collection('events').add(newEvent);

        if (!mounted) return;

        _nameController.clear();
        _dateController.clear();
        _timeController.clear();
        _locationController.clear();
        _imageUrlController.clear();
        _detailController.clear();
        setState(() {
          _selectedDate = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Event Created and Saved!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        // await Future.delayed(const Duration(milliseconds: 500));
        // widget.onTabChange?.call(0);
      } catch (e) {
        if (!mounted) return;
        print('Error saving event: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save event: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter event name'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Event Date',
                  border: OutlineInputBorder(),
                ),
                onTap: () => _pickDate(context),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Pick a date' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Event Time",
                  border: OutlineInputBorder(),
                ),
                onTap: () => _pickTime(context),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Pick a time' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _detailController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Event Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4C39),
                ),
                child: const Text(
                  'Create Event',
                  style: TextStyle(
                    color: Colors.white, // or Color(0xFFFFFFFF)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
