import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homesense/pages/home_page.dart';

void main() {
  testWidgets('HeaderWidget displays the correct title',
      (WidgetTester tester) async {
    // Build the HeaderWidget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: HeaderWidget(),
        ),
      ),
    ));

    // Verify the "HomeSense" text is displayed.
    expect(find.text('HomeSense'), findsOneWidget);

    // Verify the person icon is displayed.
    expect(find.byIcon(Icons.person), findsOneWidget);

    // Verify there is an empty space equal to the icon width on the right.
    final iconFinder = find.byIcon(Icons.person);
    final iconSize = tester.getSize(iconFinder);
    final sizedBoxFinder = find.byType(SizedBox);
    expect(tester.getSize(sizedBoxFinder), equals(iconSize));
  });
}
