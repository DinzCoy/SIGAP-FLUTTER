import 'package:flutter/material.dart';
import 'app_colors_light.dart';
import 'app_colors_dark.dart';
import 'theme_manager.dart';

/// Palet warna resmi aplikasi SIGAP — THEME-AWARE RESOLVER.
/// Secara otomatis mengembalikan warna yang sesuai berdasarkan tema aktif.
/// Selalu gunakan class ini, JANGAN hardcode warna di file lain.
/// Token disinkronkan dengan DESIGN.md (Stripi-design-analysis).
class AppColors {
  AppColors._();

  /// Helper: apakah dark mode aktif saat ini
  static bool get _isDark => ThemeManager.instance.isDarkMode;

  // ── Brand Primary (Stripe Indigo) ──────────────────────────────────────
  /// Electric Indigo — CTA utama, satu filled button per band
  static Color get primary      => _isDark ? AppColorsDark.primary      : AppColorsLight.primary;
  static Color get primaryDeep  => _isDark ? AppColorsDark.primaryDeep  : AppColorsLight.primaryDeep;
  static Color get primaryPress => _isDark ? AppColorsDark.primaryPress : AppColorsLight.primaryPress;
  static Color get primaryLight => _isDark ? AppColorsDark.primaryLight : AppColorsLight.primaryLight;
  static Color get primaryBgSub => _isDark ? AppColorsDark.primaryBgSub : AppColorsLight.primaryBgSub;

  /// Deep Navy — Featured tier, dashboard chrome
  static Color get brandDark900 => _isDark ? AppColorsDark.brandDark900 : AppColorsLight.brandDark900;

  // ── Ink / Text ──────────────────────────────────────────────────────────
  /// Deep navy — body text, BUKAN pure black
  static Color get ink          => _isDark ? AppColorsDark.ink          : AppColorsLight.ink;
  static Color get inkSecondary => _isDark ? AppColorsDark.inkSecondary : AppColorsLight.inkSecondary;
  static Color get inkMute      => _isDark ? AppColorsDark.inkMute      : AppColorsLight.inkMute;
  static Color get inkMute2     => _isDark ? AppColorsDark.inkMute2     : AppColorsLight.inkMute2;

  /// Legacy alias — untuk kompatibilitas widget lama
  static Color get slate        => inkSecondary;
  static Color get charcoal     => inkMute;

  // ── Accent (dipertahankan sebagai warisan BPS, hanya aksen) ───────────
  static Color get accent       => _isDark ? AppColorsDark.accent       : AppColorsLight.accent;
  static Color get accentLight  => _isDark ? AppColorsDark.accentLight  : AppColorsLight.accentLight;
  static Color get accentDark   => _isDark ? AppColorsDark.accentDark   : AppColorsLight.accentDark;

  // ── Gradient Stops (Signature Mesh) ────────────────────────────────────
  /// Ruby — gradient accent, BUKAN button color
  static Color get ruby         => _isDark ? AppColorsDark.ruby         : AppColorsLight.ruby;
  /// Magenta — brighter pink gradient stop
  static Color get magenta      => _isDark ? AppColorsDark.magenta      : AppColorsLight.magenta;
  /// Lemon/Sherbet — warm gradient stop
  static Color get lemon        => _isDark ? AppColorsDark.lemon        : AppColorsLight.lemon;

  // ── Canvas / Surface ───────────────────────────────────────────────────
  static Color get canvas       => _isDark ? AppColorsDark.canvas       : AppColorsLight.canvas;
  static Color get canvasSoft   => _isDark ? AppColorsDark.canvasSoft   : AppColorsLight.canvasSoft;
  static Color get canvasCream  => _isDark ? AppColorsDark.canvasCream  : AppColorsLight.canvasCream;

  /// Legacy aliases
  static Color get background   => canvasSoft;
  static Color get surface      => canvas;
  static Color get surfaceAlt   => _isDark ? AppColorsDark.surfaceAlt   : AppColorsLight.surfaceAlt;

  // ── Text on Surface ────────────────────────────────────────────────────
  static Color get textPrimary   => ink;
  static Color get textSecondary => inkMute;
  static Color get textHint      => _isDark ? AppColorsDark.textHint      : AppColorsLight.textHint;
  static Color get textOnPrimary => _isDark ? AppColorsDark.textOnPrimary : AppColorsLight.textOnPrimary;
  static Color get textOnAccent  => _isDark ? AppColorsDark.textOnAccent  : AppColorsLight.textOnAccent;

  // ── Status / Semantic ──────────────────────────────────────────────────
  static Color get success     => _isDark ? AppColorsDark.success     : AppColorsLight.success;
  static Color get successBg   => _isDark ? AppColorsDark.successBg   : AppColorsLight.successBg;
  static Color get warning     => _isDark ? AppColorsDark.warning     : AppColorsLight.warning;
  static Color get warningBg   => _isDark ? AppColorsDark.warningBg   : AppColorsLight.warningBg;
  static Color get error       => _isDark ? AppColorsDark.error       : AppColorsLight.error;
  static Color get errorBg     => _isDark ? AppColorsDark.errorBg     : AppColorsLight.errorBg;
  static Color get info        => _isDark ? AppColorsDark.info        : AppColorsLight.info;
  static Color get infoBg      => _isDark ? AppColorsDark.infoBg      : AppColorsLight.infoBg;

  // ── Border / Hairline ──────────────────────────────────────────────────
  static Color get hairline      => _isDark ? AppColorsDark.hairline      : AppColorsLight.hairline;
  static Color get hairlineInput => _isDark ? AppColorsDark.hairlineInput : AppColorsLight.hairlineInput;
  static Color get shadowBlue    => _isDark ? AppColorsDark.shadowBlue    : AppColorsLight.shadowBlue;

  /// Legacy aliases
  static Color get border        => hairline;
  static Color get divider       => _isDark ? AppColorsDark.divider       : AppColorsLight.divider;

  // ── Border Radius Scale ({rounded.*}) ──────────────────────────────────
  // Tetap const — nilai radius sama untuk semua tema
  static const double radiusXs   = 4;
  static const double radiusSm   = 6;
  static const double radiusMd   = 8;
  static const double radiusLg   = 12;
  static const double radiusXl   = 16;
  static const double radiusPill = 9999;

  // ── Spacing Scale ({spacing.*}) ────────────────────────────────────────
  // Tetap const — nilai spacing sama untuk semua tema
  static const double spaceXxs  = 2;
  static const double spaceXs   = 4;
  static const double spaceSm   = 8;
  static const double spaceMd   = 12;
  static const double spaceLg   = 16;
  static const double spaceXl   = 24;
  static const double spaceXxl  = 32;
  static const double spaceHuge = 64;

  // ── Shadows (Stripe Premium) — Theme-Aware ──────────────────────────────
  /// Level 1 — Card lift
  static List<BoxShadow> get cardShadow =>
      _isDark ? AppColorsDark.cardShadow : AppColorsLight.cardShadow;

  /// Level 2 — Floating panels
  static List<BoxShadow> get floatShadow =>
      _isDark ? AppColorsDark.floatShadow : AppColorsLight.floatShadow;

  static List<BoxShadow> get subtleShadow =>
      _isDark ? AppColorsDark.subtleShadow : AppColorsLight.subtleShadow;

  static List<BoxShadow> get glassShadow =>
      _isDark ? AppColorsDark.glassShadow : AppColorsLight.glassShadow;

  static List<BoxShadow> get bottomNavShadow =>
      _isDark ? AppColorsDark.bottomNavShadow : AppColorsLight.bottomNavShadow;

  // ── Gradients — Theme-Aware ─────────────────────────────────────────────
  /// Primary Indigo gradient
  static LinearGradient get primaryGradient =>
      _isDark ? AppColorsDark.primaryGradient : AppColorsLight.primaryGradient;

  /// Signature Mesh — cream/lavender/indigo/ruby stops
  static LinearGradient get meshGradient =>
      _isDark ? AppColorsDark.meshGradient : AppColorsLight.meshGradient;

  static LinearGradient get glassGradient =>
      _isDark ? AppColorsDark.glassGradient : AppColorsLight.glassGradient;

  static LinearGradient get accentGradient =>
      _isDark ? AppColorsDark.accentGradient : AppColorsLight.accentGradient;

  /// Hero header gradient
  static LinearGradient get headerGradient =>
      _isDark ? AppColorsDark.headerGradient : AppColorsLight.headerGradient;
}
