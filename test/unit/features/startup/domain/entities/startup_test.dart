import 'package:flutter_test/flutter_test.dart';
import 'package:menesha/features/startup/domain/entities/startup.dart';

void main() {
  group('Startup Entity', () {
    final createdAt = DateTime.now();
    final updatedAt = DateTime.now();

    final startup = Startup(
      id: 1,
      ownerId: 2,
      title: 'Tech Startup',
      blurb: 'We build amazing tech solutions',
      pitchLink: 'https://youtu.be/example',
      ownerName: 'John Founder',
      ownerEmail: 'john@startup.com',
      ownerPhone: '+251912345678',
      createdAt: createdAt,
      updatedAt: updatedAt,
      isBookmarked: true,
    );

    test('should create Startup instance correctly', () {
      expect(startup.id, 1);
      expect(startup.title, 'Tech Startup');
      expect(
          startup.blurb, 'We build amazing tech solutions');
      expect(startup.ownerName, 'John Founder');
      expect(startup.isBookmarked, true);
    });

    test('should convert from JSON correctly', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'owner_id': 2,
        'title': 'Tech Startup',
        'blurb': 'We build amazing tech solutions',
        'pitch_link': 'https://youtu.be/example',
        'owner_name': 'John Founder',
        'owner_email': 'john@startup.com',
        'owner_phone': '+251912345678',
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'is_bookmarked': true,
      };

      final startupFromJson = Startup.fromJson(json);

      expect(startupFromJson.id, 1);
      expect(startupFromJson.title, 'Tech Startup');
      expect(startupFromJson.blurb,
          'We build amazing tech solutions');
      expect(startupFromJson.isBookmarked, true);
    });

    test('should convert to JSON correctly', () {
      final json = startup.toJson();

      expect(json['id'], 1);
      expect(json['title'], 'Tech Startup');
      expect(
          json['blurb'], 'We build amazing tech solutions');
      expect(json['is_bookmarked'], true);
    });

    test('should handle null pitchLink', () {
      final startupNoPitch = Startup(
        id: 2,
        ownerId: 3,
        title: 'No Pitch Startup',
        blurb: 'Description here',
        pitchLink: null,
        ownerName: 'Jane Founder',
        ownerEmail: 'jane@startup.com',
        ownerPhone: null,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isBookmarked: false,
      );

      expect(startupNoPitch.pitchLink, null);
      expect(startupNoPitch.ownerPhone, null);
    });

    test('should copyWith create modified instance', () {
      final updatedStartup = startup.copyWith(
        title: 'Updated Title',
        blurb: 'Updated description',
      );

      expect(updatedStartup.id, startup.id);
      expect(updatedStartup.title, 'Updated Title');
      expect(updatedStartup.blurb, 'Updated description');
    });

    test('two startups with same id should be equal', () {
      final startup1 = Startup(
        id: 1,
        ownerId: 2,
        title: 'Test',
        blurb: 'Blurb',
        pitchLink: null,
        ownerName: 'Owner',
        ownerEmail: 'owner@test.com',
        ownerPhone: null,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isBookmarked: false,
      );

      final startup2 = Startup(
        id: 1,
        ownerId: 2,
        title: 'Different Title',
        blurb: 'Different Blurb',
        pitchLink: 'https://example.com',
        ownerName: 'Different Owner',
        ownerEmail: 'different@test.com',
        ownerPhone: '+251911223344',
        createdAt: createdAt,
        updatedAt: updatedAt,
        isBookmarked: true,
      );

      expect(startup1 == startup2, true);
      expect(startup1.hashCode, startup2.hashCode);
    });
  });
}
