import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/investor/screens/investor_bookmarks.dart';

void main() {
  group('InvestorBookmarks Widget', () {
    testWidgets('bookmarks screen can be instantiated', (tester) async {
      expect(
        () => ProviderScope(
          child: MaterialApp(
            home: InvestorBookmarks(),
          ),
        ),
        isNot(throwsException), // Fixed: Wrapped matcher properly
      );
    });
  });
}
