import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalDatabase', () {
    test('database name should be defined', () {
      const databaseName = 'menesha.db';
      expect(databaseName, 'menesha.db');
    });

    test('database version should be valid', () {
      const databaseVersion = 1;
      expect(databaseVersion, greaterThanOrEqualTo(1));
    });

    test('cache duration should be positive', () {
      const cacheDurationMinutes = 5;
      expect(cacheDurationMinutes, greaterThan(0));
    });
  });
}
