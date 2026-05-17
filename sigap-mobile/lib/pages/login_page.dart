import 'dart:ui';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/login/login_banner.dart';
import '../widgets/login/login_form.dart';
import '../widgets/common/premium_background.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.canvasCream,
      body: PremiumBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isDesktop = constraints.maxWidth > 800;

            final Widget leftSection = LoginBanner(isDesktop: isDesktop);

            final Widget rightContent = Container(
              constraints: const BoxConstraints(maxWidth: 450),
              decoration: BoxDecoration(
                boxShadow: AppColors.floatShadow, // Shadow di luar
                borderRadius: BorderRadius.circular(AppColors.radiusXl),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppColors.radiusXl),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24), // Efek blur kaca
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55), // Enhanced frosty glass transparency
                      borderRadius: BorderRadius.circular(AppColors.radiusXl),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.6), // Glossy border
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(32.0),
                    child: const LoginForm(),
                  ),
                ),
              ),
            );

            if (isDesktop) {
              return Row(
                children: [
                  Expanded(child: leftSection),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      child: Center(
                        child: SingleChildScrollView(child: rightContent),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: leftSection,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
                      child: rightContent,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
