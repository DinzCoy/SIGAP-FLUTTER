import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/asset_model.dart';
import '../../services/loan_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import 'loan_asset_card.dart';
import 'loan_date_picker.dart';

/// Form pengajuan peminjaman aset. Berisi semua logika validasi & submit.
class LoanRequestForm extends StatefulWidget {
  final AssetModel? asset;

  const LoanRequestForm({super.key, this.asset});

  @override
  State<LoanRequestForm> createState() => _LoanRequestFormState();
}

class _LoanRequestFormState extends State<LoanRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _alasanCtrl = TextEditingController();

  DateTime? _dueDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _alasanCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final initialDate = _dueDate ?? DateTime.now().add(const Duration(days: 1));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dueDate == null) {
      _showSnackBar('Pilih rencana tanggal kembali');
      return;
    }
    if (widget.asset == null) {
      _showSnackBar('Pilih aset terlebih dahulu (Scan)');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final df = DateFormat('yyyy-MM-dd');
      await LoanService.requestLoan(
        assetId: widget.asset!.id,
        alasan: _alasanCtrl.text.trim(),
        tanggalKembali: df.format(_dueDate!),
      );
      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Gagal mengajukan pinjaman: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.successBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text('Pengajuan Terkirim!', style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Pengajuan peminjaman sedang menunggu persetujuan Admin.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            AppButton.primary(
              label: 'OK',
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoanAssetCard(asset: widget.asset),
          const SizedBox(height: 24),

          // Tanggal kembali
          LoanDatePicker(
            label: 'Rencana Kembali *',
            selectedDate: _dueDate,
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 24),

          AppTextField(
            label: 'Keperluan Peminjaman *',
            hint: 'Cth: Keperluan meeting di luar kota / dinas luar',
            controller: _alasanCtrl,
            maxLines: 4,
            validator: (v) => v!.trim().isEmpty ? 'Alasan wajib diisi' : null,
          ),
          const SizedBox(height: 32),

          AppButton.primary(
            label: 'Ajukan Peminjaman',
            icon: const Icon(Icons.send_rounded, size: 20, color: Colors.white),
            isLoading: _isLoading,
            onTap: widget.asset == null ? null : _submit,
          ),
        ],
      ),
    );
  }
}
