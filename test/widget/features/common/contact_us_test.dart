import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/common/screens/contact_us.dart';

void main() {
  group('ContactUs Widget', () {
    testWidgets('renders contact us page', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ContactUs(role: 'guest'),
          ),
        ),
      );

      // Use find.textContaining since there might be multiple "Contact Us" texts
      expect(
          find.textContaining('Contact Us'), findsWidgets);
      expect(find.text('Send Message'), findsOneWidget);
      expect(find.text('Full name*'), findsOneWidget);
      expect(find.text('Email*'), findsOneWidget);
      expect(find.text('Message*'), findsOneWidget);
    });

    testWidgets('shows back button for authenticated users',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ContactUs(role: 'startup'),
          ),
        ),
      );

      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('shows FAQ section', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ContactUs(role: 'guest'),
          ),
        ),
      );

      expect(find.text('Frequently Asked Questions'),
          findsOneWidget);
      expect(find.text('What am I agreeing to?'),
          findsOneWidget);
    });
  });
}
