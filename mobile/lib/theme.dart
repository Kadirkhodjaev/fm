import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Фирменный стиль как в новом дизайне fm: Inter, графитовые кнопки, серый фон,
/// красный только как акцент, статусы теми же цветами.
class C {
  static const bg = Color(0xFFF5F6F8);
  static const fg = Color(0xFF1F2430);
  static const muted = Color(0xFF6B7280);
  static const line = Color(0xFFE6E8EC);
  static const surface = Colors.white;
  static const red = Color(0xFFD7182E);
  static const redDark = Color(0xFFA50F22);
  static const redSoft = Color(0xFFFDECEE);
  static const graphite = Color(0xFF1F2430);
  static const blue = Color(0xFF2563EB);
  static const blueSoft = Color(0xFFE8EFFD);
  static const amber = Color(0xFFB45309);
  static const amberSoft = Color(0xFFFEF3E2);
  static const green = Color(0xFF15803D);
  static const greenSoft = Color(0xFFE8F7EE);
  static const graySoft = Color(0xFFF0F1F4);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: C.graphite, primary: C.graphite, surface: C.surface, error: C.red),
    scaffoldBackgroundColor: C.bg,
  );
  final text = GoogleFonts.interTextTheme(base.textTheme).apply(bodyColor: C.fg, displayColor: C.fg);
  return base.copyWith(
    textTheme: text,
    appBarTheme: const AppBarTheme(backgroundColor: C.surface, foregroundColor: C.fg, elevation: 0, scrolledUnderElevation: 0),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: C.graphite,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: C.fg,
        side: const BorderSide(color: C.line),
        backgroundColor: C.surface,
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: C.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.line)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.line)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: C.blue, width: 1.5)),
    ),
    snackBarTheme: const SnackBarThemeData(backgroundColor: C.graphite, behavior: SnackBarBehavior.floating),
    dividerColor: C.line,
  );
}
