import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/startup/screens/add_startup.dart';

void main() {
  group('AddStartup Widget', () {
    testWidgets('renders add startup form', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AddStartup(),
          ),
        ),
      );

      expect(find.text('Add Startup'), findsWidgets);
      expect(find.text('Startup Name'), findsOneWidget);
      expect(find.text('Blurb'), findsOneWidget);
      expect(find.text('Pitch Link (Optional)'),
          findsOneWidget);
    });

    testWidgets('shows back button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AddStartup(),
          ),
        ),
      );

      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('shows form fields', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AddStartup(),
          ),
        ),
      );

      expect(find.byType(TextField), findsWidgets);
    });
  });
}
