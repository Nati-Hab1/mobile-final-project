import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/core/widgets/loading_widget.dart';

void main() {
  group('LoadingWidget', () {
    testWidgets('renders loading indicator',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator),
          findsOneWidget);
    });

    testWidgets('shows custom message when provided',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(message: 'Loading data...'),
          ),
        ),
      );

      expect(find.text('Loading data...'), findsOneWidget);
    });
  });

  group('LoadingOverlay', () {
    testWidgets('shows overlay when isLoading is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: true,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator),
          findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets(
        'does not show overlay when isLoading is false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingOverlay(
              isLoading: false,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator),
          findsNothing);
      expect(find.text('Content'), findsOneWidget);
    });
  });
}
