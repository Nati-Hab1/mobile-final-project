import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Token management
  static Future<void> saveMainToken(String token) async {
    await _storage.write(key: AppConstants.mainTokenKey, value: token);
  }

  static Future<String?> getMainToken() async {
    return await _storage.read(key: AppConstants.mainTokenKey);
  }

  static Future<void> saveStartupToken(String token) async {
    await _storage.write(key: AppConstants.startupTokenKey, value: token);
  }

  static Future<String?> getStartupToken() async {
    return await _storage.read(key: AppConstants.startupTokenKey);
  }

  static Future<void> saveInvestorToken(String token) async {
    await _storage.write(key: AppConstants.investorTokenKey, value: token);
  }

  static Future<String?> getInvestorToken() async {
    return await _storage.read(key: AppConstants.investorTokenKey);
  }

  // User data management
  static Future<void> saveUserData(String userDataJson) async {
    await _storage.write(key: AppConstants.userDataKey, value: userDataJson);
  }

  static Future<String?> getUserData() async {
    return await _storage.read(key: AppConstants.userDataKey);
  }

  static Future<void> saveUserRoles(String rolesJson) async {
    await _storage.write(key: AppConstants.userRolesKey, value: rolesJson);
  }

  static Future<String?> getUserRoles() async {
    return await _storage.read(key: AppConstants.userRolesKey);
  }

  static Future<void> saveActiveRole(String role) async {
    await _storage.write(key: AppConstants.activeRoleKey, value: role);
  }

  static Future<String?> getActiveRole() async {
    return await _storage.read(key: AppConstants.activeRoleKey);
  }

  // Clear all data (logout)
  static Future<void> clearAll() async {
    await _storage.delete(key: AppConstants.mainTokenKey);
    await _storage.delete(key: AppConstants.startupTokenKey);
    await _storage.delete(key: AppConstants.investorTokenKey);
    await _storage.delete(key: AppConstants.userDataKey);
    await _storage.delete(key: AppConstants.userRolesKey);
    await _storage.delete(key: AppConstants.activeRoleKey);
  }

  // Clear specific tokens
  static Future<void> clearRoleTokens() async {
    await _storage.delete(key: AppConstants.startupTokenKey);
    await _storage.delete(key: AppConstants.investorTokenKey);
  }
}
