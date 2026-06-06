import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/investor/screens/investor_bookmarks.dart';

void main() {
  group('Investor Flow', () {
    testWidgets('bookmarks screen renders without crashing', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: InvestorBookmarks(),
          ),
        ),
      );
      
      await tester.pump(const Duration(milliseconds: 500));
      
      // Just verify the widget builds without error
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}