import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/common/screens/about_us.dart';

void main() {
  group('AboutUs Widget', () {
    testWidgets('renders about us page with startup role',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: AboutUs(role: 'startup'),
          ),
        ),
      );

      // Use find.textContaining or find by specific text
      expect(find.textContaining('About Us'), findsWidgets);
      expect(find.text('Our Purpose'), findsOneWidget);
      expect(
          find.text('What We Stand For'), findsOneWidget);
    });

    testWidgets('renders about us page with investor role',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: AboutUs(role: 'investor'),
          ),
        ),
      );

      expect(find.textContaining('About Us'), findsWidgets);
      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('shows back button for authenticated users',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: AboutUs(role: 'startup'),
          ),
        ),
      );

      expect(find.text('Back'), findsOneWidget);
    });
  });
}
