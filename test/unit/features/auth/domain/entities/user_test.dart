import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/auth/domain/entities/user.dart';

void main() {
  group('User Entity', () {
    final createdAt = DateTime.now();
    final user = User(
      id: 1,
      fullName: 'John Doe',
      email: 'john@example.com',
      phoneNumber: '+251912345678',
      createdAt: createdAt,
      roles: ['startup', 'investor'],
    );

    test('should create User instance correctly', () {
      expect(user.id, 1);
      expect(user.fullName, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.phoneNumber, '+251912345678');
      expect(user.roles, ['startup', 'investor']);
    });

    test('should convert from JSON correctly', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'full_name': 'John Doe',
        'email': 'john@example.com',
        'phone_number': '+251912345678',
        'created_at': createdAt.toIso8601String(),
        'roles': ['startup', 'investor'],
      };

      final userFromJson = User.fromJson(json);

      expect(userFromJson.id, 1);
      expect(userFromJson.fullName, 'John Doe');
      expect(userFromJson.email, 'john@example.com');
      expect(userFromJson.roles, ['startup', 'investor']);
    });

    test('should convert to JSON correctly', () {
      final json = user.toJson();

      expect(json['id'], 1);
      expect(json['full_name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['roles'], ['startup', 'investor']);
    });
  });
}
