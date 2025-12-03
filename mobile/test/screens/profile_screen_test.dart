import 'package:area/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProfileScreen', () {
    Future<void> pump(WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    }

    testWidgets('shows user avatar and info', (tester) async {
      await pump(tester);

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('You'), findsOneWidget);
      expect(find.text('team@area.app'), findsOneWidget);
    });
  });
}

