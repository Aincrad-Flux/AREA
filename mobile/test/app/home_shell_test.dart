import 'package:area/app.dart';
import 'package:area/screens/dashboard_screen.dart';
import 'package:area/screens/pipeline_editor_screen.dart';
import 'package:area/screens/profile_screen.dart';
import 'package:area/screens/services_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/tester_extensions.dart';

void main() {
  group('HomeShell', () {
    testWidgets('shows PipelineEditorScreen by default', (tester) async {
      await tester.pumpAreaApp();
      await tester.pumpAndSettle();

      expect(find.byType(PipelineEditorScreen), findsOneWidget);
      expect(find.byType(DashboardScreen), findsNothing);
    });

    Future<void> _tapDestination(WidgetTester tester, IconData icon) async {
      await tester.tap(find.byIcon(icon));
      await tester.pumpAndSettle();
    }

    testWidgets('switches between tabs when bottom navigation pressed', (tester) async {
      await tester.pumpAreaApp();
      await tester.pumpAndSettle();

      await _tapDestination(tester, Icons.dashboard_outlined);
      expect(find.byType(DashboardScreen), findsOneWidget);

      await _tapDestination(tester, Icons.device_hub_outlined);
      expect(find.byType(PipelineEditorScreen), findsOneWidget);

      await _tapDestination(tester, Icons.extension_outlined);
      expect(find.byType(ServicesScreen), findsOneWidget);

      await _tapDestination(tester, Icons.person_outline);
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('preserves state across tabs via IndexedStack', (tester) async {
      await tester.pumpAreaApp();
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      await tester.enterText(textField, 'Automation X');
      await tester.pump();

      await _tapDestination(tester, Icons.dashboard_outlined);
      await _tapDestination(tester, Icons.device_hub_outlined);

      expect(find.text('Automation X'), findsOneWidget);
    });
  });
}
