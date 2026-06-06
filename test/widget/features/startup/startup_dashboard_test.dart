import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/startup/screens/startup_dashboard.dart';

void main() {
  group('StartupDashboard Widget', () {
    testWidgets('startup dashboard can be instantiated', (tester) async {
      expect(
        () => ProviderScope(
          child: MaterialApp(
            home: StartupDashboard(),
          ),
        ),
        isNot(throwsException),
      );
    });
  });
}