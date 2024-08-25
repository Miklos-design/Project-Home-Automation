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

  Future<void> toggleSwitch(String entityId, bool turnOn) async {
    final url =
        Uri.parse('$baseUrl/api/services/switch/turn_${turnOn ? 'on' : 'off'}');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({'entity_id': entityId});

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Switch toggled successfully');
    } else {
      print('Failed to toggle switch: ${response.body}');
    }
  }

  Future<List> getAutomations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/states'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List entities = jsonDecode(response.body);
      return entities
          .where((e) => e['entity_id'].startsWith('automation.'))
          .toList();
    } else {
      throw Exception('Failed to load automations');
    }
  }

  Future<void> turnOnAutomation(String entityId) async {
    await http.post(
      Uri.parse('$baseUrl/api/services/automation/turn_on'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'entity_id': entityId}),
    );
  }

  Future<Map<String, dynamic>> getEntity(String entityId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/states/$entityId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to load entity. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load entity');
    }
  }

  void setBrightness(String entityId, double brightness) async {
    await http.post(
      Uri.parse('$baseUrl/api/services/light/turn_on'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'entity_id': entityId,
        'brightness_pct': (brightness * 100).toInt(),
      }),
    );
  }

  void setColorTemperature(String entityId, int kelvin) async {
    await http.post(
      Uri.parse('$baseUrl/api/services/light/turn_on'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'entity_id': entityId,
        'kelvin': kelvin,
      }),
    );
  }

  Future<void> turnOffAutomation(String entityId) async {
    await http.post(
      Uri.parse('$baseUrl/api/services/automation/turn_off'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'entity_id': entityId}),
    );
  }
}
