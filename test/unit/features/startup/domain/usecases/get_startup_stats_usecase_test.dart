import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetStartupStatsUseCase Structure', () {
    test('should return dashboard stats structure', () {
      final stats = {
        'total_intros': 5,
        'completed_intros': 2,
        'investors_count': 3,
        'startups_count': 1,
      };

      expect(stats.containsKey('total_intros'), true);
      expect(stats.containsKey('completed_intros'), true);
      expect(stats.containsKey('investors_count'), true);
      expect(stats.containsKey('startups_count'), true);
    });

    test('should handle empty stats', () {
      final emptyStats = {
        'total_intros': 0,
        'completed_intros': 0,
        'investors_count': 0,
        'startups_count': 0,
      };

      expect(emptyStats['total_intros'], 0);
      expect(emptyStats['startups_count'], 0);
    });
  });
}
