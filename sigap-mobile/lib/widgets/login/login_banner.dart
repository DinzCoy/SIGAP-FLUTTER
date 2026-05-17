import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class LoginBanner extends StatelessWidget {
  final bool isDesktop;

  const LoginBanner({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: SafeArea(
        bottom: false,
        child: isDesktop
            ? Center(child: SingleChildScrollView(child: _buildContent()))
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.canvas,
            shape: BoxShape.circle,
            boxShadow: AppColors.floatShadow,
            border: Border.all(
              color: AppColors.hairline,
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              'SIGAP',
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                height: 1.0,
                letterSpacing: -1.0,
              ),
            ),
          ),
        ),
        SizedBox(height: isDesktop ? 32 : 24),
        Text(
          'SIGAP',
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: isDesktop ? 16 : 4),
        Text(
          'Sistem Guardian Aset dan Pelayanan IT\nProvinsi Sulawesi Selatan.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.inkMute,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          '© 2026 SIGAP Team',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.slate,
          ),
        ),
      ],
    );
  }
}
