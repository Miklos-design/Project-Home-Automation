import 'dart:convert';
import 'package:http/http.dart' as http;

class Hass {
  final String baseUrl;
  final String token;

  Hass({required this.baseUrl, required this.token});

  // Example function to toggle a light
  Future<void> toggleLight(String entityId, bool turnOn) async {
    final url =
        Uri.parse('$baseUrl/api/services/light/turn_${turnOn ? 'on' : 'off'}');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({'entity_id': entityId});

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Light toggled successfully');
    } else {
      print('Failed to toggle light: ${response.body}');
    }
  }

  // Additional methods for other interactions with Home Assistant
}
