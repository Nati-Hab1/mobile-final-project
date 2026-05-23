class DbConstants {
  // Database name and version
  static const String databaseName = 'menesha.db';
  static const int databaseVersion = 1;

  // Table names
  static const String tableStartups = 'startups';
  static const String tableInterests = 'interests';
  static const String tableBookmarks = 'bookmarks';
  static const String tableIntros = 'intros';
  static const String tableUser = 'user';

  // Common columns
  static const String columnId = 'id';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  // Startup table columns
  static const String startupOwnerId = 'owner_id';
  static const String startupTitle = 'title';
  static const String startupBlurb = 'blurb';
  static const String startupPitchLink = 'pitch_link';

  // Interest table columns
  static const String interestStartupId = 'startup_id';
  static const String interestInvestorId = 'investor_id';
  static const String interestMessage = 'message';
  static const String interestStatus = 'status';

  // Bookmark table columns
  static const String bookmarkInvestorId = 'investor_id';
  static const String bookmarkStartupId = 'startup_id';
  static const String bookmarkNote = 'note';

  // Intro table columns
  static const String introStartupId = 'startup_id';
  static const String introInvestorId = 'investor_id';
  static const String introText = 'intro_text';

  // Create table queries
  static const String createStartupsTable = '''
    CREATE TABLE IF NOT EXISTS $tableStartups (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $startupOwnerId INTEGER NOT NULL,
      $startupTitle TEXT NOT NULL,
      $startupBlurb TEXT NOT NULL,
      $startupPitchLink TEXT,
      $columnCreatedAt TEXT NOT NULL,
      $columnUpdatedAt TEXT NOT NULL
    )
  ''';

  static const String createInterestsTable = '''
    CREATE TABLE IF NOT EXISTS $tableInterests (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $interestStartupId INTEGER NOT NULL,
      $interestInvestorId INTEGER NOT NULL,
      $interestMessage TEXT,
      $interestStatus TEXT NOT NULL,
      $columnCreatedAt TEXT NOT NULL,
      $columnUpdatedAt TEXT NOT NULL
    )
  ''';

  static const String createBookmarksTable = '''
    CREATE TABLE IF NOT EXISTS $tableBookmarks (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $bookmarkInvestorId INTEGER NOT NULL,
      $bookmarkStartupId INTEGER NOT NULL,
      $bookmarkNote TEXT,
      $columnCreatedAt TEXT NOT NULL
    )
  ''';

  static const String createIntrosTable = '''
    CREATE TABLE IF NOT EXISTS $tableIntros (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $introStartupId INTEGER NOT NULL,
      $introInvestorId INTEGER NOT NULL,
      $introText TEXT NOT NULL,
      $columnCreatedAt TEXT NOT NULL
    )
  ''';
}
