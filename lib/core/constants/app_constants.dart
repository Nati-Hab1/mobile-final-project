class AppConstants {
  // App info
  static const String appName = 'Menesha';
  static const String appVersion = '1.0.0';

  // Storage keys
  static const String mainTokenKey = 'main_token';
  static const String startupTokenKey = 'startup_token';
  static const String investorTokenKey = 'investor_token';
  static const String userDataKey = 'user_data';
  static const String userRolesKey = 'user_roles';
  static const String activeRoleKey = 'active_role';

  // Cache durations (in milliseconds)
  static const int cacheDurationStartups = 5 * 60 * 1000; // 5 minutes
  static const int cacheDurationProfile = 10 * 60 * 1000; // 10 minutes
  static const int cacheDurationInterests = 2 * 60 * 1000; // 2 minutes

  // Pagination
  static const int defaultPageSize = 20;

  // Timeouts
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;

  // Role strings
  static const String roleStartup = 'startup';
  static const String roleInvestor = 'investor';
}
