class User {
  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final DateTime createdAt;
  final List<String> roles;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.createdAt,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
