import 'package:flutter/material.dart';
import '../../services/asset_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

/// Form pendaftaran aset baru. Menerima kode awal dari hasil scan QR.
class RegisterAssetForm extends StatefulWidget {
  final String initialCode;

  const RegisterAssetForm({super.key, required this.initialCode});

  @override
  State<RegisterAssetForm> createState() => _RegisterAssetFormState();
}

class _RegisterAssetFormState extends State<RegisterAssetForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _kodeCtrl;
  final _namaCtrl   = TextEditingController();
  final _merekCtrl  = TextEditingController();
  final _modelCtrl  = TextEditingController();
  final _nilaiCtrl  = TextEditingController();
  final _lokasiCtrl = TextEditingController();

  String _kategori = 'Laptop';
  String _kondisi  = 'Baik';
  bool _isLoading  = false;

  static const _kategoriList = ['Laptop', 'Desktop PC', 'Printer', 'Server', 'Proyektor', 'Lainnya'];
  static const _kondisiList  = ['Baik', 'Rusak Ringan', 'Rusak Berat'];

  @override
  void initState() {
    super.initState();
    _kodeCtrl = TextEditingController(text: widget.initialCode);
  }

  @override
  void dispose() {
    for (final c in [_kodeCtrl, _namaCtrl, _merekCtrl, _modelCtrl, _nilaiCtrl, _lokasiCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await AssetService.registerAsset({
        'kode'            : _kodeCtrl.text.trim(),
        'nama'            : _namaCtrl.text.trim(),
        'kategori'        : _kategori,
        'kondisi'         : _kondisi,
        'merek'           : _merekCtrl.text.trim(),
        'model'           : _modelCtrl.text.trim(),
        'lokasi'          : _lokasiCtrl.text.trim(),
        'nilai_perolehan' : _nilaiCtrl.text.trim().replaceAll(RegExp(r'[^0-9]'), ''),
        'status'          : 'tersedia',
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Aset berhasil didaftarkan!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mendaftar: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _dropdown<T>(String label, T value, List<T> items, ValueChanged<T?> onChanged, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e.toString()))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Aset ini belum terdaftar. Silakan lengkapi data untuk memasukkannya ke dalam sistem inventaris SIGAP.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Kode (read-only)
          Text('Kode Aset (QR/Barcode)', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          AppTextField(
            label: '',
            hint: '',
            controller: _kodeCtrl,
            readOnly: true,
            prefixIcon: const Icon(Icons.qr_code, color: AppColors.primary, size: 20),
          ),
          const SizedBox(height: 16),

          AppTextField(
            label: 'Nama Aset *',
            hint: 'Cth: Laptop Admin 1',
            controller: _namaCtrl,
            prefixIcon: const Icon(Icons.computer, color: AppColors.primary, size: 20),
            validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
          ),
          const SizedBox(height: 16),

          // Kategori & Kondisi
          Row(
            children: [
              Expanded(child: _dropdown('Kategori *', _kategori, _kategoriList, (v) => setState(() => _kategori = v!), Icons.category)),
              const SizedBox(width: 16),
              Expanded(child: _dropdown('Kondisi *', _kondisi, _kondisiList, (v) => setState(() => _kondisi = v!), Icons.health_and_safety)),
            ],
          ),
          const SizedBox(height: 16),

          // Merek & Model
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Merek',
                  hint: 'Cth: Asus',
                  controller: _merekCtrl,
                  prefixIcon: const Icon(Icons.branding_watermark, color: AppColors.primary, size: 20),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  label: 'Model/Tipe',
                  hint: 'Cth: Zenbook',
                  controller: _modelCtrl,
                  prefixIcon: const Icon(Icons.model_training, color: AppColors.primary, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          AppTextField(
            label: 'Lokasi Penyimpanan *',
            hint: 'Cth: Ruang Server / Gudang IT',
            controller: _lokasiCtrl,
            prefixIcon: const Icon(Icons.location_on, color: AppColors.primary, size: 20),
            validator: (v) => v!.isEmpty ? 'Lokasi wajib diisi' : null,
          ),
          const SizedBox(height: 16),

          AppTextField(
            label: 'Nilai Perolehan (Rp)',
            hint: 'Cth: 15000000',
            controller: _nilaiCtrl,
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.attach_money, color: AppColors.primary, size: 20),
          ),
          const SizedBox(height: 32),

          AppButton.primary(
            label: 'Simpan Aset',
            icon: const Icon(Icons.save_rounded, size: 20, color: Colors.white),
            isLoading: _isLoading,
            onTap: _submit,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
