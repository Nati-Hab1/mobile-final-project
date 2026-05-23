import '../../domain/entities/bookmark.dart';

class BookmarkModel extends Bookmark {
  BookmarkModel({
    required super.id,
    required super.investorId,
    required super.startupId,
    super.note,
    required super.startupTitle,
    required super.startupBlurb,
    required super.ownerName,
    required super.createdAt,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['id'],
      investorId: json['investor_id'],
      startupId: json['startup_id'],
      note: json['note'],
      startupTitle: json['startup_title'],
      startupBlurb: json['startup_blurb'],
      ownerName: json['startup_owner_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'investor_id': investorId,
      'startup_id': startupId,
      'note': note,
      'startup_title': startupTitle,
      'startup_blurb': startupBlurb,
      'startup_owner_name': ownerName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
