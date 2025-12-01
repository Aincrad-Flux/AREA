import 'package:area/app.dart';
import 'package:flutter_test/flutter_test.dart';

extension AreaTester on WidgetTester {
  Future<void> pumpAreaApp() async {
    await pumpWidget(const AreaApp());
    await pumpAndSettle();
  }
}

