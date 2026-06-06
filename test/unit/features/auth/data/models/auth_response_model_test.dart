import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/auth/data/models/auth_response_model.dart';
import 'package:menesha/features/auth/data/models/user_model.dart';

void main() {
  group('AuthResponseModel', () {
    final createdAt = DateTime.now();

    test('should create from login response JSON', () {
      final Map<String, dynamic> json = {
        'data': {
          'user': {
            'id': 1,
            'full_name': 'Test User',
            'email': 'test@example.com',
            'phone_number': '+251912345678',
            'created_at': createdAt.toIso8601String(),
            'roles': ['startup'],
          },
          'token': 'jwt_token_123',
          'roles': ['startup', 'investor'],
        },
      };

      final response = AuthResponseModel.fromJson(json);

      expect(response.user.id, 1);
      expect(response.user.fullName, 'Test User');
      expect(response.token, 'jwt_token_123');
      expect(response.roles, ['startup', 'investor']);
    });
  });

  group('RoleTokenResponseModel', () {
    test('should create from JSON correctly', () {
      final Map<String, dynamic> json = {
        'data': {
          'token': 'role_specific_token',
          'role': 'startup',
        },
      };

      final response =
          RoleTokenResponseModel.fromJson(json);

      expect(response.token, 'role_specific_token');
      expect(response.role, 'startup');
    });
  });
}
