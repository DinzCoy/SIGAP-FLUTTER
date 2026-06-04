import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import 'login_page.dart';
import 'admin_dashboard.dart';
import 'technician_dashboard.dart';
import 'user_dashboard.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Animasi Fade In untuk halaman
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // 2. Animasi Float untuk Logo (seperti di auth.blade.php)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0.0, end: -12.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    // Memberikan jeda waktu agar animasi splash screen terlihat (3 detik)
    await Future.delayed(const Duration(seconds: 3));

    final token = await AuthService.getToken();
    
    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString('user_role') ?? 'User';
      
      Widget nextPage;
      switch (role) {
        case 'Admin':
        case 'Administrator':
          nextPage = const AdminDashboardPage();
          break;
        case 'Ketua Tim':
        case 'Teknisi':
          nextPage = const TechnicianDashboardPage();
          break;
        case 'User':
        default:
          nextPage = const UserDashboardPage();
      }
      
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, _, _) => nextPage,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const LoginPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Background menyesuaikan dengan auth.blade.php (warna BPS Navy / Primary)
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo SIGAP Float & Shimmer
              AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Base SVG Shield Logo
                        SvgPicture.asset(
                          'assets/images/logo_sigap.svg',
                          width: 140,
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                        // Slow Shimmer Sweep Overlay
                        Shimmer.fromColors(
                          baseColor: Colors.transparent,
                          highlightColor: Colors.white.withValues(alpha: 0.45),
                          period: const Duration(seconds: 4),
                          child: SvgPicture.asset(
                            'assets/images/logo_sigap.svg',
                            width: 140,
                            height: 140,
                            fit: BoxFit.contain,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              
              // Nama Aplikasi
              const Text(
                'SIGAP',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                'Sistem Guardian Aset & Pelayanan IT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              
              // Indikator Loading
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
