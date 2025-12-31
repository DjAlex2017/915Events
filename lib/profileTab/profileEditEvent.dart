import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditEventScreen extends StatefulWidget {
  final String docId;
  final String name;
  final String date;
  final String time;
  final String location;
  final String imageUrl;
  final String description;

  const EditEventScreen({
    Key? key,
    required this.docId,
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.imageUrl,
    required this.description,
  }) : super(key: key);

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _locationController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descriptionController;
  final Color mainColor = Color(0xFFF5E9DC);
  final Color accentColor = Color(0xFF8B4C39);

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _dateController = TextEditingController(
      text: DateFormat.yMMMd().format(
        DateTime.tryParse(widget.date) ?? DateTime.now(),
      ),
    );
    _timeController = TextEditingController(text: widget.time);
    _locationController = TextEditingController(text: widget.location);
    _imageUrlController = TextEditingController(text: widget.imageUrl);
    _descriptionController = TextEditingController(text: widget.description);
    _selectedDate = DateTime.tryParse(widget.date);
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat.yMMMd().format(picked);
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      final shouldSave = await showDialog<bool>(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Confirm Save'),
              content: const Text(
                'Are you sure you want to save these changes?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
      );

      if (shouldSave != true) return; // Cancelled

      try {
        await FirebaseFirestore.instance
            .collection('events')
            .doc(widget.docId)
            .update({
              'name': _nameController.text,
              'date': _selectedDate?.toIso8601String() ?? widget.date,
              'time': _timeController.text,
              'location': _locationController.text,
              'imageUrl': _imageUrlController.text,
              'description': _descriptionController.text,
            });

        if (!mounted) return;
        Navigator.of(context).pop(); // Go back after saving
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Event updated!')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: const Text('Edit Event'),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _pickDate(context),
                decoration: const InputDecoration(labelText: 'Event Date'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                onTap: () => _pickTime(context),
                decoration: const InputDecoration(labelText: 'Event Time'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateEvent,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
