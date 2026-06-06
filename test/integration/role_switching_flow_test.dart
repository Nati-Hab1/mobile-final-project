import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/auth/screens/role_selection.dart';

void main() {
  group('Role Switching Flow', () {
    testWidgets('role selection screen renders correctly',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RoleSelectionScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('role selection screen has title',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RoleSelectionScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Choose Role'), findsOneWidget);
    });

    testWidgets('role selection screen has both buttons',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RoleSelectionScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Investor'), findsOneWidget);
      expect(find.text('Startup'), findsOneWidget);
    });
  });
}
