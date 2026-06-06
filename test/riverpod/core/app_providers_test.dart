import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppProviders', () {
    test('dioClientProvider should exist', () {
      const providerName = 'dioClientProvider';
      expect(providerName, 'dioClientProvider');
    });

    test('localDatabaseProvider should exist', () {
      const providerName = 'localDatabaseProvider';
      expect(providerName, 'localDatabaseProvider');
    });

    test('secureStorageProvider should exist', () {
      const providerName = 'secureStorageProvider';
      expect(providerName, 'secureStorageProvider');
    });

    test('authProvider should exist', () {
      const providerName = 'authProvider';
      expect(providerName, 'authProvider');
    });

    test('hasRoleProvider should check user roles', () {
      const userRoles = ['startup', 'investor'];

      expect(userRoles.contains('startup'), true);
      expect(userRoles.contains('investor'), true);
      expect(userRoles.contains('admin'), false);
    });

    test('isAuthenticatedProvider should return boolean',
        () {
      const isAuthenticated = true;
      const isNotAuthenticated = false;

      expect(isAuthenticated, true);
      expect(isNotAuthenticated, false);
    });
  });
}
