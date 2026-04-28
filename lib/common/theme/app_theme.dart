import 'package:flutter/material.dart';

class AppColors {
  // Primary palette – warm milk tea tones
  static const Color cream = Color(0xFFF5ECD7);
  static const Color milkTea = Color(0xFFD4A96A);
  static const Color darkBrown = Color(0xFF2C1A0E);
  static const Color mediumBrown = Color(0xFF6B3F1E);
  static const Color lightBrown = Color(0xFFB07D45);
  static const Color tapioca = Color(0xFFE8D5B0);

  // Accents
  static const Color rose = Color(0xFFE8A598);
  static const Color matcha = Color(0xFF8BA888);
  static const Color taro = Color(0xFFB8A0C8);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFAF6F0);
  static const Color grey = Color(0xFF9E8E80);
  static const Color darkGrey = Color(0xFF4A3728);
}

class AppTextStyles {
  static const String displayFont = 'Playfair Display';
  static const String bodyFont = 'DM Sans';

  static const TextStyle display = TextStyle(
    fontFamily: displayFont,
    fontSize: 42,
    fontWeight: FontWeight.w700,
    color: AppColors.darkBrown,
    height: 1.15,
    letterSpacing: -0.5,
  );

  static const TextStyle heading1 = TextStyle(
    fontFamily: displayFont,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.darkBrown,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: displayFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.darkBrown,
  );

  static const TextStyle body = TextStyle(
    fontFamily: bodyFont,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.darkGrey,
    height: 1.6,
  );

  static const TextStyle label = TextStyle(
    fontFamily: bodyFont,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
    letterSpacing: 1.2,
  );

  static const TextStyle button = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.5,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.light(
        primary: AppColors.milkTea,
        secondary: AppColors.mediumBrown,
        surface: AppColors.cream,
      ),
      fontFamily: AppTextStyles.bodyFont,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.tapioca, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.tapioca, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.milkTea, width: 2),
        ),
        labelStyle: TextStyle(color: AppColors.grey, fontFamily: AppTextStyles.bodyFont),
        hintStyle: TextStyle(color: AppColors.grey.withOpacity(0.7), fontFamily: AppTextStyles.bodyFont),
      ),
    );
  }
}
