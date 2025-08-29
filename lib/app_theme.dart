import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF613BE7);
  static const bg = Color(0xFFDFE4F1);
  static const card = Colors.white;
  static const gradientEnd = Color(0xFFDFE4F1);
  static const text = Color(0xFF1C2330);
  static const textMuted = Color(0xFF7D89A5);
  static const success = Color(0xFF009F76);
  static const error = Color(0xFFFF494C);
  static const chipBg = Color(0xFFF0F2F8);
  static const gray = Color(0xFF93989D);
}

ThemeData appTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    useMaterial3: true,
  );
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
      titleLarge: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.text),
      titleMedium: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.text),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textMuted, height: 1.5),
      labelLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
    ),
  );
}
