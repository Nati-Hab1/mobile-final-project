import 'user_model.dart';

class AuthResponseModel {
  final UserModel user;
  final String? token;
  final List<String> roles;
  
  AuthResponseModel({
    required this.user,
    this.token,
    required this.roles,
  });
  
  // For login response (has token)
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json['data']['user']),
      token: json['data']['token'],
      roles: json['data']['roles'] != null 
          ? List<String>.from(json['data']['roles']) 
          : [],
    );
  }
}

class RoleTokenResponseModel {
  final String token;
  final String role;
  
  RoleTokenResponseModel({
    required this.token,
    required this.role,
  });
  
  factory RoleTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RoleTokenResponseModel(
      token: json['data']['token'],
      role: json['data']['role'],
    );
  }
}