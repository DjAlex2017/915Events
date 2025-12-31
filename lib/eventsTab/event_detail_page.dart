import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'event_model.dart';
import 'package:intl/intl.dart';

final Color mainColor = Color(0xFFF5E9DC);
final Color accentColor = Color(0xFF8B4C39);

class EventDetailPage extends StatelessWidget {
  final Event event;

  const EventDetailPage({
    super.key,
    required this.event,
    required String heroTag,
  });

  void _launchTicketUrl(BuildContext context) async {
    final uri = Uri.parse(event.url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open ticket link')));
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate;
    try {
      formattedDate = DateFormat.yMMMd().add_jm().format(
        DateTime.parse(event.date),
      );
    } catch (_) {
      formattedDate = DateFormat.yMMMd().format(DateTime.parse(event.date));
    }

    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: Text(event.name),
        backgroundColor: mainColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        children: [
          if (event.imageUrl.isNotEmpty)
            Hero(
              tag: '${event.name}-${event.imageUrl}',
              child: Image.network(
                event.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  event.venue.isNotEmpty ? event.venue : 'Unknown Venue',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                if (event.description.isNotEmpty)
                  Text(event.description, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _launchTicketUrl(context),
                  icon: const Icon(Icons.open_in_new, color: Colors.white),
                  label: const Text(
                    'Buy Ticket',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
