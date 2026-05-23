import '../../../../../core/utils/secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  
  AuthRepositoryImpl(this._remoteDatasource);
  
  @override
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    // Register returns only user, no token
    final user = await _remoteDatasource.register(
      fullName: fullName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
    
    // Don't save any token here - user has no role yet
    return user;
  }
  
  @override
  Future<({User user, String token, List<String> roles})> login({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDatasource.login(
      email: email,
      password: password,
    );
    
    // Save main token and roles
    await SecureStorage.saveMainToken(response.token!);
    if (response.roles.isNotEmpty) {
      await SecureStorage.saveUserRoles(response.roles.join(','));
    }
    
    return (
      user: response.user,
      token: response.token!,
      roles: response.roles,
    );
  }
  
  @override
  Future<void> addRole(String role) async {
    await _remoteDatasource.addRole(role);
    
    // Update roles in secure storage
    final currentRoles = await getUserRoles();
    if (!currentRoles.contains(role)) {
      final updatedRoles = [...currentRoles, role];
      await SecureStorage.saveUserRoles(updatedRoles.join(','));
    }
  }
  
  @override
  Future<String> getRoleToken(String role) async {
    final response = await _remoteDatasource.getRoleToken(role);
    
    // Save role-specific token
    if (role == 'startup') {
      await SecureStorage.saveStartupToken(response.token);
    } else if (role == 'investor') {
      await SecureStorage.saveInvestorToken(response.token);
    }
    
    return response.token;
  }
  
  @override
  Future<User> getCurrentUser() async {
    return await _remoteDatasource.getCurrentUser();
  }
  
  @override
  Future<List<String>> getUserRoles() async {
    // Try cache first
    final cachedRoles = await SecureStorage.getUserRoles();
    if (cachedRoles != null && cachedRoles.isNotEmpty) {
      return cachedRoles.split(',');
    }
    
    // Fetch from API
    final roles = await _remoteDatasource.getMyRoles();
    if (roles.isNotEmpty) {
      await SecureStorage.saveUserRoles(roles.join(','));
    }
    return roles;
  }
  
  @override
  Future<void> logout() async {
    try {
      await _remoteDatasource.logout();
    } catch (e) {
      // Ignore errors on logout
    }
    await SecureStorage.clearAll();
  }
}