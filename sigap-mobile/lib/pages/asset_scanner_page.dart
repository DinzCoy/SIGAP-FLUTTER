// lib/pages/asset_scanner_page.dart
// Halaman Scanner QR/Barcode untuk Aset

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/asset_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common/app_snackbar.dart';
import '../widgets/scanner/scanner_overlay.dart';
import '../widgets/scanner/asset_detail_sheet.dart';
import 'register_asset_page.dart';
import 'loan_request_page.dart';
import 'permanent_transfer_page.dart';

class AssetScannerPage extends StatefulWidget {
  const AssetScannerPage({super.key});

  @override
  State<AssetScannerPage> createState() => _AssetScannerPageState();
}

class _AssetScannerPageState extends State<AssetScannerPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: [BarcodeFormat.all],
  );

  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resumeScanner() {
    if (mounted) setState(() => _isProcessing = false);
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty || barcodes.first.rawValue == null) return;

    final code = barcodes.first.rawValue!;
    setState(() => _isProcessing = true);

    try {
      final asset = await AssetService.scanAsset(code);
      if (!mounted) return;

      if (asset != null) {
        if (code.contains('mode=loan')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LoanRequestPage(asset: asset)),
          ).then((_) => _resumeScanner());
        } else if (code.contains('mode=transfer')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PermanentTransferPage(asset: asset)),
          ).then((_) => _resumeScanner());
        } else {
          await AssetDetailSheet.show(
            context,
            asset: asset,
            onScanAnother: _resumeScanner,
          );
          _resumeScanner();
        }
      } else {
        _showUnregisteredDialog(code);
      }
    } catch (e) {
      if (!mounted) return;
      String errMsg = e.toString();
      if (errMsg.startsWith('Exception: ')) errMsg = errMsg.substring(11);
      AppSnackbar.showError(context, title: 'Error', message: 'Terjadi kesalahan: $errMsg');
      _resumeScanner();
    }
  }

  void _showUnregisteredDialog(String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Aset Tidak Terdaftar', style: AppTextStyles.titleLarge),
        content: Text(
          'Kode aset "$code" belum terdaftar di sistem. Apakah Anda ingin mendaftarkannya sekarang?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resumeScanner();
            },
            child: Text(
              'Batal',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegisterAssetPage(initialCode: code),
                ),
              ).then((_) => _resumeScanner());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Daftarkan Aset', style: AppTextStyles.labelLarge),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(
          'Scan Aset',
          style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on_rounded, color: Colors.white),
            tooltip: 'Toggle Flashlight',
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch_rounded, color: Colors.white),
            tooltip: 'Switch Camera',
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          ScannerOverlay(isProcessing: _isProcessing),
        ],
      ),
    );
  }
}
