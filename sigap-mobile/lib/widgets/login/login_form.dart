import 'package:flutter/material.dart';

import '../../pages/admin_dashboard.dart';
import '../../pages/technician_dashboard.dart';
import '../../pages/user_dashboard.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../common/app_button.dart';
import '../common/app_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String? _selectedRole;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final List<String> _roles = [
    'Admin',
    'Pimpinan',
    'Teknisi',
    'Pengelola Barang',
    'Pengelola Ruangan',
    'User',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih Role terlebih dahulu!')),
      );
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);

    final loginResult = await AuthService.verifyLogin(
      email,
      password,
      _selectedRole!,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (loginResult == true) {
      Widget nextPage;
      switch (_selectedRole) {
        case 'Admin':
          nextPage = const AdminDashboardPage();
          break;
        case 'Teknisi':
          nextPage = const TechnicianDashboardPage();
          break;
        case 'User':
          nextPage = const UserDashboardPage();
          break;
        default:
          // Pimpinan, Pengelola Barang, Pengelola Ruangan belum
          // punya dashboard khusus — gunakan UserDashboardPage sementara.
          nextPage = const UserDashboardPage();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loginResult.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      Text(
        'Selamat Datang',
        style: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.ink,
        ),
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
            _obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
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
      
      DropdownMenu<String>(
        initialSelection: _selectedRole,
        hintText: '-- Pilih Role Aktif --',
        label: const Text('Masuk Sebagai'),
        expandedInsets: EdgeInsets.zero,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusSm), // 6px
            borderSide: BorderSide(color: AppColors.hairline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusSm),
            borderSide: BorderSide(color: AppColors.hairline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusSm),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: AppColors.canvas,
        ),
        dropdownMenuEntries: _roles.map((role) {
          final isEnabled = role == 'Admin' || role == 'User' || role == 'Teknisi';
          return DropdownMenuEntry<String>(
            value: role, 
            label: role,
            enabled: isEnabled,
          );
        }).toList(),
        onSelected: (value) {
          setState(() {
            _selectedRole = value;
          });
        },
      ),
      const SizedBox(height: 20),
      
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
