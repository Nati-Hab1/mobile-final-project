import 'dart:convert';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  final DioClient _dioClient;
  
  AuthRemoteDatasource(this._dioClient);
  
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    final response = await DioClient.post(
      ApiConstants.register,
      data: {
        'full_name': fullName,
        'email': email,
        'password': password,
        'phone_number': phoneNumber,
      },
    );
    
    // Register response: { "success": true, "message": "...", "data": { "user": {...} } }
    // No token in this response
    final userData = response.data['data']['user'];
    return UserModel.fromJson(userData);
  }
  
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await DioClient.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    
    // Login response: { "success": true, "message": "...", "data": { "user": {...}, "token": "...", "roles": [...] } }
    return AuthResponseModel.fromJson(response.data);
  }
  
  Future<void> addRole(String role) async {
    await DioClient.post(
      ApiConstants.addRole,
      data: {'role': role},
    );
  }
  
  Future<RoleTokenResponseModel> getRoleToken(String role) async {
    final response = await DioClient.post(
      ApiConstants.roleToken,
      data: {'role': role},
    );
    
    return RoleTokenResponseModel.fromJson(response.data);
  }
  
  Future<UserModel> getCurrentUser() async {
    final response = await DioClient.get(ApiConstants.getMe);
    return UserModel.fromJson(response.data['data']['user']);
  }
  
  Future<List<String>> getMyRoles() async {
    final response = await DioClient.get(ApiConstants.myRoles);
    final roles = List<String>.from(response.data['data']['roles']);
    return roles;
  }
  
  Future<void> logout() async {
    await DioClient.post(ApiConstants.logout);
  }
}