import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/core/utils/validators.dart';

void main() {
  group('Validators - Email Validation', () {
    test('returns null for valid email', () {
      expect(Validators.validateEmail('user@example.com'), null);
      expect(Validators.validateEmail('name@gmail.com'), null);
    });

    test('returns error for null email', () {
      expect(Validators.validateEmail(null), 'Email is required');
    });

    test('returns error for empty email', () {
      expect(Validators.validateEmail(''), 'Email is required');
    });

    test('returns error for email without @', () {
      expect(Validators.validateEmail('userexample.com'), isNotNull);
    });
  });

  group('Validators - Password Validation', () {
    test('returns null for valid password (6+ chars)', () {
      expect(Validators.validatePassword('123456'), null);
    });

    test('returns error for null password', () {
      expect(Validators.validatePassword(null), 'Password is required');
    });

    test('returns error for password shorter than 6 chars', () {
      expect(Validators.validatePassword('12345'),
          'Password must be at least 6 characters');
    });
  });

  group('Validators - Full Name Validation', () {
    test('returns null for valid name', () {
      expect(Validators.validateFullName('John Doe'), null);
    });

    test('returns error for empty name', () {
      expect(Validators.validateFullName(''), 'Full name is required');
    });
  });

  group('Validators - Phone Number Validation', () {
    test('returns null for null phone (optional)', () {
      expect(Validators.validatePhoneNumber(null), null);
    });

    test('returns null for valid phone', () {
      expect(Validators.validatePhoneNumber('+251912345678'), null);
    });
  });

  group('Validators - Startup Title Validation', () {
    test('returns null for valid title', () {
      expect(Validators.validateStartupTitle('My Startup'), null);
    });

    test('returns error for title too short', () {
      expect(Validators.validateStartupTitle('AB'),
          'Title must be at least 3 characters');
    });
  });
}
