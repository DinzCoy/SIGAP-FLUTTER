import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

enum SnackbarType { success, error, warning, info }

class AppSnackbar {
  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    _currentEntry?.remove();
    _currentEntry = null;

    final overlayState = Overlay.maybeOf(context);
    if (overlayState == null) return;

    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (context) {
        return _TopToastWidget(
          title: title,
          message: message,
          type: type,
          duration: duration,
          onDismissed: () {
            if (_currentEntry == entry) {
              _currentEntry?.remove();
              _currentEntry = null;
            }
          },
        );
      },
    );

    _currentEntry = entry;
    overlayState.insert(entry);
  }

  static void showSuccess(BuildContext context, {required String title, required String message}) {
    show(context, title: title, message: message, type: SnackbarType.success);
  }

  static void showError(BuildContext context, {required String title, required String message}) {
    show(context, title: title, message: message, type: SnackbarType.error);
  }

  static void showWarning(BuildContext context, {required String title, required String message}) {
    show(context, title: title, message: message, type: SnackbarType.warning);
  }

  static void showInfo(BuildContext context, {required String title, required String message}) {
    show(context, title: title, message: message, type: SnackbarType.info);
  }
}

class _TopToastWidget extends StatefulWidget {
  final String title;
  final String message;
  final SnackbarType type;
  final Duration duration;
  final VoidCallback onDismissed;

  const _TopToastWidget({
    required this.title,
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismissed,
  });

  @override
  State<_TopToastWidget> createState() => _TopToastWidgetState();
}

class _TopToastWidgetState extends State<_TopToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted && !_dismissed) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    if (_dismissed) return;
    _dismissed = true;
    _controller.reverse().then((_) {
      if (mounted) widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color bgColor;
    IconData icon;

    switch (widget.type) {
      case SnackbarType.success:
        statusColor = AppColors.success;
        bgColor = AppColors.successBg;
        icon = Icons.check_circle_rounded;
        break;
      case SnackbarType.error:
        statusColor = AppColors.error;
        bgColor = AppColors.errorBg;
        icon = Icons.cancel_rounded;
        break;
      case SnackbarType.warning:
        statusColor = AppColors.warning;
        bgColor = AppColors.warningBg;
        icon = Icons.warning_rounded;
        break;
      case SnackbarType.info:
        statusColor = AppColors.primary;
        bgColor = AppColors.primaryBgSub;
        icon = Icons.info_rounded;
        break;
    }

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Material(
            color: Colors.transparent,
            child: SlideTransition(
              position: _offsetAnimation,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.primaryDelta! < -3) _dismiss();
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor, // Soft pale background
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 1.5), // White stroke
                    boxShadow: AppColors.floatShadow,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white, // Solid white circle
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: statusColor, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text(
                              widget.title,
                              style: AppTextStyles.titleSmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.message,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
