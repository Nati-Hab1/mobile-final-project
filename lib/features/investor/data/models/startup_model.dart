import '../../domain/entities/startup.dart';

class StartupModel extends InvestorStartup {
  StartupModel({
    required super.id,
    required super.ownerId,
    required super.title,
    required super.blurb,
    super.pitchLink,
    required super.ownerName,
    required super.ownerEmail,
    super.ownerPhone,
    required super.createdAt,
    required super.updatedAt,
    super.isBookmarked,
  });

  factory StartupModel.fromJson(Map<String, dynamic> json) {
    return StartupModel(
      id: json['id'],
      ownerId: json['owner_id'],
      title: json['title'],
      blurb: json['blurb'],
      pitchLink: json['pitch_link'],
      ownerName: json['owner_name'],
      ownerEmail: json['owner_email'],
      ownerPhone: json['owner_phone'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isBookmarked: json['is_bookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'title': title,
      'blurb': blurb,
      'pitch_link': pitchLink,
      'owner_name': ownerName,
      'owner_email': ownerEmail,
      'owner_phone': ownerPhone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_bookmarked': isBookmarked,
    };
  }
}
