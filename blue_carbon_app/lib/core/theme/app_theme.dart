import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blue_carbon_app/core/theme/app_colors.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.deepOceanBlue,
      onPrimary: Colors.white,
      secondary: AppColors.coastalTeal,
      onSecondary: Colors.white,
      tertiary: AppColors.seagrassGreen,
      onTertiary: Colors.white,
      error: AppColors.coralAccent,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: AppColors.charcoal,
      // background, onBackground, and surfaceVariant are deprecated in ColorScheme as of Flutter 3.18.0-0.1.pre
      // Use surface and onSurface instead.
    ),
    scaffoldBackgroundColor: AppColors.oceanFoam,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.deepOceanBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.coastalTeal,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.deepOceanBlue,
        side: const BorderSide(color: AppColors.deepOceanBlue),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppColors.coastalTeal)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.deepOceanBlue.withAlpha((0.2 * 255).round())),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.deepOceanBlue.withAlpha((0.2 * 255).round())),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.coastalTeal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.coralAccent, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(color: Colors.black87),
        displayMedium: TextStyle(color: Colors.black87),
        displaySmall: TextStyle(color: Colors.black87),
        headlineLarge: TextStyle(color: Colors.black87),
        headlineMedium: TextStyle(color: Colors.black87),
        headlineSmall: TextStyle(color: Colors.black87),
        titleLarge: TextStyle(color: Colors.black87),
        titleMedium: TextStyle(color: Colors.black87),
        titleSmall: TextStyle(color: Colors.black87),
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
        bodySmall: TextStyle(color: Colors.black54),
        labelLarge: TextStyle(color: Colors.black87),
        labelMedium: TextStyle(color: Colors.black87),
        labelSmall: TextStyle(color: Colors.black87),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.coastalTeal,
      unselectedItemColor: AppColors.charcoal.withAlpha((0.5 * 255).round()),
      type: BottomNavigationBarType.fixed,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: AppColors.sandyBeige,
      labelStyle: TextStyle(color: AppColors.charcoal),
      side: BorderSide.none,
    ),
    dividerTheme: DividerThemeData(color: AppColors.charcoal.withAlpha((0.1 * 255).round()), thickness: 1),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.coastalTeal,
      onPrimary: Colors.white,
      secondary: AppColors.seagrassGreen,
      onSecondary: Colors.white,
      tertiary: AppColors.deepOceanBlue,
      onTertiary: Colors.white,
      error: AppColors.coralAccent,
      onError: Colors.white,
      // background: AppColors.charcoal,
      // onBackground: Colors.white,
      surface: Color(0xFF1E1E1E),
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.charcoal,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF2C2C2C),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.coastalTeal,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.coastalTeal,
        side: const BorderSide(color: AppColors.coastalTeal),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppColors.coastalTeal)),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withAlpha(20)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withAlpha((0.2 * 255).round())),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.coastalTeal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.coralAccent, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white70),
        labelLarge: TextStyle(color: Colors.white),
        labelMedium: TextStyle(color: Colors.white),
        labelSmall: TextStyle(color: Colors.white),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedItemColor: AppColors.coastalTeal,
      unselectedItemColor: Colors.white.withAlpha((0.5 * 255).round()),
      type: BottomNavigationBarType.fixed,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: Color(0xFF2C2C2C),
      labelStyle: TextStyle(color: Colors.white),
      side: BorderSide.none,
    ),
    dividerTheme: DividerThemeData(color: Colors.white.withAlpha((0.1 * 255).round()), thickness: 1),
  );
}
