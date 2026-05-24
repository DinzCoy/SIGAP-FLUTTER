import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Semua TextStyle terpusat di sini — sinkron dengan DESIGN.md token.
///
/// PRINSIP UTAMA (dari DESIGN.md):
/// • Display tiers WAJIB fontWeight w300 — thin weight IS the brand.
/// • Negative letter-spacing pada display: -1.4px (56px) → -0.2px (20px).
/// • [bodyTabular] + `fontFeatures: [FontFeature.tabularFigures()]` pada angka.
/// • Font: Inter (open-source substitute untuk Sohne proprietary).
class AppTextStyles {
  AppTextStyles._();

  // ── Display Tier — weight 300, negative tracking ─────────────────────
  // {typography.display-xxl}: 56px, w300, -1.4px, lh 1.03
  static TextStyle get displayXxl => GoogleFonts.inter(
    fontSize: 56,
    fontWeight: FontWeight.w300,
    color: AppColors.ink,
    letterSpacing: -1.4,
    height: 1.03,
  );

  // {typography.display-xl}: 48px, w300, -0.96px, lh 1.15
  static TextStyle get displayXl => GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w300,
    color: AppColors.ink,
    letterSpacing: -0.96,
    height: 1.15,
  );

  // {typography.display-lg}: 32px, w300, -0.64px, lh 1.1
  static TextStyle get displayLarge => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w300,
    color: AppColors.ink,
    letterSpacing: -0.64,
    height: 1.1,
  );

  // {typography.display-md}: 26px, w300, -0.26px, lh 1.12
  static TextStyle get displayMedium => GoogleFonts.inter(
    fontSize: 26,
    fontWeight: FontWeight.w300,
    color: AppColors.ink,
    letterSpacing: -0.26,
    height: 1.12,
  );

  // ── Heading Tier — weight 300 ──────────────────────────────────────────
  // {typography.heading-lg}: 22px, w300, -0.22px, lh 1.1
  static TextStyle get headlineLarge => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w300,
    color: AppColors.ink,
    letterSpacing: -0.22,
    height: 1.1,
  );

  // {typography.heading-md}: 20px, w300, -0.2px, lh 1.4
  static TextStyle get headlineMedium => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w300,
    color: AppColors.ink,
    letterSpacing: -0.2,
    height: 1.4,
  );

  // {typography.heading-sm}: 18px, w300, 0, lh 1.4
  static TextStyle get headlineSmall => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: AppColors.ink,
    letterSpacing: 0,
    height: 1.4,
  );

  // ── Body Tier ───────────────────────────────────────────────────────────
  // {typography.body-lg}: 16px, w300, 0, lh 1.4
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: AppColors.ink,
    letterSpacing: 0,
    height: 1.4,
  );

  // {typography.body-md}: 15px, w300, 0, lh 1.4 — DEFAULT UI body
  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w300,
    color: AppColors.ink,
    letterSpacing: 0,
    height: 1.4,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w300,
    color: AppColors.inkMute,
    letterSpacing: 0,
    height: 1.4,
  );

  // {typography.body-tabular}: 14px, w300, -0.42px, tnum — ANGKA & UANG
  static TextStyle get bodyTabular => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.ink,
    letterSpacing: -0.42,
    height: 1.4,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  // ── Button Tier — weight 400 (satu-satunya tier yang tidak w300) ───────
  // {typography.button-md}: 16px, w400, 0, lh 1.0
  static TextStyle get buttonMd => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    letterSpacing: 0,
    height: 1.0,
  );

  // {typography.button-sm}: 14px, w400, 0, lh 1.0
  static TextStyle get buttonSm => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    letterSpacing: 0,
    height: 1.0,
  );

  // ── Caption / Label ─────────────────────────────────────────────────────
  // {typography.caption}: 13px, w400, -0.39px, tnum
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMute,
    letterSpacing: -0.39,
    height: 1.4,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  // {typography.micro}: 11px, w300, 0, lh 1.4
  static TextStyle get micro => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w300,
    color: AppColors.inkMute,
    letterSpacing: 0,
    height: 1.4,
  );

  // {typography.micro-cap}: 10px, w400, +0.1px, lh 1.15 — ALL-CAPS eyebrow
  static TextStyle get microCap => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMute,
    letterSpacing: 0.1,
    height: 1.15,
  );

  // ── Stat Number — tabular, dipakai di StatPanel ─────────────────────────
  /// Angka statistik besar — selalu tabular figures
  static TextStyle get statNumber => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w300,
    color: AppColors.ink,
    letterSpacing: -0.64,
    height: 1.0,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  // ── Label Tiers (untuk UI elements, nav, tags) ─────────────────────────
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    letterSpacing: 0,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMute,
    letterSpacing: 0,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMute,
    letterSpacing: 0,
  );

  // ── Title Tiers ─────────────────────────────────────────────────────────
  static TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
    letterSpacing: -0.2,
  );

  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
  );

  static TextStyle get titleSmall => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
  );

  // ── Khusus / Contextual ─────────────────────────────────────────────────
  /// Link — primary color, bukan di body size
  static TextStyle get link => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    letterSpacing: 0,
  );

  /// On Primary — teks di atas surface indigo/navy
  static TextStyle get onPrimary => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnPrimary,
    letterSpacing: 0,
  );

  /// Greeting kecil di header
  static TextStyle get greeting => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: Colors.white70,
    letterSpacing: 0,
  );

  /// Nama besar di header dashboard
  static TextStyle get greetingName => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w300,
    color: Colors.white,
    letterSpacing: -0.64,
    height: 1.1,
  );
}
