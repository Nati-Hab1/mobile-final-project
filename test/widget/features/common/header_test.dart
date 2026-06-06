import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/core/widgets/common/header.dart';

void main() {
  group('Header Widget', () {
    testWidgets('renders with startup role',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: Header(role: 'startup'),
            body: Container(),
          ),
        ),
      );

      expect(find.byType(Image), findsWidgets);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('renders with investor role',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: Header(role: 'investor'),
            body: Container(),
          ),
        ),
      );

      expect(find.byType(Image), findsWidgets);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('shows profile image', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: Header(role: 'startup'),
            body: Container(),
          ),
        ),
      );

      expect(find.byType(Image), findsWidgets);
    });
  });
}
