import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/investor/domain/entities/bookmark.dart';

void main() {
  group('Bookmark Model JSON', () {
    final createdAt = DateTime.now();

    test('should handle all fields correctly', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'investor_id': 2,
        'startup_id': 3,
        'note': 'Important startup to follow',
        'startup_title': 'AI Startup',
        'startup_blurb':
            'Artificial Intelligence solutions',
        'startup_owner_name': 'AI Founder',
        'created_at': createdAt.toIso8601String(),
      };

      final bookmark = Bookmark.fromJson(json);

      expect(bookmark.id, 1);
      expect(bookmark.investorId, 2);
      expect(bookmark.startupId, 3);
      expect(bookmark.note, 'Important startup to follow');
      expect(bookmark.startupTitle, 'AI Startup');
      expect(bookmark.ownerName, 'AI Founder');
    });

    test('should handle null note', () {
      final Map<String, dynamic> json = {
        'id': 2,
        'investor_id': 3,
        'startup_id': 4,
        'note': null,
        'startup_title': 'Blockchain Startup',
        'startup_blurb': 'Blockchain solutions',
        'startup_owner_name': 'Blockchain Founder',
        'created_at': createdAt.toIso8601String(),
      };

      final bookmark = Bookmark.fromJson(json);

      expect(bookmark.note, null);
      expect(bookmark.startupTitle, 'Blockchain Startup');
    });
  });
}
