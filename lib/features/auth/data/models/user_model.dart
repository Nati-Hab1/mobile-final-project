import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.phoneNumber,
    required super.createdAt,
    required super.roles,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      createdAt: DateTime.parse(json['created_at']),
      roles: List<String>.from(json['roles'] ?? []),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'created_at': createdAt.toIso8601String(),
      'roles': roles,
    };
  }
}