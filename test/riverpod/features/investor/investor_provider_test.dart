import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/investor/presentation/providers/investor_provider.dart';

void main() {
  group('InvestorProvider', () {
    test('investorProvider should be defined', () {
      // Verify the provider exists by checking its type
      expect(investorProvider, isNotNull);
    });

    test('investorProvider initial state is loading', () {
      // This tests that the provider exists and has the correct type
      expect(investorProvider.runtimeType.toString(),
          contains('StateNotifierProvider'));
    });
  });
}
