class Event {
  final String name;
  final String date;
  final String imageUrl;
  final String url;
  final String description;
  final String venue;

  Event({
    required this.name,
    required this.date,
    required this.imageUrl,
    required this.url,
    required this.description,
    required this.venue,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    final date = json['dates']?['start']?['localDate'] ?? '';
    final time = json['dates']?['start']?['localTime'] ?? '';
    final dateTime = time.isNotEmpty ? '$date $time' : date;

    final image = (json['images'] as List?)?.firstWhere(
      (img) => img['width'] > 500,
      orElse: () => {'url': ''},
    );

    final venue = (json['_embedded']?['venues'] as List?)?.firstWhere(
      (v) => v != null,
      orElse: () => {'name': 'Unknown Venue'},
    );

    return Event(
      name: json['name'] ?? 'No Name',
      date: dateTime,
      imageUrl: image?['url'] ?? '',
      url: json['url'] ?? '',
      venue: venue?['name'] ?? 'Unknown Venue',
      description: json['info'] ?? '', // Some events use 'info' or 'pleaseNote'
    );
  }
}
