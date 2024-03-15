import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g21097717/HomePage.dart'; // Adjust the import path as needed
import 'package:g21097717/SearchFunction.dart';

void main() {
  testWidgets('Search bar presence test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage()));
    expect(find.byType(SearchFunction), findsOneWidget);
  });
}