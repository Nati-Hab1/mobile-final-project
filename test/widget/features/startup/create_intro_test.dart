import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/startup/screens/create_intro.dart';

void main() {
  group('CreateIntro Widget', () {
    testWidgets('create intro can be instantiated', (tester) async {
      expect(
        () => ProviderScope(
          child: MaterialApp(
            home: CreateIntro(),
          ),
        ),
        isNot(throwsException),
      );
    });
  });
}