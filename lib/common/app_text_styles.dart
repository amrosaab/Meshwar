import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Meshwar's real typography base is Noto Sans — it renders Latin and
/// Arabic cleanly, which matters since this app is bilingual/RTL-aware.
/// Every text role here stays on Noto Sans. The one exception is [mono],
/// reserved strictly for pure-digit readouts (OTP codes, dial codes,
/// timers) that never carry translated text — so a Latin-only mono face
/// is safe there and nowhere else.
class AppTextStyle {
  AppTextStyle._();

  /// Matches the existing call sites exactly:
  /// `AppTextStyle.normalStyle().copyWith(color: ..., fontSize: ..., fontWeight: ...)`
  static TextStyle normalStyle({
    double size = 14,
    FontWeight weight = FontWeight.normal,
    FontStyle style = FontStyle.normal,
  }) {
    return GoogleFonts.cairo(
      fontSize: size,
      fontWeight: weight,
      fontStyle: style,
    );
  }

  /// Matches the existing call sites exactly.
  static TextStyle boldStyle({
    double size = 14,
    FontWeight weight = FontWeight.bold,
    FontStyle style = FontStyle.normal,
  }) {
    return GoogleFonts.cairo(
      fontSize: size,
      fontWeight: weight,
      fontStyle: style,
    );
  }

  /// Body text role used by the redesigned auth screens — same face as
  /// [normalStyle], just with a color param since most call sites need one
  /// inline rather than via a follow-up .copyWith().
  static TextStyle body({
    double size = 14,
    FontWeight weight = FontWeight.w500,
    Color color = Colors.white,
  }) {
    return GoogleFonts.cairo(fontSize: size, fontWeight: weight, color: color);
  }

  /// Headline/display role — still Noto Sans (stays correct in Arabic),
  /// just heavier and slightly tracked out for more presence.
  static TextStyle display({
    double size = 24,
    FontWeight weight = FontWeight.w800,
    Color color = Colors.white,
    double? letterSpacing,
  }) {
    return GoogleFonts.cairo(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing ?? 0.2,
    );
  }

  /// Digits-only "system readout" role — OTP codes, dial codes, timers.
  /// Do not use this for any translated / user-authored string.
  static TextStyle mono({
    double size = 16,
    FontWeight weight = FontWeight.w600,
    Color color = Colors.white,
    double letterSpacing = 2,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}