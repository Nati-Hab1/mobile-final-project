import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/investor/screens/investor_startups.dart';

void main() {
  group('InvestorStartups Widget', () {
    testWidgets('investor startups can be instantiated', (tester) async {
      expect(
        () => ProviderScope(
          child: MaterialApp(
            home: InvestorStartups(),
          ),
        ),
        isNot(throwsException),
      );
    });
  });
}