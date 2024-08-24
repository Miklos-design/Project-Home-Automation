import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesense/pages/automations.dart';
import 'package:homesense/pages/devices.dart';
import 'package:homesense/services/hass.dart';
import 'package:homesense/utils/device_block.dart';
import '../utils/colors.dart';
import 'package:homesense/pages/extra/bottom_navigation.dart'; // Import the BottomNavBar class

// Top Bar Widget
class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu,
              size: 50,
              color:
                  iconColor), // You can remove this line if you don't need the menu
          Expanded(
            child: Center(
              child: Text(
                "HomeSense",
                style: GoogleFonts.oswald(
                  fontSize: 29,
                  fontWeight: FontWeight.w400,
                  color: mainTextColor,
                ),
              ),
            ),
          ),
          Icon(Icons.person, size: 50, color: iconColor)
        ],
      ),
    );
  }
}

// Smart Devices Grid Widget
class SmartDevicesGrid extends StatelessWidget {
  final List devices;
  final Function(bool, int) onToggle;

  SmartDevicesGrid({required this.devices, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return DeviceBlock(
            name: devices[index][0],
            iconPath: devices[index][1],
            powerOn: devices[index][2],
            onChanged: (value) => onToggle(value, index),
          );
        },
      ),
    );
  }
}

// Main Home Page Widget
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Hass _api = Hass(
    baseUrl: 'http://192.168.0.68:8123',
    token:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI3ZDVjMmQ5MjJlZjg0YzhiYmE5NmM2Mzk5NTNkNjk2NyIsImlhdCI6MTcyMjg1OTY4MCwiZXhwIjoyMDM4MjE5NjgwfQ.JMW0uIi2Zwzn0CWRheznp91MQDKHcFTDr9-f68f3qQE',
  );

  List _mySmartDevices = [
    ["Living Room", "lib/assets/floor_lamp.png", true, "light.living_room"],
    ["Bed Room", "lib/assets/floor_lamp.png", true, "light.bedroom"],
    ["Shed", "lib/assets/home.png", true, "light.shed"],
    ["Lounge", "lib/assets/floor_lamp.png", true, "switch.lounge"],
    ["Garage", "lib/assets/home.png", true, "light.garage"],
    ["Blinds", "lib/assets/home.png", true, "cover.blinds"],
  ];

  int _selectedIndex = 0;
  bool _isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _mySmartDevices.addAll([
        // Add more items as needed
      ]);
      _isLoadingMore = false;
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
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Devices()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Automations()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                "Mossgiel House",
                style: GoogleFonts.bebasNeue(
                  fontSize: 50,
                  color: customTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text("Smart Devices"),
            ),
            SmartDevicesGrid(
              devices: _mySmartDevices,
              onToggle: powerToggleSwitched,
            ),
            if (_isLoadingMore)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
