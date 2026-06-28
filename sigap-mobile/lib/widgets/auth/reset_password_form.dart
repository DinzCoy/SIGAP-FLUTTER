import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_snackbar.dart';
import '../../widgets/common/app_text_field.dart';

/// Form reset password — validasi, submit ke AuthService, tampilkan feedback.
class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _emailCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_emailCtrl.text.isEmpty ||
        _newCtrl.text.isEmpty ||
        _confirmCtrl.text.isEmpty) {
      _showSnack('Semua kolom harus diisi!', isError: true);
      return;
    }
    if (_newCtrl.text != _confirmCtrl.text) {
      _showSnack('Password baru dan konfirmasi tidak cocok!', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final result = await AuthService.resetPassword(
      _emailCtrl.text.trim(),
      _newCtrl.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result == true) {
      _showSnack(
        'Password berhasil direset! Silakan login dengan password baru.',
        isError: false,
      );
      Navigator.pop(context);
    } else {
      _showSnack(result.toString(), isError: true);
    }
  }

  void _showSnack(String msg, {required bool isError}) {
    if (isError) {
      AppSnackbar.showError(context, title: 'Peringatan', message: msg);
    } else {
      AppSnackbar.showSuccess(context, title: 'Berhasil', message: msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon & header
          Icon(Icons.lock_reset, size: 80, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            'Atur Ulang Password',
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Silakan isi form di bawah ini untuk mereset kata sandi akun Anda.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Email
          AppTextField(
            label: 'Email atau Username',
            hint: 'Masukkan email atau username Anda',
            controller: _emailCtrl,
            prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),

          // Password baru
          AppTextField(
            label: 'Password Baru',
            hint: 'Masukkan password baru',
            controller: _newCtrl,
            obscureText: _obscureNew,
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureNew ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: () => setState(() => _obscureNew = !_obscureNew),
            ),
          ),
          const SizedBox(height: 20),

          // Konfirmasi password
          AppTextField(
            label: 'Konfirmasi Password',
            hint: 'Ulangi password baru',
            controller: _confirmCtrl,
            obscureText: _obscureConfirm,
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          const SizedBox(height: 32),

          AppButton.primary(
            label: 'Simpan Password Baru',
            isLoading: _isLoading,
            onTap: _submit,
          ),
        ],
      ),
    );
  }
}
