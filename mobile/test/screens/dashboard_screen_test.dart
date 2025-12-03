import 'package:area/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardScreen', () {
    Future<void> pump(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));
    }

    testWidgets('renders header and CTA', (tester) async {
      await pump(tester);

      expect(find.text('My Automations'), findsOneWidget);
      expect(find.text('Manage your AREA workflows'), findsOneWidget);
      expect(find.widgetWithIcon(FilledButton, Icons.add), findsOneWidget);
      expect(find.text('New AREA'), findsOneWidget);
    });

    testWidgets('lists sample workflows', (tester) async {
      await pump(tester);

      expect(find.text('GitHub → Discord'), findsOneWidget);
      expect(find.textContaining('nodes •'), findsNWidgets(3));
    });
  });
}

