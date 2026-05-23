import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../database/local_database.dart';
import 'package:sqflite/sqflite.dart';
import '../utils/secure_storage.dart';

// 1. Dio client provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

// 2. Database provider - Fixed: Return Database? instead of Database
final localDatabaseProvider = FutureProvider<Database?>((ref) async {
  final db = await LocalDatabase.instance;
  return db; // Can be null on web
});

// 3. Secure storage provider
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

// 4. Auth token provider
final authTokenProvider =
    StateNotifierProvider<AuthTokenNotifier, AsyncValue<String?>>((ref) {
  return AuthTokenNotifier();
});

class AuthTokenNotifier extends StateNotifier<AsyncValue<String?>> {
  AuthTokenNotifier() : super(const AsyncValue.loading()) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await SecureStorage.getMainToken();
    state = AsyncValue.data(token);
  }

  Future<void> setToken(String token) async {
    await SecureStorage.saveMainToken(token);
    state = AsyncValue.data(token);
  }

  Future<void> clearToken() async {
    await SecureStorage.clearAll();
    state = const AsyncValue.data(null);
  }
}

// 5. User roles provider
final userRolesProvider =
    StateNotifierProvider<UserRolesNotifier, AsyncValue<List<String>>>((ref) {
  return UserRolesNotifier();
});

class UserRolesNotifier extends StateNotifier<AsyncValue<List<String>>> {
  UserRolesNotifier() : super(const AsyncValue.loading()) {
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    final rolesString = await SecureStorage.getUserRoles();
    if (rolesString == null || rolesString.isEmpty) {
      state = const AsyncValue.data([]);
    } else {
      state = AsyncValue.data(rolesString.split(','));
    }
  }

  Future<void> setRoles(List<String> roles) async {
    final rolesString = roles.join(',');
    await SecureStorage.saveUserRoles(rolesString);
    state = AsyncValue.data(roles);
  }

  Future<void> addRole(String role) async {
    final currentState = state;
    if (currentState is AsyncData<List<String>>) {
      final currentRoles = currentState.value;
      if (!currentRoles.contains(role)) {
        await setRoles([...currentRoles, role]);
      }
    }
  }
}
