class Bookmark {
  final int id;
  final int investorId;
  final int startupId;
  final String? note;
  final String startupTitle;
  final String startupBlurb;
  final String ownerName;
  final DateTime createdAt;

  Bookmark({
    required this.id,
    required this.investorId,
    required this.startupId,
    this.note,
    required this.startupTitle,
    required this.startupBlurb,
    required this.ownerName,
    required this.createdAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
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
