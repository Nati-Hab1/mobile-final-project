import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/auth/screens/role_selection.dart';

void main() {
  group('RoleSelectionScreen Widget', () {
    testWidgets('renders role selection correctly',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RoleSelectionScreen(),
          ),
        ),
      );

      expect(find.text('Choose Role'), findsOneWidget);
      expect(find.text('Investor'), findsOneWidget);
      expect(find.text('Startup'), findsOneWidget);
    });

    testWidgets('shows both role buttons', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RoleSelectionScreen(),
          ),
        ),
      );

      // Find buttons by text instead of type (since PrimaryButton is a custom widget)
      expect(find.text('Investor'), findsOneWidget);
      expect(find.text('Startup'), findsOneWidget);
    });
  });
}
