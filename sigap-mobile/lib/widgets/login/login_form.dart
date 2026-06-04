import 'package:flutter/material.dart';

import '../../pages/admin_dashboard.dart';
import '../../pages/technician_dashboard.dart';
import '../../pages/user_dashboard.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../common/app_button.dart';
import '../common/app_snackbar.dart';
import '../common/app_text_field.dart';
import '../common/role_selection_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;
    if (rememberMe) {
      final savedEmail = prefs.getString('saved_email') ?? '';
      final savedPassword = prefs.getString('saved_password') ?? '';
      if (mounted) {
        setState(() {
          _rememberMe = true;
          _emailController.text = savedEmail;
          _passwordController.text = savedPassword;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      AppSnackbar.showWarning(
        context,
        title: 'Perhatian',
        message: 'Email/Username dan Password tidak boleh kosong.',
      );
      return;
    }

    setState(() => _isLoading = true);

    final loginResult = await AuthService.verifyLogin(email, password);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (loginResult is Map && loginResult['success'] == true) {
      // Simpan kredensial jika Remember Me dicentang
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setBool('remember_me', true);
        await prefs.setString('saved_email', email);
        await prefs.setString('saved_password', password);
      } else {
        await prefs.setBool('remember_me', false);
        await prefs.remove('saved_email');
        await prefs.remove('saved_password');
      }

      final roles = loginResult['roles'] as List<Map<String, dynamic>>;

      if (!mounted) return;

      if (roles.isEmpty) {
        await prefs.setString('user_role', 'User');
        await prefs.setInt('user_role_id', 6);
        _navigateToRole('User');
      } else if (roles.length == 1) {
        final roleId = int.tryParse(roles[0]['id'].toString()) ?? 6;
        final roleName = roles[0]['name'] ?? 'User';
        await prefs.setString('user_role', roleName);
        await prefs.setInt('user_role_id', roleId);
        _navigateToRole(roleName);
      } else {
        RoleSelectionSheet.show(
          context,
          roles: roles,
          onRoleSelected: (roleId, roleName) async {
            await prefs.setString('user_role', roleName);
            await prefs.setInt('user_role_id', roleId);
            
            // Tunggu animasi pop selesai supaya tidak nabrak pushReplacement (_debugLocked)
            await Future.delayed(const Duration(milliseconds: 300));
            if (!mounted) return;
            _navigateToRole(roleName);
          },
        );
      }
    } else {
      String msg = 'Pastikan email/username dan password yang Anda masukkan sudah benar.';
      if (loginResult is Map) {
        msg = loginResult['message'] ?? msg;
      } else if (loginResult is String) {
        // Jika backend mengembalikan pesan error default
        if (loginResult.contains('401')) {
          msg = 'Email/Username atau Password yang Anda masukkan salah.';
        } else {
          msg = loginResult;
        }
      }
      
      AppSnackbar.showError(
        context,
        title: 'Gagal Masuk',
        message: msg,
      );
    }
  }

  void _navigateToRole(String role) {
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      Text(
        'Selamat Datang',
        style: AppTextStyles.headlineLarge.copyWith(color: AppColors.ink),
      ),
      const SizedBox(height: 8),
      Text(
        'Silakan masuk menggunakan akun Anda untuk mengakses dashboard.',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.inkMute),
      ),
      const SizedBox(height: 40),

      AppTextField(
        label: 'Email atau Username',
        hint: 'Masukkan email atau username',
        controller: _emailController,
        prefixIcon: const Icon(Icons.person_outline_rounded),
      ),
      const SizedBox(height: 20),

      AppTextField(
        label: 'Password',
        hint: 'Masukkan kata sandi',
        controller: _passwordController,
        obscureText: _obscurePassword,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            color: AppColors.textSecondary,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      const SizedBox(height: 20),

      // Dropdown role dihapus, menggunakan RoleSelectionSheet setelah login
      const SizedBox(height: 8),

      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _rememberMe,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Ingat Saya',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.inkMute),
          ),
        ],
      ),
      const SizedBox(height: 32),

      AppButton.primary(
        label: 'Masuk ke Dashboard',
        isLoading: _isLoading,
        onTap: _handleLogin,
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(items.length, (index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 100)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: items[index],
        );
      }),
    );
  }
}
