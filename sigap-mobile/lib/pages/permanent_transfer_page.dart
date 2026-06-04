// lib/pages/permanent_transfer_page.dart
// Halaman Pengajuan Pengambilan Permanen / Mutasi Aset

import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../theme/app_colors.dart';
import '../widgets/transfer/permanent_transfer_form.dart';

class PermanentTransferPage extends StatelessWidget {
  final AssetModel? asset;

  const PermanentTransferPage({super.key, this.asset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Pengambilan Permanen')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: PermanentTransferForm(asset: asset),
      ),
    );
  }
}
