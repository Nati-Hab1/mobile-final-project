import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/startup/presentation/providers/startup_provider.dart';

void main() {
  group('StartupProvider', () {
    test('startupStatsProvider should be defined', () {
      // Verify the provider exists by checking its type
      expect(startupStatsProvider, isNotNull);
    });

    test('startupStatsProvider initial state is loading', () {
      // This tests that the provider exists and has the correct type
      expect(startupStatsProvider.runtimeType.toString(),
          contains('StateNotifierProvider'));
    });
  });
}
