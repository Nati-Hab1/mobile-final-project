import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/startup/domain/entities/startup.dart';

void main() {
  group('Startup Model JSON', () {
    final createdAt = DateTime.now();
    final updatedAt = DateTime.now();

    test('should handle all fields correctly', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'owner_id': 2,
        'title': 'Test Startup',
        'blurb': 'Test description',
        'pitch_link': 'https://example.com',
        'owner_name': 'Test Owner',
        'owner_email': 'owner@test.com',
        'owner_phone': '+251911223344',
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'is_bookmarked': false,
      };

      final startup = Startup.fromJson(json);

      expect(startup.id, 1);
      expect(startup.title, 'Test Startup');
      expect(startup.blurb, 'Test description');
      expect(startup.pitchLink, 'https://example.com');
      expect(startup.ownerName, 'Test Owner');
      expect(startup.ownerEmail, 'owner@test.com');
      expect(startup.ownerPhone, '+251911223344');
    });

    test('should handle missing optional fields', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'owner_id': 2,
        'title': 'Minimal Startup',
        'blurb': 'Minimal description',
        'owner_name': 'Minimal Owner',
        'owner_email': 'minimal@test.com',
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

      final startup = Startup.fromJson(json);

      expect(startup.id, 1);
      expect(startup.title, 'Minimal Startup');
      expect(startup.pitchLink, null);
      expect(startup.ownerPhone, null);
      expect(startup.isBookmarked, false);
    });
  });
}
