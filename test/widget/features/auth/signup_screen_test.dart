import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/auth/screens/signup.dart';

void main() {
  group('SignupScreen Widget', () {
    testWidgets('renders signup form correctly', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SignupScreen())),
      );

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);
    });

    testWidgets('shows all input fields', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SignupScreen())),
      );

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('shows register button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SignupScreen())),
      );

      expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);
    });
  });
}
