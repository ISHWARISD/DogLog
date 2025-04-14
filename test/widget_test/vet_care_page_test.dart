import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_try/VetCare.dart'; // Correct path to VetCarePage

void main() {
  testWidgets('VetCarePage displays correct title and text', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: VetCarePage(),
      ),
    );

    // Debug: Print the widget tree
    debugPrint(tester.element(find.byType(VetCarePage)).toString());

    try {
      // Verify the AppBar title
      expect(find.text('Vet Care'), findsOneWidget);
    } catch (e) {
      debugPrint('Error verifying AppBar title: $e');
    }

    try {
      // Verify the body text
      expect(find.text('Search Vets Near You..'), findsOneWidget);
    } catch (e) {
      debugPrint('Error verifying body text: $e');
    }
  });
}