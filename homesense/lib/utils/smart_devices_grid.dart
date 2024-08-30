import 'package:flutter/material.dart';
import 'package:homesense/utils/device_block.dart';

class SmartDevicesGrid extends StatelessWidget {
  final List devices;
  final Function(bool, int) onToggle;
  final Function(int) onDeviceTapped; // Add this callback

  SmartDevicesGrid({
    required this.devices,
    required this.onToggle,
    required this.onDeviceTapped, // Pass this in constructor
  });

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
          return GestureDetector(
            onTap: () => onDeviceTapped(index), // Handle tap
            child: DeviceBlock(
              name: devices[index][0],
              iconPath: devices[index][1],
              powerOn: devices[index][2],
              onChanged: (value) => onToggle(value, index),
            ),
          );
        },
      ),
    );
  }
}
