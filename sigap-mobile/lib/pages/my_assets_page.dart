// lib/pages/my_assets_page.dart
// Halaman untuk menampilkan daftar aset yang dimiliki user beserta fitur generate QR Code

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/asset_model.dart';
import '../services/asset_service.dart';
import '../theme/app_colors.dart';
import '../widgets/common/app_skeletons.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/fade_in.dart';
import '../widgets/common/app_button.dart';

class MyAssetsPage extends StatefulWidget {
  const MyAssetsPage({super.key});

  @override
  State<MyAssetsPage> createState() => _MyAssetsPageState();
}

class _MyAssetsPageState extends State<MyAssetsPage> {
  List<AssetModel> _assets = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAssets();
  }

  Future<void> _fetchAssets() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final assets = await AssetService.getUserAssets();
      if (mounted) {
        setState(() {
          _assets = assets;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _showQrDialog(BuildContext context, AssetModel asset) {
    // Gunakan kode (bmn_number) untuk scan, atau ID jika kosong (format fallback Laravel: assets/{id}/scan)
    final qrData = asset.kode.isNotEmpty
        ? asset.kode
        : 'assets/${asset.id}/scan';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _QrCodeSheet(asset: asset, qrData: qrData),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: SafeArea(
          child: ListSectionSkeleton(
            title: 'Memuat Aset Saya...',
            itemCount: 5,
          ),
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Gagal memuat aset:\n$_errorMessage',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.inkMute),
              ),
              const SizedBox(height: 24),
              AppButton.primary(
                label: 'Coba Lagi',
                onTap: _fetchAssets,
                fullWidth: false,
              ),
            ],
          ),
        ),
      );
    }

    if (_assets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: EmptyState(
            icon: Icons.inventory_2_outlined,
            message: 'Tidak Ada Aset',
            subMessage: 'Belum ada aset yang dialokasikan kepada Anda.',
            actionLabel: 'Refresh',
            onAction: _fetchAssets,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchAssets,
      color: AppColors.primary,
      child: ListView.separated(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        itemCount: _assets.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final asset = _assets[index];
          return FadeIn(
            delay: Duration(milliseconds: 50 * index),
            child: _AssetCard(
              asset: asset,
              onTap: () => _showQrDialog(context, asset),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aset Saya')),
      body: _buildBody(),
    );
  }
}

class _AssetCard extends StatelessWidget {
  final AssetModel asset;
  final VoidCallback onTap;

  const _AssetCard({required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.slate.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.computer_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.nama.isEmpty ? 'Unknown Device' : asset.nama,
                    style: TextStyle(
                      color: AppColors.ink,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.qr_code_2_rounded,
                        size: 14,
                        color: AppColors.inkMute,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          asset.kode.isNotEmpty
                              ? asset.kode
                              : 'assets/${asset.id}/scan',
                          style: TextStyle(
                            color: AppColors.inkMute,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildBadge(asset.loanStatusLabel, asset.loanStatusColor),
                      _buildBadge(asset.statusLabel, asset.statusColor),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.qr_code_2_rounded, color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _QrCodeSheet extends StatelessWidget {
  final AssetModel asset;
  final String qrData;

  const _QrCodeSheet({required this.asset, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tunjukkan QR Code',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Minta peminjam untuk memindai (scan) QR Code ini melalui aplikasi mereka.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.inkMute, fontSize: 13),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.slate.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 220.0,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            asset.nama,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            asset.kode.isNotEmpty ? asset.kode : 'No. BMN Tidak Tersedia',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          AppButton.primary(
            label: 'Tutup',
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
