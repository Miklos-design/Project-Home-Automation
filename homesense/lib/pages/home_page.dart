import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesense/services/hass.dart';
import 'package:homesense/utils/device_block.dart';
import '../utils/colors.dart';

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

  List _MySmartDevices = [
    ["Living Room", "lib/assets/floor_lamp.png", true, "light.living_room"],
    ["Bed Room", "lib/assets/home.png", true, "light.bed_room"],
    ["Shed", "lib/assets/home.png", true, "light.shed"],
    [
      "Lounge",
      "lib/assets/floor_lamp.png",
      true,
      "switch.lounge_lamp_switch_1"
    ],
    ["Garage", "lib/assets/home.png", true, "light.garage"],
    ["Blinds", "lib/assets/home.png", true, "cover.blinds"],
  ];

  bool _loungeLampOn = false;

  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

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

    // Simulate a delay for loading more items
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _MySmartDevices.addAll([
        // Add more items as needed
      ]);
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.menu,
                      size: 50,
                      color: iconColor,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "HomeSense",
                          style: GoogleFonts.oswald(
                            fontSize: 29,
                            fontWeight: FontWeight.w400, // Thin weight
                            color: mainTextColor,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.person,
                      size: 50,
                      color: iconColor,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mossgiel House",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 50,
                        color: customTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text("Smart Devices"),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.6, // Set a fixed height for the grid
                child: GridView.builder(
                  //controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    //childAspectRatio: 1.2,
                  ),
                  itemCount: _MySmartDevices.length,
                  itemBuilder: (context, index) {
                    return DeviceBlock(
                      name: _MySmartDevices[index][0],
                      iconPath: _MySmartDevices[index][1],
                      powerOn: _MySmartDevices[index][2],
                      onChanged: (value) => powerToggleSwitched(value, index),
                    );
                  },
                ),
              ),
              if (_isLoadingMore)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Add your button action here
                  },
                  child: Text("Add Device"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void powerToggleSwitched(bool value, int index) {
    setState(() {
      _MySmartDevices[index][2] = value;
    });
    _api.toggleLight(_MySmartDevices[index][3], value);
  }
}
