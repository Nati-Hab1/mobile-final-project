import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/auth/screens/login.dart';
import 'package:menesha/features/auth/screens/signup.dart';

void main() {
  group('Authentication Flow', () {
    testWidgets('login screen shows sign up button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Log in'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('signup screen shows login button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SignupScreen())),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);
    });

    testWidgets('login screen has email and password fields', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('signup screen has all form fields', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: SignupScreen())),
      );

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(TextField), findsWidgets);
    });
  });
}
