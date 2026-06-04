import 'package:flutter/material.dart';

/// Palet warna Resmi Dark Theme (Deep Slate & Midnight Neon) aplikasi SIGAP.
class AppColorsDark {
  AppColorsDark._();

  // ── Brand Primary (Stripe Indigo Adaptif - Lebih Cerah di Layar Gelap) ────
  static const Color primary = Color(0xFF6366F1); // Neon Indigo (Indigo 500)
  static const Color primaryDeep = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryPress = Color(0xFF4338CA); // Indigo 700
  static const Color primaryLight = Color(0xFF818CF8); // Indigo 400
  static const Color primaryBgSub = Color(
    0xFF1E1B4B,
  ); // Deep Purple-Indigo base

  /// Deep Slate / Charcoal base
  static const Color brandDark900 = Color(0xFF020617); // Dark Slate 950

  // ── Ink / Text ──────────────────────────────────────────────────────────
  static const Color ink = Color(0xFFF8FAFC); // Slate 50 (Sangat cerah, bersih)
  static const Color inkSecondary = Color(
    0xFFE2E8F0,
  ); // Slate 200 (Sub-headline)
  static const Color inkMute = Color(0xFF94A3B8); // Slate 400 (Muted labels)
  static const Color inkMute2 = Color(0xFF64748D); // Slate 500 (Captions)

  static const Color slate = inkSecondary;
  static const Color charcoal = inkMute;

  // ── Accent (Electric Tangerine) ─────────────────────────────────────────
  static const Color accent = Color(0xFFF97316); // Orange 500
  static const Color accentLight = Color(0xFFFB923C); // Orange 400
  static const Color accentDark = Color(0xFFEA580C); // Orange 600

  // ── Gradient Stops ────────────────────────────────────────────────────
  static const Color ruby = Color(0xFFF43F5E); // Rose 500
  static const Color magenta = Color(0xFFEC4899); // Pink 500
  static const Color lemon = Color(0xFFEAB308); // Yellow 500

  // ── Canvas / Surface ───────────────────────────────────────────────────
  static const Color canvas = Color(0xFF0B0F19); // Midnight Navy (Canvas Utama)
  static const Color canvasSoft = Color(
    0xFF131926,
  ); // Midnight Slate (Latar belakang scaffold)
  static const Color canvasCream = Color(
    0xFF1E2530,
  ); // Deep Slate dengan sedikit kehangatan

  static const Color background = canvasSoft;
  static const Color surface = canvasSoft;
  static const Color surfaceAlt = Color(0xFF1E293B); // Slate 800

  // ── Text on Surface ────────────────────────────────────────────────────
  static const Color textPrimary = ink;
  static const Color textSecondary = inkMute;
  static const Color textHint = Color(0xFF475569); // Slate 600
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFFFFFFFF);

  // ── Status / Semantic (Warna Neon Adaptif untuk Aksesibilitas Gelap) ─────
  static const Color success = Color(0xFF4ADE80); // Emerald 400 (Lebih cerah)
  static const Color successBg = Color(
    0xFF064E3B,
  ); // Emerald 900 (Sangat gelap)
  static const Color warning = Color(0xFFFBBF24); // Amber 400
  static const Color warningBg = Color(0xFF78350F); // Amber 900
  static const Color error = Color(0xFFF87171); // Red 400
  static const Color errorBg = Color(0xFF7F1D1D); // Red 900
  static const Color info = Color(0xFF38BDF8); // Sky 400
  static const Color infoBg = Color(0xFF0C4A6E); // Sky 900

  // ── Border / Hairline (Sangat Halus & Berkelas) ───────────────────────
  static const Color hairline = Color(0xFF1E293B); // Slate 800
  static const Color hairlineInput = Color(0xFF334155); // Slate 700
  static const Color shadowBlue = Color(0xFF020617); // Dark shadow

  static const Color border = hairline;
  static const Color divider = Color(0xFF1E293B);

  // ── Shadows (Lebih Gelap & Lembut untuk Dark Mode) ──────────────────────
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.35),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> floatShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.5),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.45),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> bottomNavShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: 20,
      offset: const Offset(0, -4),
    ),
  ];

  // ── Gradients Premium (Deep space glow) ──────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, brandDark900],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient meshGradient = LinearGradient(
    colors: [
      Color(0xFF1E2530),
      Color(0xFF131926),
      Color(0xFF6366F1),
      Color(0xFFEA2261),
    ],
    stops: [0.0, 0.35, 0.7, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Colors.white10, Colors.white24],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [primaryBgSub, Color(0xFF312E81), brandDark900],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
