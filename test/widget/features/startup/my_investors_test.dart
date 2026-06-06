import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/startup/screens/my_investors.dart';

void main() {
  group('MyInvestors Widget', () {
    testWidgets('renders my investors page', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MyInvestors(),
          ),
        ),
      );

      expect(find.text('My Investors'), findsOneWidget);
      expect(find.text('Manage your investor list'), findsOneWidget);
    });

    testWidgets('shows search bar', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MyInvestors(),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows back button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MyInvestors(),
          ),
        ),
      );

      expect(find.text('Back'), findsOneWidget);
    });
  });
}
