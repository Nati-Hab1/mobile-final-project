import '../entities/user.dart';

abstract class AuthRepository {
  // Register new user (no role yet)
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  });

  // Login user (no role required)
  Future<({User user, String token, List<String> roles})> login({
    required String email,
    required String password,
  });

  // Add role to existing user
  Future<void> addRole(String role);

  // Get role-specific token
  Future<String> getRoleToken(String role);

  // Get current user with roles
  Future<User> getCurrentUser();

  // Get user roles
  Future<List<String>> getUserRoles();

  // Logout
  Future<void> logout();
}
