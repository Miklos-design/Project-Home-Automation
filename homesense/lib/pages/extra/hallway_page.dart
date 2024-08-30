import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:homesense/services/hass.dart';
import 'package:homesense/utils/colors.dart';

class HallwayPage extends StatefulWidget {
  final Hass api;
  final String entityId;

  const HallwayPage({required this.api, required this.entityId, Key? key})
      : super(key: key);

  @override
  _HallwayPageState createState() => _HallwayPageState();
}

class _HallwayPageState extends State<HallwayPage> {
  double _currentBrightness = 0.0;
  late StreamSubscription<GyroscopeEvent> _gyroscopeSubscription;
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _listenToGyroscope();
    _listenToAccelerometer();
  }

  @override
  void dispose() {
    // Only cancel the subscriptions if they have been initialized
    _gyroscopeSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void _listenToGyroscope() {
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      double brightness = (event.x.abs() + event.y.abs() + event.z.abs()) * 10;
      brightness = brightness.clamp(0.0, 100.0);

      setState(() {
        _currentBrightness = brightness;
      });

      widget.api.setBrightness(widget.entityId, _currentBrightness);
    });
  }

  void _listenToAccelerometer() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      if (event.z > 9.8) {
        // Face-up
        setState(() {
          _currentBrightness = 100.0;
        });
        widget.api.setBrightness(widget.entityId, _currentBrightness);
      } else if (event.z < -9.8) {
        // Face-down
        setState(() {
          _currentBrightness = 0.0;
        });
        widget.api.setBrightness(widget.entityId, _currentBrightness);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine the background color based on brightness
    Color backgroundColor = _currentBrightness == 0.0
        ? Colors.black
        : Color.lerp(
            Colors.orange.shade900, Colors.white, _currentBrightness / 100)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Hallway Lamp Control'),
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rotate your phone to change brightness\nor flip it to turn the lamp off',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Brightness: ${_currentBrightness.toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
