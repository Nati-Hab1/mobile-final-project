class InvestorStartup {
  final int id;
  final int ownerId;
  final String title;
  final String blurb;
  final String? pitchLink;
  final String ownerName;
  final String ownerEmail;
  final String? ownerPhone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isBookmarked;

  InvestorStartup({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.blurb,
    this.pitchLink,
    required this.ownerName,
    required this.ownerEmail,
    this.ownerPhone,
    required this.createdAt,
    required this.updatedAt,
    this.isBookmarked = false,
  });

  factory InvestorStartup.fromJson(Map<String, dynamic> json) {
    return InvestorStartup(
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
