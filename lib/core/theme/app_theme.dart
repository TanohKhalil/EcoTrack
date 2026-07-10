import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color bg = Color(0xFF0E1912);
  static const Color deep = Color(0xFF0A140E);
  static const Color surface = Color(0xFF152318);
  static const Color card = Color(0xFF1B2B1F);
  static const Color text = Color(0xFFEAF3EC);
  static const Color accent = Color(0xFF34D399);
  static const Color accentInk = Color(0xFF052017);
  static const Color soft = Color(0xFF7FDDB4);
  static const Color organic = Color(0xFFD98A4A);
  static const Color plastic = Color(0xFF3FB6E8);
  static const Color danger = Color(0xFFF26B5E);
  static const Color gold = Color(0xFFF6C453);
  static const Color blue = Color(0xFF5B8CFF);
  static const Color phA = Color(0xFF1B3A2F);
  static const Color phB = Color(0xFF2F6E4E);

  static const Color bgLight = Color(0xFFF4F9F0);
  static const Color deepLight = Color(0xFFE8F2E2);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textLight = Color(0xFF153523);
  static const Color accentLight = Color(0xFF40D089);
  static const Color accentInkLight = Color(0xFFFFFFFF);
  static const Color softLight = Color(0xFF0F6B45);
  static const Color organicLight = Color(0xFFB2691F);
  static const Color plasticLight = Color(0xFF1B7FAE);
  static const Color dangerLight = Color(0xFFD14538);
  static const Color goldLight = Color(0xFF9D660A);
  static const Color blueLight = Color(0xFF3559C9);
  static const Color phALight = Color(0xFFE6F4E9);
  static const Color phBLight = Color(0xFFD6EEDB);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    colorScheme: const ColorScheme.dark(
      primary: accent,
      secondary: soft,
      surface: surface,
      error: danger,
      onPrimary: accentInk,
      onSurface: text,
    ),
    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: accent.withValues(alpha: 0.14)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: accentInk,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(vertical: 17),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: soft,
        side: const BorderSide(color: accent, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: bgLight,
    colorScheme: const ColorScheme.light(
      primary: accentLight,
      secondary: softLight,
      surface: surfaceLight,
      error: dangerLight,
      onPrimary: accentInkLight,
      onSurface: textLight,
    ),
    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: bgLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: accentLight.withValues(alpha: 0.14)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentLight,
        foregroundColor: accentInkLight,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(vertical: 17),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: softLight,
        side: BorderSide(color: accentLight.withValues(alpha: 0.4), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
  );
}

// Extension utilitaire pour ajuster rapidement l'alpha (et/ou RGB)
// sur des instances `Color`. Le projet utilise `withValues(alpha: x)`
// à plusieurs endroits — cette extension réimplémente ce comportement
// de façon minimale et compatible avec `withOpacity`.
extension ColorWithValues on Color {
  Color withValues({double? alpha, int? red, int? green, int? blue}) {
    final double opacityValue = alpha ?? (a.toDouble() / 255.0);
    final int redValue = red ?? r.toInt();
    final int greenValue = green ?? g.toInt();
    final int blueValue = blue ?? b.toInt();
    return Color.fromARGB(
      (opacityValue.clamp(0.0, 1.0) * 255).round().clamp(0, 255),
      redValue,
      greenValue,
      blueValue,
    );
  }
}
