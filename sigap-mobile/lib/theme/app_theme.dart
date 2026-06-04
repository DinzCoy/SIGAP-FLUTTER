import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Theme terpusat aplikasi SIGAP — sinkron dengan DESIGN.md.
///
/// Karena AppColors sekarang theme-aware (otomatis resolve light/dark),
/// satu definisi ThemeData sudah cukup untuk kedua mode tema.
///
/// Perubahan utama dari Stripe design spec:
/// • Button shape: pill (9999px radius) — bukan lagi rounded 16px.
/// • Input radius: {rounded.sm} = 6px — sesuai text-input component.
/// • Card radius: {rounded.lg} = 12px — feature card spec.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
      ),
      scaffoldBackgroundColor: AppColors.background,

      // ── AppBar ───────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        shadowColor: AppColors.hairline,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.ink,
        ),
        iconTheme: IconThemeData(color: AppColors.ink),
      ),

      // ── Elevated Button — {button-primary-pill} ──────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(64, 44), // Touch target WCAG AAA
          padding: const EdgeInsets.symmetric(
            horizontal: AppColors.spaceLg, // 16px
            vertical: AppColors.spaceSm, // 8px
          ),
          shape: const StadiumBorder(), // pill = 9999px radius
          textStyle: AppTextStyles.buttonMd.copyWith(color: Colors.white),
        ),
      ),

      // ── Outlined Button — {button-secondary} ────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary, width: 1),
          minimumSize: const Size(64, 44),
          padding: const EdgeInsets.symmetric(
            horizontal: AppColors.spaceLg,
            vertical: AppColors.spaceSm,
          ),
          shape: const StadiumBorder(), // pill shape
          textStyle: AppTextStyles.buttonMd.copyWith(color: AppColors.primary),
        ),
      ),

      // ── Text Button ──────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.link,
          minimumSize: const Size(0, 36),
        ),
      ),

      // ── Input / TextField — {text-input} ────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.canvas,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusSm), // 6px
          borderSide: BorderSide(color: AppColors.hairlineInput),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusSm),
          borderSide: BorderSide(color: AppColors.hairlineInput),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusSm),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusSm),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusSm),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.inkMute),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppColors.spaceMd, // 12px
          vertical: AppColors.spaceSm, // 8px
        ),
        isDense: false,
      ),

      // ── Card — {card-feature-light} ─────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusLg), // 12px
          side: BorderSide(color: AppColors.hairline, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Divider ──────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: AppColors.hairline,
        thickness: 1,
        space: 1,
      ),

      // ── Bottom Navigation Bar ────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.inkMute,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyles.microCap.copyWith(
          color: AppColors.primary,
          letterSpacing: 0.2,
        ),
        unselectedLabelStyle: AppTextStyles.microCap.copyWith(
          color: AppColors.inkMute,
        ),
      ),

      // ── Navigation Bar (Material 3) ──────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryBgSub.withValues(alpha: 0.4),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.microCap.copyWith(color: AppColors.primary);
          }
          return AppTextStyles.microCap.copyWith(color: AppColors.inkMute);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.primary, size: 24);
          }
          return IconThemeData(color: AppColors.inkMute, size: 22);
        }),
      ),

      // ── Chip — {pill-tag-soft} ───────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryBgSub,
        labelStyle: AppTextStyles.microCap.copyWith(
          color: AppColors.primaryDeep,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppColors.spaceSm, // 8px
          vertical: AppColors.spaceXs, // 4px
        ),
        shape: const StadiumBorder(), // pill
        side: BorderSide.none,
      ),

      // ── Text Theme ───────────────────────────────────────────────────────
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayXxl,
        displayMedium: AppTextStyles.displayXl,
        displaySmall: AppTextStyles.displayLarge,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
    );
  }

  // Getter Tema Gelap Dinamis
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
      ),
      scaffoldBackgroundColor: AppColors.background,

      // ── AppBar ───────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        shadowColor: AppColors.hairline,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.ink,
        ),
        iconTheme: IconThemeData(color: AppColors.ink),
      ),

      // ── Elevated Button — {button-primary-pill} ──────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(64, 44),
          padding: const EdgeInsets.symmetric(
            horizontal: AppColors.spaceLg,
            vertical: AppColors.spaceSm,
          ),
          shape: const StadiumBorder(),
          textStyle: AppTextStyles.buttonMd.copyWith(color: Colors.white),
        ),
      ),

      // ── Outlined Button — {button-secondary} ────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary, width: 1),
          minimumSize: const Size(64, 44),
          padding: const EdgeInsets.symmetric(
            horizontal: AppColors.spaceLg,
            vertical: AppColors.spaceSm,
          ),
          shape: const StadiumBorder(),
          textStyle: AppTextStyles.buttonMd.copyWith(color: AppColors.primary),
        ),
      ),

      // ── Text Button ──────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.link,
          minimumSize: const Size(0, 36),
        ),
      ),

      // ── Input / TextField ───────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.canvas,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusSm),
          borderSide: BorderSide(color: AppColors.hairlineInput),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusSm),
          borderSide: BorderSide(color: AppColors.hairlineInput),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusSm),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusSm),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusSm),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.inkMute),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppColors.spaceMd,
          vertical: AppColors.spaceSm,
        ),
        isDense: false,
      ),

      // ── Card ─────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusLg),
          side: BorderSide(color: AppColors.hairline, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Divider ──────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: AppColors.hairline,
        thickness: 1,
        space: 1,
      ),

      // ── Bottom Navigation Bar ────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.inkMute,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyles.microCap.copyWith(
          color: AppColors.primary,
          letterSpacing: 0.2,
        ),
        unselectedLabelStyle: AppTextStyles.microCap.copyWith(
          color: AppColors.inkMute,
        ),
      ),

      // ── Navigation Bar (Material 3) ──────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryBgSub.withValues(alpha: 0.4),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.microCap.copyWith(color: AppColors.primary);
          }
          return AppTextStyles.microCap.copyWith(color: AppColors.inkMute);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.primary, size: 24);
          }
          return IconThemeData(color: AppColors.inkMute, size: 22);
        }),
      ),

      // ── Chip ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryBgSub,
        labelStyle: AppTextStyles.microCap.copyWith(
          color: AppColors.primaryDeep,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppColors.spaceSm,
          vertical: AppColors.spaceXs,
        ),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),

      // ── Text Theme ───────────────────────────────────────────────────────
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayXxl,
        displayMedium: AppTextStyles.displayXl,
        displaySmall: AppTextStyles.displayLarge,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
    );
  }
}
