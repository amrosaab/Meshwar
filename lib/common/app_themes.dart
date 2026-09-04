// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppThemes {
  // Light Theme
  static ThemeData applicationDefaultTheme(BuildContext context) {
    ThemeData originalTheme = ThemeData.light();
    const String fontFamily = 'NotoSans';
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.secondary,
      primaryColorDark: AppColors.black,
      scaffoldBackgroundColor: AppColors.lightBg,
      disabledColor: AppColors.greyHintColor,
      fontFamily: GoogleFonts.cairo().fontFamily,
      shadowColor: AppColors.meshwarRed.withAlpha((0.12 * 255).toInt()),
      hintColor: AppColors.darkGrey,
      dividerColor: AppColors.lightBorder,
      splashColor: AppColors.meshwarRed.withAlpha((0.08 * 255).toInt()),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColors.textSelectionColor,
        selectionHandleColor: AppColors.meshwarRed,
      ),
      unselectedWidgetColor: Theme.of(context).primaryColorDark,
      appBarTheme: const AppBarTheme(
        color: AppColors.lightSurface,
        surfaceTintColor: AppColors.secondary,
        titleTextStyle: TextStyle(
          color: AppColors.black,
          fontSize: 24,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500,
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.lightSurface,
      ),
      buttonTheme: originalTheme.buttonTheme.copyWith(
        buttonColor: AppColors.primary,
        textTheme: ButtonTextTheme.accent,
        minWidth: 30,
        splashColor: AppColors.primary,
      ),
      snackBarTheme: const SnackBarThemeData(
        actionTextColor: AppColors.white,
      ),
      textTheme: GoogleFonts.cairoTextTheme(originalTheme.textTheme.copyWith(
        titleLarge: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          fontFamily: fontFamily,
          color: AppColors.black,
        ),
        titleMedium: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          fontFamily: fontFamily,
          color: AppColors.black,
        ),
        titleSmall: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          fontFamily: fontFamily,
          color: AppColors.black,
        ),
        bodyLarge: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontFamily: fontFamily,
          color: AppColors.black,
        ),
        bodyMedium: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            fontFamily: fontFamily,
            color: AppColors.black),
        bodySmall: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          fontFamily: fontFamily,
          color: AppColors.black,
        ),
        displayLarge: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          fontFamily: fontFamily,
          color: AppColors.black,
        ),
        displayMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily,
          color: AppColors.black,
        ),
        displaySmall: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily,
          color: AppColors.black,
        ),
        headlineLarge: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          fontFamily: fontFamily,
          color: AppColors.black,
        ),
        headlineMedium: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          fontFamily: fontFamily,
          color: AppColors.black,
        ),
        headlineSmall: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 26,
          fontFamily: '$fontFamily-Bold',
          color: AppColors.black,
        ),
        labelLarge: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          fontFamily: fontFamily,
          color: AppColors.black,
        ),
        labelMedium: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          fontFamily: fontFamily,
          color: AppColors.black,
        ),
        labelSmall: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 10,
          fontFamily: fontFamily,
          color: AppColors.black,
        ),
      )),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.meshwarRed, width: 1.4),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedItemColor: AppColors.meshwarRed,
        elevation: 0,
        type: BottomNavigationBarType.shifting,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          fontFamily: fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        unselectedItemColor: AppColors.darkGrey,
        showUnselectedLabels: true,
      ),
    );
  }

  // DARK THEME — the "Night Drive" HUD look: warm plum-black surfaces,
  // meshwarRed as the signal color throughout.
  static ThemeData darkTheme(BuildContext context) {
    ThemeData originalTheme = ThemeData.dark();
    const String fontFamily = 'NotoSans';
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.secondary,
      primaryColorDark: AppColors.white,
      scaffoldBackgroundColor: AppColors.bgVoid,
      disabledColor: AppColors.darkGrey,
      fontFamily: GoogleFonts.cairo().fontFamily,
      shadowColor: AppColors.meshwarRed.withAlpha((0.3 * 255).toInt()),
      hintColor: AppColors.darkGrey,
      dividerColor: AppColors.glassBorder,
      splashColor: AppColors.meshwarRed.withAlpha((0.1 * 255).toInt()),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColors.textSelectionColor,
        selectionHandleColor: AppColors.meshwarRed,
      ),
      unselectedWidgetColor: Theme.of(context).primaryColorDark,
      appBarTheme: const AppBarTheme(
        color: AppColors.bgAsphalt,
        surfaceTintColor: AppColors.secondary,
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 24,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500,
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.bgAsphaltLight,
      ),
      buttonTheme: originalTheme.buttonTheme.copyWith(
        buttonColor: AppColors.primary,
        textTheme: ButtonTextTheme.accent,
        minWidth: 30,
        splashColor: AppColors.primary,
      ),
      snackBarTheme: const SnackBarThemeData(
        actionTextColor: AppColors.white,
      ),
      textTheme: GoogleFonts.cairoTextTheme(originalTheme.textTheme.copyWith(
        titleLarge: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          fontFamily: fontFamily,
          color: AppColors.white,
        ),
        titleMedium: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          fontFamily: fontFamily,
          color: AppColors.white,
        ),
        titleSmall: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          fontFamily: fontFamily,
          color: AppColors.white,
        ),
        bodyLarge: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontFamily: fontFamily,
          color: AppColors.white,
        ),
        bodyMedium: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          fontFamily: fontFamily,
          color: AppColors.white,
        ),
        bodySmall: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          fontFamily: fontFamily,
          color: AppColors.white,
        ),
        displayLarge: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          fontFamily: fontFamily,
          color: AppColors.white,
        ),
        displayMedium: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily,
          color: AppColors.white,
        ),
        displaySmall: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily,
          color: AppColors.white,
        ),
        headlineLarge: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          fontFamily: fontFamily,
          color: AppColors.white,
        ),
        headlineMedium: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          fontFamily: fontFamily,
          color: AppColors.white,
        ),
        headlineSmall: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 26,
          fontFamily: '$fontFamily-Bold',
          color: AppColors.white,
        ),
        labelLarge: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          fontFamily: fontFamily,
          color: AppColors.white,
        ),
        labelMedium: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          fontFamily: fontFamily,
          color: AppColors.white,
        ),
        labelSmall: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 10,
          fontFamily: fontFamily,
          color: AppColors.white,
        ),
      )),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.glassFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.meshwarRed, width: 1.4),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bgAsphalt,
        selectedItemColor: AppColors.white,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          fontFamily: fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        unselectedItemColor: AppColors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}