import 'package:el_paso_events/homeTab/homeTemp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String description;
  final String docId; //receive the Firestore document ID
  final String location;
  final String date;
  final String time;

  const EventDetailScreen({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.docId,
    required this.location,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name), backgroundColor: mainColor),
      backgroundColor: mainColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          imageUrl.isNotEmpty
              ? Image.network(imageUrl, height: 200, fit: BoxFit.cover)
              : Container(height: 200, color: Colors.grey[300]),
          const SizedBox(height: 16),

          Text("📍$location", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),

          Text("📅${formatDate(date)}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),

          Text("⏳$time", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),

          // Description
          Text("Description: $description"),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String formatDate(String dateStr) {
    try {
      final parsedDate = DateTime.parse(dateStr);
      return DateFormat.yMMMd().format(parsedDate); // e.g., Jan 1, 2025
    } catch (_) {
      return dateStr; // fallback if parsing fails
    }
  }
}
