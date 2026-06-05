import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/investor/domain/entities/bookmark.dart';

void main() {
  group('Bookmark Entity', () {
    final createdAt = DateTime.now();

    final bookmark = Bookmark(
      id: 1,
      investorId: 2,
      startupId: 3,
      note: 'This startup looks promising',
      startupTitle: 'Tech Startup',
      startupBlurb: 'We build amazing tech',
      ownerName: 'John Founder',
      createdAt: createdAt,
    );

    test('should create Bookmark instance correctly', () {
      expect(bookmark.id, 1);
      expect(bookmark.investorId, 2);
      expect(bookmark.startupId, 3);
      expect(bookmark.note, 'This startup looks promising');
      expect(bookmark.startupTitle, 'Tech Startup');
      expect(bookmark.ownerName, 'John Founder');
    });

    test('should convert from JSON correctly', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'investor_id': 2,
        'startup_id': 3,
        'note': 'This startup looks promising',
        'startup_title': 'Tech Startup',
        'startup_blurb': 'We build amazing tech',
        'startup_owner_name': 'John Founder',
        'created_at': createdAt.toIso8601String(),
      };

      final bookmarkFromJson = Bookmark.fromJson(json);

      expect(bookmarkFromJson.id, 1);
      expect(bookmarkFromJson.startupTitle, 'Tech Startup');
      expect(bookmarkFromJson.note, 'This startup looks promising');
    });

    test('should convert to JSON correctly', () {
      final json = bookmark.toJson();

      expect(json['id'], 1);
      expect(json['investor_id'], 2);
      expect(json['startup_id'], 3);
      expect(json['note'], 'This startup looks promising');
      expect(json['startup_title'], 'Tech Startup');
    });

    test('should handle null note', () {
      final bookmarkNoNote = Bookmark(
        id: 2,
        investorId: 3,
        startupId: 4,
        note: null,
        startupTitle: 'Startup',
        startupBlurb: 'Description',
        ownerName: 'Owner',
        createdAt: createdAt,
      );

      expect(bookmarkNoNote.note, null);
    });
  });
}
