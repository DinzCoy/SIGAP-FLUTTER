// lib/pages/loan_request_page.dart
// Halaman Pengajuan Peminjaman Aset

import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../widgets/loans/loan_request_form.dart';

class LoanRequestPage extends StatelessWidget {
  final AssetModel? asset;

  const LoanRequestPage({super.key, this.asset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengajuan Peminjaman'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: LoanRequestForm(asset: asset),
      ),
    );
  }
}
