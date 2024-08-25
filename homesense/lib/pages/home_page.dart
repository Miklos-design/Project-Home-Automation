import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homesense/pages/automations.dart';
import 'package:homesense/pages/devices.dart';
import 'package:homesense/services/hass.dart';
import 'package:homesense/utils/colors.dart';
import 'package:homesense/pages/extra/bottom_navigation.dart';
import 'package:rive/rive.dart';
import '../utils/api_config.dart';

// Top Bar Widget
class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "HomeSense",
            style: GoogleFonts.oswald(
              fontSize: 29,
              fontWeight: FontWeight.w400,
              color: mainTextColor,
            ),
          ),
          Icon(Icons.person, size: 50, color: iconColor),
        ],
      ),
    );
  }
}

// Combined Home and Weather Page Widget
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Hass _api = Hass(
    baseUrl: 'http://192.168.0.68:8123',
    token: APIConfig.apiKey,
  );

  int _selectedIndex = 0;
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

  Widget _getBackgroundAnimation() {
    return FutureBuilder<String>(
      future: _loadRiveAnimationUrl(), // Asynchronously load Rive animation URL
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Loading indicator
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error loading animation')); // Error handling
        } else {
          return SizedBox.expand(
            child: RiveAnimation.network(
              snapshot.data!, // Use the URL directly
              fit: BoxFit.cover,
            ),
          );
        }
      },
    );
  }

  Future<String> _loadRiveAnimationUrl() async {
    switch (_weatherCondition) {
      case 'rainy':
        return 'https://public.rive.app/community/runtime-files/10045-19164-sky-rain.riv';
      case 'cloudy':
        return 'https://public.rive.app/community/runtime-files/10034-19138-sky-sun-cloud.riv';
      case 'sunny':
        return 'https://public.rive.app/community/runtime-files/10040-19151-sky-moon-night.riv';
      default:
        return 'https://public.rive.app/community/runtime-files/4454-9096-parallax-canopy-house.riv';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: HeaderWidget(),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _getBackgroundAnimation(),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
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
