import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:homesense/utils/device_block.dart';
import '../utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _MySmartDevices = [
    ["Living Room", "lib/assets/floor_lamp.png", true],
    ["Bed Room", "lib/assets/home.png", true],
    ["Shed", "lib/assets/home.png", true],
    ["Lounge", "lib/assets/home.png", true],
    ["Garage", "lib/assets/home.png", true],
    ["Blinds", "lib/assets/home.png", true],
  ];

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
        // ["New Room 1", "assets/new_room.png", true],
        // ["New Room 2", "assets/new_room.png", true],
        // Add more items as needed
      ]);
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 90, 212, 249),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.menu,
                    size: 50,
                    color: iconColor,
                  ),
                  Icon(
                    Icons.person,
                    size: 50,
                    color: iconColor,
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome Home"),
                  Text(
                    "Mossgiel House",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text("Smart Devices"),
            ),
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
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
          ],
        ),
      ),
    );
  }

  powerToggleSwitched(bool value, int index) {
    setState(() {
      _MySmartDevices[index][2] = value;
    });
  }
}
