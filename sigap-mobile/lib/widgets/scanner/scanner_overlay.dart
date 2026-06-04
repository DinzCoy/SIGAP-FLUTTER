import 'package:flutter/material.dart';
import '../../theme/app_text_styles.dart';

/// Overlay transparan di atas kamera scanner: kotak panduan + teks instruksi.
class ScannerOverlay extends StatelessWidget {
  final bool isProcessing;

  const ScannerOverlay({super.key, required this.isProcessing});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const SizedBox(),
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Text(
              'Arahkan kamera ke QR Code atau Barcode yang tertempel pada perangkat aset.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
