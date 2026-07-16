import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Named text styles for the app. Pages should reference these rather
/// than constructing TextStyle() inline, so typography stays consistent
/// and can be adjusted globally.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _base => GoogleFonts.inter(color: AppColors.textPrimary);

  static TextStyle get displayLarge => _base.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineMedium => _base.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      );

  static TextStyle get titleLarge => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get titleMedium => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyLarge => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodyMedium => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get label => _base.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static TextStyle get button => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );
}
