import 'package:flutter/material.dart';
import 'package:homesense/utils/device_block.dart';

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
