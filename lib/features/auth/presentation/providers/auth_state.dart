import '../../domain/entities/user.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final User? user;
  final List<String> roles;
  final bool isAuthenticated;
  
  AuthState({
    required this.isLoading,
    this.error,
    this.user,
    required this.roles,
    required this.isAuthenticated,
  });
  
  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      error: null,
      user: null,
      roles: [],
      isAuthenticated: false,
    );
  }
  
  AuthState copyWith({
    bool? isLoading,
    String? error,
    User? user,
    List<String>? roles,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      user: user ?? this.user,
      roles: roles ?? this.roles,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}