import 'package:flutter/material.dart';
import 'package:homesense/services/hass.dart';

class Automations extends StatefulWidget {
  @override
  _AutomationPageState createState() => _AutomationPageState();
}

class _AutomationPageState extends State<Automations> {
  final Hass _api = Hass(
    baseUrl: 'http://192.168.0.68:8123',
    token:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI3ZDVjMmQ5MjJlZjg0YzhiYmE5NmM2Mzk5NTNkNjk2NyIsImlhdCI6MTcyMjg1OTY4MCwiZXhwIjoyMDM4MjE5NjgwfQ.JMW0uIi2Zwzn0CWRheznp91MQDKHcFTDr9-f68f3qQE',
  );

  List _automations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAutomations();
  }

  void _fetchAutomations() async {
    List automations = await _api.getAutomations();
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
                // Check if the name key exists and is not null
                var automationName =
                    automation['alias'] ?? 'Unnamed Automation';
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
    );
  }
}
