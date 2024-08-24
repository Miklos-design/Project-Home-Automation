import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesense/services/hass.dart';
import 'package:homesense/utils/api_config.dart';
import 'package:homesense/utils/device_block.dart';
import '../utils/colors.dart';
import 'package:homesense/pages/extra/bottom_navigation.dart';
import 'package:homesense/pages/home_page.dart';

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
    ["Living Room", "lib/assets/floor_lamp.png", true, "light.living_room"],
    ["Bed Room", "lib/assets/floor_lamp.png", true, "light.bedroom"],
    ["Shed", "lib/assets/home.png", true, "light.shed"],
    ["Lounge", "lib/assets/floor_lamp.png", true, "switch.lounge"],
    ["Garage", "lib/assets/home.png", true, "light.garage"],
    ["Blinds", "lib/assets/home.png", true, "cover.blinds"],
  ];

  int _selectedIndex = 1; // Set to 1 since this is the Devices page

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
      body: Column(
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
