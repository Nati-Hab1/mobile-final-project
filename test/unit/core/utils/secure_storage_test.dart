import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SecureStorage - Keys', () {
    test('token keys should be defined correctly', () {
      const mainTokenKey = 'main_token';
      const startupTokenKey = 'startup_token';
      const investorTokenKey = 'investor_token';

      expect(mainTokenKey, 'main_token');
      expect(startupTokenKey, 'startup_token');
      expect(investorTokenKey, 'investor_token');
    });

    test('user data keys should be defined correctly', () {
      const userDataKey = 'user_data';
      const userRolesKey = 'user_roles';
      const activeRoleKey = 'active_role';

      expect(userDataKey, 'user_data');
      expect(userRolesKey, 'user_roles');
      expect(activeRoleKey, 'active_role');
    });
  });
}
