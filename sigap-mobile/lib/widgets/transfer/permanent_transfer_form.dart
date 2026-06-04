import 'package:flutter/material.dart';
import '../../models/asset_model.dart';
import '../../services/asset_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import 'transfer_widgets.dart';

/// Form pengajuan mutasi/pengambilan permanen aset.
class PermanentTransferForm extends StatefulWidget {
  final AssetModel? asset;

  const PermanentTransferForm({super.key, this.asset});

  @override
  State<PermanentTransferForm> createState() => _PermanentTransferFormState();
}

class _PermanentTransferFormState extends State<PermanentTransferForm> {
  final _formKey = GlobalKey<FormState>();
  final _alasanCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _alasanCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.asset == null) {
      _showSnack('Pilih aset terlebih dahulu (Scan)', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Endpoint khusus mutasi permanen: POST /asset/transfer
      // Berbeda dari peminjaman — langsung memutasi kepemilikan aset (takeover).
      await AssetService.requestTransfer(
        assetId: widget.asset!.id,
        reason: _alasanCtrl.text.trim(),
      );
      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      _showSnack('Gagal mengajukan alokasi: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.success,
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
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.transfer_within_a_station,
                color: AppColors.accent,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text('Pengajuan Terkirim!', style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Pengajuan mutasi/alokasi permanen telah dikirim dan sedang menunggu persetujuan Admin.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
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
          const TransferWarningBanner(),
          const SizedBox(height: 24),

          TransferAssetCard(asset: widget.asset),
          const SizedBox(height: 24),

          AppTextField(
            label: 'Alasan Pengambilan *',
            hint: 'Cth: Pergantian PC kantor utama, Mutasi divisi...',
            controller: _alasanCtrl,
            maxLines: 4,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Alasan wajib diisi';
              if (v.trim().length < 10) return 'Alasan minimal 10 karakter';
              return null;
            },
          ),
          const SizedBox(height: 32),

          AppButton.primary(
            label: 'Ajukan Alokasi / Mutasi Permanen',
            icon: const Icon(
              Icons.move_to_inbox_rounded,
              size: 20,
              color: Colors.white,
            ),
            isLoading: _isLoading,
            onTap: widget.asset == null ? null : _submit,
          ),
        ],
      ),
    );
  }
}
