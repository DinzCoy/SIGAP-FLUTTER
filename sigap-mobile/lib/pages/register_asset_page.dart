// lib/pages/register_asset_page.dart
// Halaman Registrasi Aset Baru (berdasarkan hasil scan)

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/assets/register_asset_form.dart';

class RegisterAssetPage extends StatelessWidget {
  final String initialCode;

  const RegisterAssetPage({super.key, required this.initialCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Daftarkan Aset')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: RegisterAssetForm(initialCode: initialCode),
      ),
    );
  }
}
