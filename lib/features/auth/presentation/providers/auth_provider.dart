import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../core/utils/secure_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/add_role_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/get_role_token_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_state.dart';

// Provider for AuthRemoteDatasource
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(DioClient());
});

// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.read(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(datasource);
});

// UseCases
final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.read(authRepositoryProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final addRoleUseCaseProvider = Provider<AddRoleUseCase>((ref) {
  return AddRoleUseCase(ref.read(authRepositoryProvider));
});

final getRoleTokenUseCaseProvider = Provider<GetRoleTokenUseCase>((ref) {
  return GetRoleTokenUseCase(ref.read(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.read(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.read(authRepositoryProvider));
});

// Auth StateNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final AddRoleUseCase _addRoleUseCase;
  final GetRoleTokenUseCase _getRoleTokenUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthNotifier({
    required RegisterUseCase registerUseCase,
    required LoginUseCase loginUseCase,
    required AddRoleUseCase addRoleUseCase,
    required GetRoleTokenUseCase getRoleTokenUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _registerUseCase = registerUseCase,
        _loginUseCase = loginUseCase,
        _addRoleUseCase = addRoleUseCase,
        _getRoleTokenUseCase = getRoleTokenUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _logoutUseCase = logoutUseCase,
        super(AuthState.initial());

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _registerUseCase.execute(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );

      // Registration successful but user has NO token and NO roles yet
      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: false, // Important: false because no token yet
        roles: [], // No roles assigned yet
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _loginUseCase.execute(
        email: email,
        password: password,
      );

      // FIX: Save the main token to SecureStorage so AuthInterceptor can find it.
      // Previously this was missing — the token only lived in Riverpod state,
      // so every subsequent protected request had no Authorization header → 401.
      await SecureStorage.saveMainToken(result.token);

      // FIX: Persist user data so loadCurrentUser() can restore it on app restart.
      await SecureStorage.saveUserData(jsonEncode(result.user.toJson()));

      // FIX: Persist roles as a comma-separated string (matches how loadCurrentUser reads them).
      if (result.roles.isNotEmpty) {
        await SecureStorage.saveUserRoles(result.roles.join(','));
      }

      state = state.copyWith(
        isLoading: false,
        user: result.user,
        roles: result.roles,
        isAuthenticated: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
    }
  }

  Future<void> addRole(String role) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _addRoleUseCase.execute(role);

      final updatedRoles = [...state.roles, role];

      // Keep SecureStorage in sync when roles change
      await SecureStorage.saveUserRoles(updatedRoles.join(','));

      state = state.copyWith(
        isLoading: false,
        roles: updatedRoles,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<String> getRoleToken(String role) async {
    try {
      final token = await _getRoleTokenUseCase.execute(role);

      // FIX: Save the role-specific token so AuthInterceptor can attach it
      // to startup/investor requests automatically.
      if (role == 'startup') {
        await SecureStorage.saveStartupToken(token);
      } else if (role == 'investor') {
        await SecureStorage.saveInvestorToken(token);
      }

      await SecureStorage.saveActiveRole(role);

      return token;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> loadCurrentUser() async {
    state = state.copyWith(isLoading: true);

    try {
      final user = await _getCurrentUserUseCase.execute();

      final rolesStr = await SecureStorage.getUserRoles();
      final List<String> roles = rolesStr?.split(',') ?? <String>[];

      state = state.copyWith(
        isLoading: false,
        user: user,
        roles: roles,
        isAuthenticated: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _logoutUseCase.execute();

      // FIX: Clear all persisted tokens and user data on logout.
      // Previously this was missing — old tokens stayed in SecureStorage
      // after logout, causing stale auth state on next app launch.
      await SecureStorage.clearAll();

      state = AuthState.initial();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    registerUseCase: ref.read(registerUseCaseProvider),
    loginUseCase: ref.read(loginUseCaseProvider),
    addRoleUseCase: ref.read(addRoleUseCaseProvider),
    getRoleTokenUseCase: ref.read(getRoleTokenUseCaseProvider),
    getCurrentUserUseCase: ref.read(getCurrentUserUseCaseProvider),
    logoutUseCase: ref.read(logoutUseCaseProvider),
  );
});

// Provider for checking if user has specific role
final hasRoleProvider = Provider.family<bool, String>((ref, role) {
  final authState = ref.watch(authProvider);
  return authState.roles.contains(role);
});

// Provider for getting user's roles
final userRolesProvider = Provider<List<String>>((ref) {
  return ref.watch(authProvider).roles;
});

// Provider for checking if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});