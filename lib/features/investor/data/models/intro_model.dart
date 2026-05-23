import '../../domain/entities/intro.dart';

class IntroModel extends InvestorIntro {
  IntroModel({
    required super.id,
    required super.startupId,
    required super.investorId,
    required super.introText,
    required super.startupTitle,
    required super.startupOwnerName,
    super.startupOwnerEmail,
    required super.status,
    required super.createdAt,
  });

  factory IntroModel.fromJson(Map<String, dynamic> json) {
    return IntroModel(
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
