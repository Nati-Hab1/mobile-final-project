import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/investor/screens/investor_notes.dart';

void main() {
  group('InvestorNotes Widget', () {
    testWidgets('investor notes can be instantiated',
        (tester) async {
      expect(
        () => ProviderScope(
          child: MaterialApp(
            home: InvestorNotes(role: 'investor'),
          ),
        ),
        isNot(throwsException),
      );
    });
  });
}
