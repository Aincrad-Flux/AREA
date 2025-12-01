import 'package:area/screens/services_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServicesScreen', () {
    Future<void> pump(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ServicesScreen()));
    }

    testWidgets('shows services grid', (tester) async {
      await pump(tester);

      expect(find.text('Connected Services'), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);
      // Each service renders "Connected" subtitle
      expect(find.text('Connected'), findsWidgets);
    });
  });
}

