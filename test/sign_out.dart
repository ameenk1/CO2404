import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g21097717/HomePage.dart'; // Adjust the import path as needed

void main() {
  testWidgets('Sign out process test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));
    // Tap the sign out icon
    await tester.tap(find.byIcon(Icons.exit_to_app));
    await tester.pump(); // Rebuild the widget

    // Add your sign-out process test assertions here
  });
}
