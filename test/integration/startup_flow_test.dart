import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/startup/screens/add_startup.dart';

void main() {
  group('Startup Flow', () {
    testWidgets('add startup screen shows form fields', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AddStartup(),
          ),
        ),
      );
      
      await tester.pump(const Duration(milliseconds: 500));
      
      expect(find.text('Add Startup'), findsWidgets);
      expect(find.text('Startup Name'), findsOneWidget);
      expect(find.text('Blurb'), findsOneWidget);
      expect(find.text('Pitch Link (Optional)'), findsOneWidget);
    });
    
    testWidgets('add startup screen has back button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AddStartup(),
          ),
        ),
      );
      
      await tester.pump(const Duration(milliseconds: 500));
      
      expect(find.text('Back'), findsOneWidget);
    });
    
    testWidgets('add startup screen has add startup button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AddStartup(),
          ),
        ),
      );
      
      await tester.pump(const Duration(milliseconds: 500));
      
      expect(find.text('Add Startup'), findsWidgets);
    });
  });
}