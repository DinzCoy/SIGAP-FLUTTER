import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/auth_service.dart';
import 'admin_dashboard.dart';
import 'dashboard_page.dart';
import 'reset_password_page.dart';
import 'technician_dashboard.dart';
import 'user_dashboard.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth > 800;

          Widget leftContentBody = Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF39200),
                    width: 4.0,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'BPS',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00558D),
                    ),
                  ),
                ),
              ),
              SizedBox(height: isDesktop ? 32 : 24),
              Text(
                'SIGAP',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: isDesktop ? 16 : 4),
              Text(
                'Sistem Monitoring Terpadu Aset Komputer\nBadan Pusat Statistik (BPS) Provinsi Sulawesi Selatan.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '© 2026 BPS Sulsel',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          );

          Widget leftSection = Container(
            color: const Color(0xFF00558D),
            padding: const EdgeInsets.all(32.0),
            child: SafeArea(
              bottom: false,
              child: isDesktop
                  ? Center(child: SingleChildScrollView(child: leftContentBody))
                  : leftContentBody,
            ),
          );

          Widget rightContent = Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: const LoginForm(),
          );

          if (isDesktop) {
            return Row(
              children: [
                Expanded(child: leftSection),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(32.0),
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
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(32.0),
                    width: double.infinity,
                    child: Center(child: rightContent),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String? _selectedRole;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Selamat Datang',
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Silakan masuk menggunakan akun Anda untuk mengakses dashboard.',
          style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 48),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email atau Username',
            hintText: 'Masukkan email atau username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00558D), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Masukkan kata sandi',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00558D), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        DropdownMenu<String>(
          initialSelection: _selectedRole,
          hintText: '-- Pilih Role Aktif --',
          label: const Text('Masuk Sebagai'),
          expandedInsets: EdgeInsets.zero,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00558D), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          dropdownMenuEntries: _roles.map((role) {
            return DropdownMenuEntry<String>(value: role, label: role);
          }).toList(),
          onSelected: (value) {
            setState(() {
              _selectedRole = value;
            });
          },
        ),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _rememberMe,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    activeColor: const Color(0xFF00558D),
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
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResetPasswordPage(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Lupa password?',
                style: GoogleFonts.inter(
                  color: const Color(0xFF00558D),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () async {
            if (_selectedRole == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pilih Role terlebih dahulu!')),
              );
              return;
            }

            final email = _emailController.text.trim();
            final password = _passwordController.text;

            // Tampilkan loading indicator di sini (opsional)
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );

            final loginResult = await AuthService.verifyLogin(
              email,
              password,
              _selectedRole!,
            );

            // Tutup loading indicator
            if (context.mounted) {
              Navigator.pop(context);
            }

            if (loginResult == true) {
              if (!context.mounted) return;
              if (_selectedRole == 'Admin') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminDashboardPage(),
                  ),
                );
              } else if (_selectedRole == 'Teknisi') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TechnicianDashboardPage(),
                  ),
                );
              } else if (_selectedRole == 'User') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserDashboardPage(),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BaseDashboard(role: _selectedRole!),
                  ),
                );
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loginResult.toString())),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00558D),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Masuk ke Dashboard',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
