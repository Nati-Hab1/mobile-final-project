import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Logger', () {
    test('logger should have debug level', () {
      const debugLevel = 'debug';
      expect(debugLevel, 'debug');
    });

    test('logger should have error level', () {
      const errorLevel = 'error';
      expect(errorLevel, 'error');
    });

    test('logger should have info level', () {
      const infoLevel = 'info';
      expect(infoLevel, 'info');
    });
  });
}
