import 'package:flutter/material.dart';

/// Palet warna Resmi Light Theme aplikasi SIGAP — Stripe Design Language.
class AppColorsLight {
  AppColorsLight._();

  // ── Brand Primary (Stripe Indigo) ──────────────────────────────────────
  static const Color primary      = Color(0xFF533AFD);
  static const Color primaryDeep  = Color(0xFF4434D4);
  static const Color primaryPress = Color(0xFF2E2B8C);
  static const Color primaryLight = Color(0xFF665EFD);
  static const Color primaryBgSub = Color(0xFFB9B9F9);

  /// Deep Navy
  static const Color brandDark900 = Color(0xFF1C1E54);

  // ── Ink / Text ──────────────────────────────────────────────────────────
  static const Color ink          = Color(0xFF0D253D);
  static const Color inkSecondary = Color(0xFF273951);
  static const Color inkMute      = Color(0xFF64748D);
  static const Color inkMute2     = Color(0xFF61718A);

  static const Color slate        = inkSecondary;
  static const Color charcoal     = inkMute;

  // ── Accent ─────────────────────────────────────────────────────────────
  static const Color accent       = Color(0xFFF47920);
  static const Color accentLight  = Color(0xFFFF9A45);
  static const Color accentDark   = Color(0xFFD4640F);

  // ── Gradient Stops ────────────────────────────────────────────────────
  static const Color ruby         = Color(0xFFEA2261);
  static const Color magenta      = Color(0xFFF96BEE);
  static const Color lemon        = Color(0xFF9B6829);

  // ── Canvas / Surface ───────────────────────────────────────────────────
  static const Color canvas       = Color(0xFFFFFFFF);
  static const Color canvasSoft   = Color(0xFFF6F9FC);
  static const Color canvasCream  = Color(0xFFF5E9D4);

  static const Color background   = canvasSoft;
  static const Color surface      = canvas;
  static const Color surfaceAlt   = Color(0xFFF0F4FF);

  // ── Text on Surface ────────────────────────────────────────────────────
  static const Color textPrimary   = ink;
  static const Color textSecondary = inkMute;
  static const Color textHint      = Color(0xFFA5ACB8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
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
  static const Color hairline      = Color(0xFFE3E8EE);
  static const Color hairlineInput = Color(0xFFA8C3DE);
  static const Color shadowBlue    = Color(0xFF003770);

  static const Color border        = hairline;
  static const Color divider       = Color(0xFFF1F4F8);

  // ── Shadows (Stripe Premium) ────────────────────────────────────────────
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF003770).withValues(alpha: 0.08),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];

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
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, brandDark900],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient meshGradient = LinearGradient(
    colors: [
      Color(0xFFF5E9D4),
      Color(0xFFE8E4FF),
      Color(0xFF533AFD),
      Color(0xFFEA2261),
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

  static const LinearGradient headerGradient = LinearGradient(
    colors: [primary, Color(0xFF3D35C7), brandDark900],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
