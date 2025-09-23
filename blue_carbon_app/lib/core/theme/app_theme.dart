import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      onPrimary: AppColors.pearlWhite,
      secondary: AppColors.coastalTeal,
      onSecondary: AppColors.pearlWhite,
      tertiary: AppColors.seagrassGreen,
      onTertiary: AppColors.pearlWhite,
      error: AppColors.coralPink,
      onError: AppColors.pearlWhite,
      surface: AppColors.pearlWhite,
      onSurface: AppColors.charcoal,
      surfaceVariant: AppColors.lightGray,
      onSurfaceVariant: AppColors.slateGray,
    ),
    scaffoldBackgroundColor: AppColors.seaFoam,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.deepOceanBlue,
      foregroundColor: AppColors.pearlWhite,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.pearlWhite,
      ),
      iconTheme: const IconThemeData(color: AppColors.pearlWhite),
      actionsIconTheme: const IconThemeData(color: AppColors.pearlWhite),
    ),
    cardTheme: CardThemeData(
      color: AppColors.pearlWhite,
      elevation: 4,
      shadowColor: AppColors.deepOceanBlue.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.pearlWhite,
        backgroundColor: AppColors.coastalTeal,
        elevation: 2,
        shadowColor: AppColors.coastalTeal.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.coastalTeal,
        side: const BorderSide(color: AppColors.coastalTeal, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.coastalTeal,
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.pearlWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.slateGray.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.slateGray.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.coastalTeal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.coralPink, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.coralPink, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      hintStyle: TextStyle(
        color: AppColors.slateGray.withOpacity(0.6),
        fontSize: 16,
      ),
      labelStyle: const TextStyle(
        color: AppColors.charcoal,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w700),
        displayMedium: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w700),
        displaySmall: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w600),
        headlineLarge: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(color: AppColors.slateGray, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: AppColors.charcoal, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: AppColors.slateGray, fontWeight: FontWeight.w500),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.pearlWhite,
      selectedItemColor: AppColors.coastalTeal,
      unselectedItemColor: AppColors.slateGray,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.seaFoam,
      labelStyle: const TextStyle(
        color: AppColors.charcoal,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.slateGray.withOpacity(0.2),
      thickness: 1,
      space: 1,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.coastalTeal,
      foregroundColor: AppColors.pearlWhite,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.aquaMarine,
      onPrimary: AppColors.pearlWhite,
      secondary: AppColors.seagrassGreen,
      onSecondary: AppColors.pearlWhite,
      tertiary: AppColors.kelp,
      onTertiary: AppColors.pearlWhite,
      error: AppColors.coralPink,
      onError: AppColors.pearlWhite,
      surface: AppColors.abyssalBlue,
      onSurface: AppColors.pearlWhite,
      surfaceVariant: AppColors.deepOceanBlue,
      onSurfaceVariant: AppColors.lightGray,
    ),
    scaffoldBackgroundColor: AppColors.deepOceanBlue,
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
        borderSide: const BorderSide(color: AppColors.coralPink, width: 1),
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
