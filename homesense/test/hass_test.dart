import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homesense/pages/home_page.dart'; // Assuming the path
import 'package:mockito/mockito.dart';
import 'package:homesense/services/hass.dart';
import 'package:homesense/utils/api_config.dart';

class MockHass extends Mock implements Hass {}

void main() {
  testWidgets('HomePage displays loading indicator and then weather data',
      (WidgetTester tester) async {
    final mockHass = MockHass();

    // Stub the getEntity method to return sample data.
    when(mockHass.getEntity('weather.forecast_home')).thenAnswer((_) async => {
          'state': 'clear',
          'attributes': {'temperature': 22.5},
        });

    // Build the HomePage with mocked Hass instance.
    await tester.pumpWidget(MaterialApp(
      home: HomePage(_api: mockHass), // Passing the mock service
    ));

    // Verify that CircularProgressIndicator is shown initially.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Pump the widget after the async call completes.
    await tester.pumpAndSettle();

    // Verify the temperature and weather condition are displayed.
    expect(find.text('22.5°C'), findsOneWidget);
    expect(find.text('CLEAR'), findsOneWidget);
  });
}
