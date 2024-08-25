import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesense/services/hass.dart';
import 'package:homesense/utils/api_config.dart';
import 'package:homesense/utils/device_block.dart';
import '../utils/colors.dart';
import 'package:homesense/pages/extra/bottom_navigation.dart';
import 'package:homesense/utils/smart_devices_grid.dart';

class Devices extends StatefulWidget {
  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  final Hass _api = Hass(
    baseUrl: 'http://192.168.0.68:8123',
    token: APIConfig.apiKey,
  );

  List _mySmartDevices = [
    ["Hallway", "lib/assets/bulb.png", true, "light.living_room"],
    ["Bed Room", "lib/assets/king_bed.png", true, "light.bedroom"],
    ["Lounge", "lib/assets/floor_lamp.png", true, "light.lounge_lamp"],
    ["Toaster", "lib/assets/toaster.png", true, "switch.toster"],
    ["Kettle", "lib/assets/kettle.png", true, "switch.kettle"],
    ["Blinds", "lib/assets/roller.png", true, "cover.blinds"],
  ];

  int _selectedIndex = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDeviceStatuses(); // Fetch the status of devices on initialization
  }

  void _fetchDeviceStatuses() async {
    List updatedDevices = [];

    for (var device in _mySmartDevices) {
      var status = await _api.getEntity(device[3]);
      updatedDevices.add([
        device[0],
        device[1],
        status['state'] == 'on', // Update the state based on API response
        device[3],
      ]);
    }

    setState(() {
      _mySmartDevices = updatedDevices;
      _isLoading = false;
    });
  }

  void powerToggleSwitched(bool value, int index) {
    setState(() {
      _mySmartDevices[index][2] = value;
    });
    _api.toggleLight(_mySmartDevices[index][3], value);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show a loading indicator while fetching
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    "Smart Devices",
                    style: GoogleFonts.bebasNeue(
                      fontSize: 50,
                      color: customTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SmartDevicesGrid(
                    devices: _mySmartDevices,
                    onToggle: powerToggleSwitched,
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
