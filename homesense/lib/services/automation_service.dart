import 'package:flutter/material.dart';
import 'package:homesense/services/hass.dart'; // Adjust the import as necessary

class AutomationService {
  final Hass _api;

  AutomationService(this._api);

  Future<void> triggerTV(BuildContext context) async {
    try {
      await _api.runAutomation("automation.tv_time");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('TV Time automation triggered!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to trigger automation: $e')),
      );
    }
  }
}
