import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g21097717/HomePage.dart'; // Adjust the import path as needed

void main() {
  testWidgets('Sign out icon presence test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));
    // Assuming IconButton is used for the sign out icon; adjust if necessary
    final signOutIconFinder = find.byIcon(Icons.exit_to_app);
    expect(signOutIconFinder, findsOneWidget);
  });
}
