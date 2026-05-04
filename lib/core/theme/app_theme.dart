import 'package:flutter/material.dart';

class AppColors {
  // Primary palette — deep navy/indigo matching Figma
  static const Color backgroundDark = Color(
    0xFF2E3A6E,
  );
  static const Color backgroundMid = Color(
    0xFF3D4F8A,
  );
  static const Color backgroundLight = Color(
    0xFF4A5FA8,
  );

  // Accent
  static const Color accentBlue = Color(
    0xFF1A3CC8,
  );
  static const Color accentBlueBright = Color(
    0xFF2952FF,
  );

  // Text
  static const Color textPrimary = Color(
    0xFFFFFFFF,
  );
  static const Color textSecondary = Color(
    0xFFCDD5F3,
  );
  static const Color textMuted = Color(
    0xFF8B9BC8,
  );

  // Input fields
  static const Color inputBackground = Color(
    0xFFDDE3F5,
  );
  static const Color inputBorder = Color(
    0xFFB8C3E8,
  );

  // Cards
  static const Color cardBackground = Color(
    0xFFFFFFFF,
  );
  static const Color cardShadow = Color(
    0x1A000000,
  );

  // Success / Status
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accentBlue,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      fontFamily: 'Roboto',
    );
  }
}
