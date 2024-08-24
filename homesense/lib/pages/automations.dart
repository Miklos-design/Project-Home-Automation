import 'package:flutter/material.dart';
import 'package:homesense/services/hass.dart';
import '../utils/api_config.dart';
import 'package:homesense/pages/extra/bottom_navigation.dart'; // Import the BottomNavBar class

class Automations extends StatefulWidget {
  @override
  _AutomationsState createState() => _AutomationsState();
}

class _AutomationsState extends State<Automations> {
  final Hass _api = Hass(
    baseUrl: 'http://192.168.0.68:8123',
    token: APIConfig.apiKey,
  );

  List _automations = [];
  bool _isLoading = true;
  int _selectedIndex = 2; // Set to 2 since this is the Automations page

  @override
  void initState() {
    super.initState();
    _fetchAutomations();
  }

  void _fetchAutomations() async {
    List automations = await _api.getAutomations();
    print(automations); // Print the entire list to see its structure
    setState(() {
      _automations = automations;
      _isLoading = false;
    });
  }

  void _toggleAutomation(bool value, String entityId) async {
    if (value) {
      await _api.turnOnAutomation(entityId);
    } else {
      await _api.turnOffAutomation(entityId);
    }
    _fetchAutomations(); // Refresh the list to get the updated state
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Automations'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _automations.length,
              itemBuilder: (context, index) {
                var automation = _automations[index];
                var automationName = automation['attributes']
                        ['friendly_name'] ??
                    'Unnamed Automation';

                var automationState = automation['state'] ?? 'off';

                return ListTile(
                  title: Text(automationName),
                  trailing: Switch(
                    value: automationState == 'on',
                    onChanged: (value) {
                      _toggleAutomation(value, automation['entity_id']);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
