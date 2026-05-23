class ApiConstants {
  static const String baseUrl = 'http://localhost:5000/api';

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String getMe = '/auth/me';
  static const String myRoles = '/auth/my-roles';
  static const String logout = '/auth/logout';

  // Role endpoints
  static const String addRole = '/roles/add-role';
  static const String roleToken = '/roles/role-token';
  static const String acceptedInvestors = '/startups/accepted-investors';

  // Startup endpoints
  static const String startups = '/startups';
  static const String myStartups = '/startups/my-startups';
  static const String startupDashboardStats =
      '/startups/dashboard-stats'; // ← ADDED
  static String startupById(int id) => '/startups/$id';
  static String startupInterests(int id) => '/startups/$id/interests';

  // Investor endpoints
  static const String investorInterests = '/investor/interests';
  static const String investorBookmarks = '/investor/bookmarks';
  static String bookmarkById(int id) => '/investor/bookmarks/$id';

  // Intro endpoints
  static const String intros = '/intros';
  static String startupIntros(int startupId) => '/intros/startup/$startupId';
  static const String myIntros = '/intros/my-intros';

  // Profile endpoints
  static const String profile = '/profile';
  static const String profileStats = '/profile/stats';
  static const String updatePassword = '/profile/password';

  // Headers
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
}
