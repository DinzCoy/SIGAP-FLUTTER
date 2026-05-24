import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Indikator loading standar — bisa dipakai inline atau fullscreen.
class LoadingIndicator extends StatelessWidget {
  final bool fullScreen;
  final String? message;

  const LoadingIndicator({super.key, this.fullScreen = false, this.message});
  const LoadingIndicator.fullScreen({super.key, this.message})
      : fullScreen = true;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2.5),
        if (message != null) ...[
          const SizedBox(height: 14),
          Text(message!, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ],
      ],
    );

    if (fullScreen) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: content),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(child: content),
    );
  }
}
