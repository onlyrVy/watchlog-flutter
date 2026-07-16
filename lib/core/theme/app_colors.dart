import 'package:flutter/material.dart';

/// Central color palette for Movie Journal.
///
/// Keeping every color here (instead of scattering hex codes across
/// widgets) means the whole app's look can be re-tuned from one file,
/// and it gives us a single source of truth for contrast/accessibility
/// checks.
class AppColors {
  AppColors._();

  // Backgrounds — deep, near-black charcoal rather than pure black,
  // so elevated cards can still read as "lighter" via shadows/tint.
  static const Color background = Color(0xFF0E0F13);
  static const Color surface = Color(0xFF1A1C22);
  static const Color surfaceElevated = Color(0xFF23262E);

  // Brand accent — a warm amber, distinct from Letterboxd's green
  // and IMDb's yellow, used sparingly for CTAs and highlights.
  static const Color accent = Color(0xFFE8A93B);
  static const Color accentMuted = Color(0xFF9C7530);

  // Status colors for Watchlist / Watching / Watched
  static const Color watchlist = Color(0xFF5B8DEF);
  static const Color watching = Color(0xFFE8A93B);
  static const Color watched = Color(0xFF4CAF7D);

  // Text
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFFA0A3AD);
  static const Color textDisabled = Color(0xFF5C5F68);

  // Semantic
  static const Color error = Color(0xFFE5484D);
  static const Color success = Color(0xFF4CAF7D);
  static const Color warning = Color(0xFFE8A93B);

  // Ratings
  static const Color star = Color(0xFFE8A93B);

  // Borders / dividers
  static const Color divider = Color(0xFF2C2F38);
}
