import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/investor/screens/investor_dashboard.dart';

void main() {
  group('InvestorDashboard Widget', () {
    testWidgets('investor dashboard can be instantiated', (tester) async {
      expect(
        () => ProviderScope(
          child: MaterialApp(
            home: InvestorDashboard(),
          ),
        ),
        isNot(throwsException), // Fixed: Wrapped matcher properly
      );
    });
  });
}
