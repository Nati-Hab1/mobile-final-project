class InvestorIntro {
  final int id;
  final int startupId;
  final int investorId;
  final String introText;
  final String startupTitle;
  final String startupOwnerName;
  final String? startupOwnerEmail;
  final String status;
  final DateTime createdAt;

  InvestorIntro({
    required this.id,
    required this.startupId,
    required this.investorId,
    required this.introText,
    required this.startupTitle,
    required this.startupOwnerName,
    this.startupOwnerEmail,
    required this.status,
    required this.createdAt,
  });

  factory InvestorIntro.fromJson(Map<String, dynamic> json) {
    return InvestorIntro(
      id: json['id'],
      startupId: json['startup_id'],
      investorId: json['investor_id'],
      introText: json['intro_text'],
      startupTitle: json['startup_title'],
      startupOwnerName: json['startup_owner_name'],
      startupOwnerEmail: json['startup_owner_email'],
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startup_id': startupId,
      'investor_id': investorId,
      'intro_text': introText,
      'startup_title': startupTitle,
      'startup_owner_name': startupOwnerName,
      'startup_owner_email': startupOwnerEmail,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
