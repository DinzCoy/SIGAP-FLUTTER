import 'package:flutter/material.dart';

/// Palet warna resmi aplikasi SIGAP — terinspirasi Stripe Design Language.
/// Selalu gunakan class ini, JANGAN hardcode warna di file lain.
/// Token disinkronkan dengan DESIGN.md (Stripi-design-analysis).
class AppColors {
  AppColors._();

  // ── Brand Primary (Stripe Indigo) ──────────────────────────────────────
  /// Electric Indigo — CTA utama, satu filled button per band
  static const Color primary      = Color(0xFF533AFD); // {colors.primary}
  static const Color primaryDeep  = Color(0xFF4434D4); // {colors.primary-deep}
  static const Color primaryPress = Color(0xFF2E2B8C); // {colors.primary-press}
  static const Color primaryLight = Color(0xFF665EFD); // {colors.primary-soft}
  static const Color primaryBgSub = Color(0xFFB9B9F9); // {colors.primary-bg-subdued-hover}

  /// Deep Navy — Featured tier, dashboard chrome
  static const Color brandDark900 = Color(0xFF1C1E54); // {colors.brand-dark-900}

  // ── Ink / Text ──────────────────────────────────────────────────────────
  /// Deep navy — body text, BUKAN pure black
  static const Color ink          = Color(0xFF0D253D); // {colors.ink}
  static const Color inkSecondary = Color(0xFF273951); // {colors.ink-secondary}
  static const Color inkMute      = Color(0xFF64748D); // {colors.ink-mute} — captions, labels
  static const Color inkMute2     = Color(0xFF61718A); // {colors.ink-mute-2} — nav

  /// Legacy alias — untuk kompatibilitas widget lama
  static const Color slate        = inkSecondary;
  static const Color charcoal     = inkMute;

  // ── Accent (dipertahankan sebagai warisan BPS, hanya aksen) ───────────
  static const Color accent       = Color(0xFFF47920);
  static const Color accentLight  = Color(0xFFFF9A45);
  static const Color accentDark   = Color(0xFFD4640F);

  // ── Gradient Stops (Signature Mesh) ────────────────────────────────────
  /// Ruby — gradient accent, BUKAN button color
  static const Color ruby         = Color(0xFFEA2261); // {colors.ruby}
  /// Magenta — brighter pink gradient stop
  static const Color magenta      = Color(0xFFF96BEE); // {colors.magenta}
  /// Lemon/Sherbet — warm gradient stop
  static const Color lemon        = Color(0xFF9B6829); // {colors.lemon}

  // ── Canvas / Surface ───────────────────────────────────────────────────
  static const Color canvas       = Color(0xFFFFFFFF); // {colors.canvas}
  static const Color canvasSoft   = Color(0xFFF6F9FC); // {colors.canvas-soft}
  static const Color canvasCream  = Color(0xFFF5E9D4); // {colors.canvas-cream}

  /// Legacy aliases
  static const Color background   = canvasSoft;
  static const Color surface      = canvas;
  static const Color surfaceAlt   = Color(0xFFF0F4FF);

  // ── Text on Surface ────────────────────────────────────────────────────
  static const Color textPrimary   = ink;
  static const Color textSecondary = inkMute;
  static const Color textHint      = Color(0xFFA5ACB8);
  static const Color textOnPrimary = Color(0xFFFFFFFF); // {colors.on-primary}
  static const Color textOnAccent  = Color(0xFFFFFFFF);

  // ── Status / Semantic ──────────────────────────────────────────────────
  static const Color success     = Color(0xFF22C55E);
  static const Color successBg   = Color(0xFFDCFCE7);
  static const Color warning     = Color(0xFFEAB308);
  static const Color warningBg   = Color(0xFFFEF9C3);
  static const Color error       = Color(0xFFEF4444);
  static const Color errorBg     = Color(0xFFFEE2E2);
  static const Color info        = Color(0xFF0EA5E9);
  static const Color infoBg      = Color(0xFFE0F2FE);

  // ── Border / Hairline ──────────────────────────────────────────────────
  static const Color hairline      = Color(0xFFE3E8EE); // {colors.hairline} — 1px border cards
  static const Color hairlineInput = Color(0xFFA8C3DE); // {colors.hairline-input} — form input
  static const Color shadowBlue    = Color(0xFF003770); // {colors.shadow-blue}

  /// Legacy aliases
  static const Color border        = hairline;
  static const Color divider       = Color(0xFFF1F4F8);

  // ── Border Radius Scale ({rounded.*}) ──────────────────────────────────
  static const double radiusXs   = 4;   // {rounded.xs} — tags, table chrome
  static const double radiusSm   = 6;   // {rounded.sm} — form inputs
  static const double radiusMd   = 8;   // {rounded.md} — compact cards, alerts
  static const double radiusLg   = 12;  // {rounded.lg} — pricing/feature cards
  static const double radiusXl   = 16;  // {rounded.xl} — dashboard chrome
  static const double radiusPill = 9999; // {rounded.pill} — SEMUA BUTTONS

  // ── Spacing Scale ({spacing.*}) ────────────────────────────────────────
  static const double spaceXxs  = 2;
  static const double spaceXs   = 4;
  static const double spaceSm   = 8;
  static const double spaceMd   = 12;
  static const double spaceLg   = 16;
  static const double spaceXl   = 24;
  static const double spaceXxl  = 32;
  static const double spaceHuge = 64;

  // ── Shadows (Stripe Premium) ────────────────────────────────────────────
  /// Level 1 — Card lift on white
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF003770).withValues(alpha: 0.08),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];

  /// Level 2 — Floating panels, dashboard mockup chrome
  static List<BoxShadow> floatShadow = [
    BoxShadow(
      color: const Color(0xFF003770).withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: const Color(0xFF003770).withValues(alpha: 0.04),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  /// Subtle shadow untuk elemen kecil
  static List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: const Color(0xFF003770).withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> bottomNavShadow = [
    BoxShadow(
      color: const Color(0xFF003770).withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, -4),
    ),
  ];

  // ── Gradients ───────────────────────────────────────────────────────────
  /// Primary Indigo gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, brandDark900],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Signature Mesh — cream/lavender/indigo/ruby stops
  /// Digunakan di PremiumBackground dan DashboardHeader
  static const LinearGradient meshGradient = LinearGradient(
    colors: [
      Color(0xFFF5E9D4), // cream
      Color(0xFFE8E4FF), // lavender
      Color(0xFF533AFD), // indigo
      Color(0xFFEA2261), // ruby
    ],
    stops: [0.0, 0.35, 0.7, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Colors.white12,
      Colors.white24,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Hero header gradient — indigo ke brandDark dengan purple mid
  static const LinearGradient headerGradient = LinearGradient(
    colors: [primary, Color(0xFF3D35C7), brandDark900],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
