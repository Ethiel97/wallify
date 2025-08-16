import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallinice/shared/theme/theme.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.accentColor,
        surfaceContainer: AppColors.whiteBackgroundColor,
        onSecondary: Colors.white,
        onSurface: AppColors.darkColor,
        error: AppColors.errorColor,
      ),
      textTheme: GoogleFonts.nunitoSansTextTheme().copyWith(
        displayLarge: GoogleFonts.nunitoSans(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.darkColor,
        ),
        displayMedium: GoogleFonts.nunitoSans(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.darkColor,
        ),
        displaySmall: GoogleFonts.nunitoSans(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.darkColor,
        ),
        headlineLarge: GoogleFonts.nunitoSans(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.darkColor,
        ),
        headlineMedium: GoogleFonts.nunitoSans(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.darkColor,
        ),
        titleLarge: GoogleFonts.nunitoSans(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.darkColor,
        ),
        titleMedium: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.darkColor,
        ),
        bodyLarge: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.darkColor,
        ),
        bodyMedium: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.darkColor,
        ),
        labelLarge: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.darkColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkColor),
        titleTextStyle: GoogleFonts.nunitoSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.accentColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.accentColor, width: 2),
        ),
        hintStyle: GoogleFonts.nunitoSans(
          fontSize: 14,
          color: AppColors.greyMedium,
        ),
        labelStyle: GoogleFonts.nunitoSans(
          fontSize: 14,
          color: AppColors.darkColor,
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryColor,
        secondary: AppColors.accentColor,
        surface: AppColors.surfaceColor,
        surfaceContainer: AppColors.cardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textColor,
        error: AppColors.errorColor,
      ),
      textTheme: GoogleFonts.nunitoSansTextTheme().copyWith(
        displayLarge: GoogleFonts.nunitoSans(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
        displayMedium: GoogleFonts.nunitoSans(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
        displaySmall: GoogleFonts.nunitoSans(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
        ),
        headlineLarge: GoogleFonts.nunitoSans(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
        ),
        headlineMedium: GoogleFonts.nunitoSans(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor,
        ),
        titleLarge: GoogleFonts.nunitoSans(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor,
        ),
        titleMedium: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor,
        ),
        bodyLarge: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textColor,
        ),
        bodyMedium: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textColor,
        ),
        labelLarge: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textColor,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        titleTextStyle: GoogleFonts.nunitoSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.accentColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.accentColor, width: 2),
        ),
        hintStyle: GoogleFonts.nunitoSans(
          fontSize: 14,
          color: AppColors.greyMedium,
        ),
        labelStyle: GoogleFonts.nunitoSans(
          fontSize: 14,
          color: AppColors.textColor,
        ),
      ),
      scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    );
  }
}
