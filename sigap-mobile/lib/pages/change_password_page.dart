import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_snackbar.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? '';

      final result = await AuthService.changePassword(
        userId,
        _oldPasswordController.text,
        _newPasswordController.text,
      );

      if (result == true) {
        if (mounted) {
          AppSnackbar.showSuccess(
            context,
            title: 'Berhasil',
            message: 'Password berhasil diubah',
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          AppSnackbar.showError(
            context,
            title: 'Gagal',
            message: result ?? 'Gagal mengubah password',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          title: 'Error',
          message: 'Terjadi kesalahan: $e',
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Ubah Password",
          style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: AppColors.floatShadow,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.lock_reset_rounded, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Keamanan Akun',
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                          Text(
                            'Perbarui password Anda secara berkala',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildPasswordField(
                  "Password Lama",
                  _oldPasswordController,
                  _obscureOld,
                  () => setState(() => _obscureOld = !_obscureOld),
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  "Password Baru",
                  _newPasswordController,
                  _obscureNew,
                  () => setState(() => _obscureNew = !_obscureNew),
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  "Konfirmasi Password Baru",
                  _confirmPasswordController,
                  _obscureConfirm,
                  () => setState(() => _obscureConfirm = !_obscureConfirm),
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return "Konfirmasi password tidak cocok";
                    }
                    if (value == null || value.isEmpty) {
                      return "Konfirmasi password tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                AppButton.primary(
                  label: 'Simpan Password',
                  isLoading: _isLoading,
                  onTap: _changePassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscure,
    VoidCallback toggleObscure, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Masukkan $label',
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.slate),
            prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.slate, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.slate,
                size: 20,
              ),
              onPressed: toggleObscure,
            ),
            filled: true,
            fillColor: AppColors.background.withValues(alpha: 0.5),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.error),
            ),
          ),
          validator:
              validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return "$label tidak boleh kosong";
                }
                if (value.length < 6) {
                  return "Password minimal 6 karakter";
                }
                return null;
              },
        ),
      ],
    );
  }
}
