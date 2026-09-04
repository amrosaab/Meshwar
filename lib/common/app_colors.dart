import 'package:flutter/material.dart';

/// Meshwar — "Night Drive" design system, v2: built on the real brand mark.
///
/// [meshwarRed] (#D40D42) is sampled directly from the logo — not a
/// placeholder. Backgrounds are a warm near-black (a hint of plum, not
/// navy) so they sit comfortably under the red rather than fighting it.
class AppColors {
  AppColors._();

  // ---- Core surfaces (warm near-black, not cool navy-black) ----
  static const Color bgVoid = Color(0xFF060309); // deepest background — crushed near-black
  static const Color bgAsphalt = Color(0xFF160D19); // panel background
  static const Color bgAsphaltLight = Color(0xFF201323); // elevated panel

  // ---- Signal / brand colors ----
  static const Color meshwarRed = Color(0xFFD40D42); // sampled from the logo
  static const Color signalRose = Color(0xFFFF2E63); // gradient partner
  static const Color emberGold = Color(0xFFFFB020); // sparing highlight only (ratings, promo)
  static const Color routeGreen = Color(0xFF0F7A52); // success / confirmed / pickup states

  // ---- Status colors (support ticket states, etc.) ----
  static const Color blue = Color(0xFF1F5FD1); // pending / info
  static const Color orange = Color(0xFFA85614); // acknowledged / in-progress

  // ---- Fields referenced across the app's existing widgets ----
  // (kept so every current call site — CustomButton, CustomAppBar,
  // AppThemes, CustomTextField, PickupIcon, etc. — keeps compiling)
  static const Color primary = meshwarRed;
  static const Color secondary = signalRose; // stays in the red family deliberately
  static const Color black = bgVoid;
  static const Color white = Color(0xFFF7F5F6);
  static const Color grey = Color(0x1FFFFFFF); // hairlines / unselected nav items
  static const Color darkGrey = Color(0xFF9A8C93);
  static const Color hintColor = Color(0xFF756878);
  static const Color hintColorGrey = Color(0xFF3D3540); // darker — for text on light/white surfaces
  static const Color greyHintColor = Color(0xFF756878);
  static const Color red = Color(0xFFFF4D6D);
  static const Color errorLight = Color(0xFFFF4D6D);
  static const Color green = routeGreen; // PickupIcon
  static const Color lightGreen = Color(0xFF6EE7A8); // brighter mint — route-start marker/glow
  static const Color secondaryDark = emberGold; // "upcoming"/rental badge — bright enough for dark text
  static const Color yellowColor = emberGold; // outstation round-trip/one-way badge
  static const Color goldenColor = emberGold; // rating stars

  // ---- Document review status (NeededDocumentsWidget) ----
  static const Color waitingForApprovel = orange; // pending review
  static const Color uploadedAndApproved = green; // approved
  static const Color uploadedAndDeclined = red; // declined

  /// emberGold reads fine against a dark card (contrast ~9.7:1) but fails
  /// badly against a light one (~1.8:1) — use this instead of raw
  /// [emberGold]/[yellowColor]/[goldenColor] anywhere it's used as *text or
  /// an icon* sitting directly on a card surface (not a solid opaque fill).
  static Color amberOnSurface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? emberGold
        : const Color(0xFFA6650A);
  }
  static const Color borderColor = Color(0x1FFFFFFF);
  static const Color borderColors = Color(0x1FFFFFFF);
  static const Color transparent = Colors.transparent;

  // ---- Bottom navigation bar (floating pill) ----
  static const Color bottomNavigationBarColor = lightSurface;
  static const Color bottomNavigationBarColorDark = bgAsphaltLight;
  static const Color bottomNavigationBarShadowColor = Color(0x1A000000); // soft neutral elevation
  static const Color bottomNavigationBarShadowColorDark = Color(0x2ED40D42); // meshwarRed under-glow
  // Light mode's selected state reuses AppColors.primary directly (5.34:1 on
  // white). Dark mode uses signalRose instead of meshwarRed — measured
  // 4.94:1 vs meshwarRed's 3.34:1 against the elevated dark pill, so it
  // isn't just a stylistic choice, it visibly pops more.
  static const Color bottomNavigationBarSelectedColorDark = signalRose;
  static const Color bottomNavigationBarUnSelectedColor = darkGrey;
  static const Color bottomNavigationBarUnSelectedColorDark = darkGrey;
  static const Color textSelectionColor = Color(0x40D40D42); // meshwarRed @ ~25%

  // CustomButton's default fill/text colors
  static const Color buttonColor = meshwarRed;
  static const Color buttonTextColor = Colors.white;

  // ---- Skeleton / shimmer colors ----
  static const Color greyHeader = Color(0xFFE8E2E4); // static fallback (light-leaning neutral)

  /// Shimmer base — the "resting" tone the moving highlight sweeps across.
  static Color shimmerBase(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1C1220)
        : greyHeader;
  }

  /// Shimmer highlight — the moving light band. A whisper warmer than pure
  /// grey in both modes so the loading state still feels like this app's,
  /// not a generic skeleton.
  static Color shimmerHighlight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF362430)
        : const Color(0xFFF8F1F3);
  }

  // ---- Light-mode surfaces (applicationDefaultTheme) ----
  static const Color lightBg = Color(0xFFFBF7F8); // warm off-white, not stark white
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFEFE3E6);

  // ---- Glass surface constants (dark mode only — see the surface()
  // helpers below for the brightness-aware version every widget should
  // actually use) ----
  static const Color glassFill = Color(0x0FFFFFFF);
  static const Color glassFillStrong = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x22FFFFFF);

  // ---- Brightness-aware surface helpers ----
  // Dark mode: translucent-white "glass" over the animated backdrop.
  // Light mode: a solid off-white card with a soft hairline — translucent
  // white would be almost invisible against the light backdrop, so this
  // is a real branch, not a cosmetic one.
  static Color surface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? glassFill : lightSurface;
  }

  static Color surfaceStrong(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? glassFillStrong : lightSurface;
  }

  static Color surfaceBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? glassBorder : lightBorder;
  }

  /// Card shadow: a red rim-glow in dark mode, an ordinary soft drop
  /// shadow in light mode (glow doesn't read as "elevation" on a light
  /// background the way a real shadow does).
  static List<BoxShadow> surfaceShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark ? meshwarRed.withOpacity(0.08) : Colors.black.withOpacity(0.06),
        offset: isDark ? const Offset(0, 8) : const Offset(0, 4),
        spreadRadius: isDark ? -6 : -2,
        blurRadius: isDark ? 24 : 14,
      ),
    ];
  }

  static const LinearGradient beaconGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [meshwarRed, signalRose],
  );

  static const LinearGradient backdropGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [bgVoid, bgAsphalt],
  );

  static const LinearGradient lightBackdropGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightBg, Color(0xFFEDF4F9)],
  );

  // ---- Liquid Glass accent (map/location UI overlays) ----
  // A consistent sky-blue used for every "frosted glass over the map"
  // panel — location pill, category selector, search bar, bottom sheet,
  // bottom nav. glassBlueStrong/glassBlue pair as a two-stop gradient
  // where a panel wants a light source (e.g. the location pill); panels
  // that just need a flat tint use glassBlue alone at a low opacity.
  // Deliberately NOT brightness-aware like surface()/surfaceBorder() —
  // these sit directly over the live map, not over the app's own
  // dark/light backdrop, so they don't flip with the app theme.
  static const Color glassBlueStrong = Color(0xFF5FA8E0);
  static const Color glassBlue = Color(0xFF8FC4EC);
  static const Color glassBlueShadow = Color(0xFF508CB4);
}