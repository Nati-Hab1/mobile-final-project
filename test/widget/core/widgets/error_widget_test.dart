import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/core/widgets/error_widget.dart';

void main() {
  group('ErrorDisplayWidget', () {
    testWidgets('displays error message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(
              message: 'Something went wrong',
            ),
          ),
        ),
      );

      expect(find.text('Something went wrong'),
          findsOneWidget);
      expect(find.text('Oops! Something went wrong'),
          findsOneWidget);
    });

    testWidgets(
        'shows retry button when onRetry is provided',
        (tester) async {
      var retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(
              message: 'Error occurred',
              onRetry: () {
                retryCalled = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Try Again'), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      await tester.pump();

      expect(retryCalled, true);
    });

    testWidgets(
        'does not show retry button when onRetry is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorDisplayWidget(
              message: 'Error occurred',
            ),
          ),
        ),
      );

      expect(find.text('Try Again'), findsNothing);
    });
  });
}
