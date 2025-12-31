import 'dart:convert';
import 'package:http/http.dart' as http;
import 'event_model.dart';

class ApiService {
  static const _apiKey = 'Gaj7cUxVDbJiFvTH3pGUFxafahQVUcOI';
  static const _baseUrl =
      'https://app.ticketmaster.com/discovery/v2/events.json';

  static Future<List<Event>> fetchEvents() async {
    final response = await http.get(
      Uri.parse('$_baseUrl?apikey=$_apiKey&city=El+Paso'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final events = data['_embedded']?['events'] ?? [];
      return List<Event>.from(events.map((e) => Event.fromJson(e)));
    } else {
      throw Exception('Failed to load events');
    }
  }
}
