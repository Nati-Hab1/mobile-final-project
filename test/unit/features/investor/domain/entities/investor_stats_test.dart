import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/investor/domain/entities/investor_stats.dart';

void main() {
  group('InvestorStats Entity', () {
    final stats = InvestorStats(
      totalIntros: 10,
      followUps: 3,
      startupsCount: 5,
      completedIntros: 2,
    );

    test('should create InvestorStats instance correctly', () {
      expect(stats.totalIntros, 10);
      expect(stats.followUps, 3);
      expect(stats.startupsCount, 5);
      expect(stats.completedIntros, 2);
    });

    test('should convert from JSON correctly', () {
      final Map<String, dynamic> json = {
        'total_intros': 10,
        'follow_ups': 3,
        'startups_count': 5,
        'completed_intros': 2,
      };

      final statsFromJson = InvestorStats.fromJson(json);

      expect(statsFromJson.totalIntros, 10);
      expect(statsFromJson.followUps, 3);
      expect(statsFromJson.startupsCount, 5);
      expect(statsFromJson.completedIntros, 2);
    });

    test('should convert to JSON correctly', () {
      final json = stats.toJson();

      expect(json['total_intros'], 10);
      expect(json['follow_ups'], 3);
      expect(json['startups_count'], 5);
      expect(json['completed_intros'], 2);
    });

    test('should handle missing fields with default values', () {
      final Map<String, dynamic> json = {};

      final statsFromJson = InvestorStats.fromJson(json);

      expect(statsFromJson.totalIntros, 0);
      expect(statsFromJson.followUps, 0);
      expect(statsFromJson.startupsCount, 0);
      expect(statsFromJson.completedIntros, 0);
    });
  });
}
