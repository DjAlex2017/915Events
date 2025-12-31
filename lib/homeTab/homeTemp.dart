import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:el_paso_events/homeTab/EventDetailScreen.dart';
import 'package:el_paso_events/data/hardcoded_places.dart';
import 'package:el_paso_events/homeTab/PlaceDetailScreen.dart';

final Color mainColor = Color(0xFFF5E9DC);

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Widget horizontalCard(
    String title, {
    String? imageUrl,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                  imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                : Container(height: 100, color: Colors.grey[300]),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Text("Some description...", style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget horizontalListSection(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(title),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return horizontalCard(
                item.name,
                imageUrl: item.imageUrl,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => PlaceDetailScreen(
                            name: item.name,
                            imageUrl: item.imageUrl,
                            description:
                                item.description ?? 'No description available',
                            latitude: item.latitude,
                            longitude: item.longitude,
                          ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget firebaseEventsSection(AsyncSnapshot<QuerySnapshot> snapshot) {
    final events = snapshot.data?.docs ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("Your Events"),
        SizedBox(
          height: 180,
          child:
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : snapshot.hasError
                  ? Center(child: Text('Error: ${snapshot.error}'))
                  : events.isEmpty
                  ? const Center(child: Text("No events yet"))
                  : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      final data = event.data() as Map<String, dynamic>;
                      final name = data['name'] ?? 'No name';
                      final imageUrl = data['imageUrl'] ?? '';
                      final description =
                          data['description'] ?? 'No description';
                      final time = data['time'] ?? 'No time set';

                      return horizontalCard(
                        name,
                        imageUrl: imageUrl,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => EventDetailScreen(
                                    name: name,
                                    imageUrl: imageUrl,
                                    description: description,
                                    docId: event.id,
                                    location: data['location'] ?? 'No location',
                                    date: data['date'] ?? '',
                                    time: time,
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('events')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            return ListView(
              padding: const EdgeInsets.only(bottom: 24.0),
              children: [
                firebaseEventsSection(snapshot),
                horizontalListSection("Bar Promotions", bars),
                horizontalListSection("Restaurants", restaurants),
                horizontalListSection("Concerts", concerts),
              ],
            );
          },
        ),
      ),
    );
  }
}
