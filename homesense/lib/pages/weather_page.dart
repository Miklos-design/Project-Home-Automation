import 'package:flutter/material.dart';
import 'package:homesense/services/hass.dart';
import '../utils/api_config.dart';
import 'package:rive/rive.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final Hass _api = Hass(
    baseUrl: 'http://192.168.0.68:8123',
    token: APIConfig.apiKey,
  );

  String _weatherCondition = 'clear';
  double _temperature = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    var weather = await _api.getEntity('weather.forecast_home');
    setState(() {
      _temperature = weather['attributes']['temperature'];
      _weatherCondition = weather['state']; // 'clear', 'cloudy', 'rainy', etc.
      _isLoading = false;
    });
  }

  Widget _getBackgroundAnimation() {
    switch (_weatherCondition) {
      case 'rainy':
        return RiveAnimation.asset('assets/rainy_animation.riv');
      case 'cloudy':
        return RiveAnimation.asset('assets/cloudy_animation.riv');
      case 'sunny':
        return RiveAnimation.asset('assets/sunny_animation.riv');
      default:
        return RiveAnimation.asset('assets/clear_animation.riv');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _getBackgroundAnimation(),
          Center(
            child: _isLoading
                ? CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_temperature.toStringAsFixed(1)}°C',
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _weatherCondition.toUpperCase(),
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
