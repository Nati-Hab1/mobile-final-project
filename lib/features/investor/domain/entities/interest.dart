class InvestorInterest {
  final int id;
  final int startupId;
  final int investorId;
  final String? message;
  final String status;
  final String startupTitle;
  final String startupOwnerName;
  final DateTime createdAt;
  final DateTime updatedAt;

  InvestorInterest({
    required this.id,
    required this.startupId,
    required this.investorId,
    this.message,
    required this.status,
    required this.startupTitle,
    required this.startupOwnerName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InvestorInterest.fromJson(Map<String, dynamic> json) {
    return InvestorInterest(
      id: json['id'],
      startupId: json['startup_id'],
      investorId: json['investor_id'],
      message: json['message'],
      status: json['status'] ?? 'pending',
      startupTitle: json['startup_title'],
      startupOwnerName: json['startup_owner_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startup_id': startupId,
      'investor_id': investorId,
      'message': message,
      'status': status,
      'startup_title': startupTitle,
      'startup_owner_name': startupOwnerName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
