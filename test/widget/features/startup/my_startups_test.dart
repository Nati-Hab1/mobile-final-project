import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/startup/screens/my_startup.dart';

void main() {
  group('MyStartups Widget', () {
    testWidgets('renders my startups page', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MyStartups(),
          ),
        ),
      );

      expect(find.text('My Startups'), findsOneWidget);
      expect(find.text('Manage your startup profiles'), findsOneWidget);
      expect(find.text('New Startup'), findsOneWidget);
    });

    testWidgets('shows back button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MyStartups(),
          ),
        ),
      );

      expect(find.text('Back'), findsOneWidget);
    });
  });
}
