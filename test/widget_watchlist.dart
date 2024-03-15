import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g21097717/HomePage.dart'; // Adjust the import path as needed

void main() {
  testWidgets('Watchlist icon presence test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));
    // Assuming IconButton is used for the watchlist icon; adjust if necessary
    final watchlistIconFinder = find.byIcon(Icons.playlist_add);
    expect(watchlistIconFinder, findsOneWidget);
  });
}
