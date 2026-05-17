import 'package:flutter/material.dart';
import '../../models/asset_model.dart';
import '../../pages/loan_request_page.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/app_button.dart';

/// Bottom sheet yang tampil setelah user scan QR aset.
/// Menampilkan detail aset + tombol aksi kontekstual berdasarkan loan_status.
class AssetDetailSheet extends StatelessWidget {
  final AssetModel asset;
  final VoidCallback onScanAnother;

  const AssetDetailSheet({
    super.key,
    required this.asset,
    required this.onScanAnother,
  });

  static Future<void> show(
    BuildContext context, {
    required AssetModel asset,
    required VoidCallback onScanAnother,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AssetDetailSheet(asset: asset, onScanAnother: onScanAnother),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header Aset ──────────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.computer_rounded,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              asset.nama,
                              style: AppTextStyles.displayMedium.copyWith(fontSize: 20),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                asset.kode,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.slate,
                                  fontFamily: 'Courier',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Badge Kondisi + Loan Status ───────────────────────────
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Badge(
                        label: asset.statusLabel.toUpperCase(),
                        color: asset.statusColor,
                      ),
                      _Badge(
                        label: asset.loanStatusLabel.toUpperCase(),
                        color: asset.loanStatusColor,
                      ),
                      _Badge(
                        label: asset.kategori.toUpperCase(),
                        color: AppColors.slate,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Info aktif peminjam jika sedang dipinjam ─────────────
                  if (asset.activeLoan != null)
                    _ActiveLoanBanner(activeLoan: asset.activeLoan!),

                  // ── Detail Grid ───────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        _DetailItem('Kondisi', asset.kondisi, Icons.verified_user_outlined),
                        const Divider(height: 24, color: AppColors.border),
                        _DetailItem('Lokasi', asset.lokasi, Icons.location_on_outlined),
                        if (asset.pemegang != null && asset.pemegang!.isNotEmpty) ...[
                          const Divider(height: 24, color: AppColors.border),
                          _DetailItem('Pemegang', asset.pemegang!, Icons.person_outline_rounded),
                        ],
                        if (asset.merek != null) ...[
                          const Divider(height: 24, color: AppColors.border),
                          _DetailItem('Merek', asset.merek!, Icons.branding_watermark_outlined),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Tombol Aksi (kontekstual) ─────────────────────────────
                  _buildActionButtons(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (asset.isAvailable) {
      // Aset bisa dipinjam — tampilkan tombol pinjam
      return Column(
        children: [
          AppButton.primary(
            label: 'Ajukan Peminjaman',
            icon: const Icon(Icons.assignment_add, size: 20, color: Colors.white),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoanRequestPage(asset: asset)),
              );
            },
          ),
          const SizedBox(height: 12),
          _ScanAnotherButton(onScanAnother: onScanAnother),
        ],
      );
    }

    if (asset.isPendingLoan) {
      // Sudah ada pengajuan yang menunggu
      return Column(
        children: [
          _InfoBanner(
            icon: Icons.hourglass_top_rounded,
            color: AppColors.warning,
            message: 'Aset ini sedang dalam proses pengajuan peminjaman oleh pengguna lain.',
          ),
          const SizedBox(height: 12),
          _ScanAnotherButton(onScanAnother: onScanAnother),
        ],
      );
    }

    if (asset.isActiveLoan) {
      // Sedang aktif dipinjam
      return Column(
        children: [
          _InfoBanner(
            icon: Icons.lock_clock_rounded,
            color: AppColors.error,
            message: 'Aset ini sedang dipinjam. Tidak dapat diajukan kembali.',
          ),
          const SizedBox(height: 12),
          _ScanAnotherButton(onScanAnother: onScanAnother),
        ],
      );
    }

    // Default — hanya scan lain
    return _ScanAnotherButton(onScanAnother: onScanAnother);
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ActiveLoanBanner extends StatelessWidget {
  final Map<String, dynamic> activeLoan;
  const _ActiveLoanBanner({required this.activeLoan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.person_pin_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dipinjam oleh: ${activeLoan['borrower'] ?? '-'}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (activeLoan['due_date'] != null)
                  Text(
                    'Kembali: ${activeLoan['due_date']}',
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.inkMute),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String message;
  const _InfoBanner({required this.icon, required this.color, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanAnotherButton extends StatelessWidget {
  final VoidCallback onScanAnother;
  const _ScanAnotherButton({required this.onScanAnother});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pop(context);
          onScanAnother();
        },
        icon: const Icon(Icons.qr_code_scanner_rounded),
        label: const Text('Scan Aset Lain'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.slate,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _DetailItem(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: AppColors.subtleShadow,
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 10,
                  color: AppColors.slate,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
