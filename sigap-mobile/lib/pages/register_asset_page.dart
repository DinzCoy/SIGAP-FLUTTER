// lib/pages/register_asset_page.dart
// Halaman Registrasi Aset Baru (berdasarkan hasil scan)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/asset_service.dart';

class RegisterAssetPage extends StatefulWidget {
  final String initialCode;

  const RegisterAssetPage({super.key, required this.initialCode});

  @override
  State<RegisterAssetPage> createState() => _RegisterAssetPageState();
}

class _RegisterAssetPageState extends State<RegisterAssetPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _kodeCtrl;
  final _namaCtrl = TextEditingController();
  final _merekCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _nilaiCtrl = TextEditingController();
  final _lokasiCtrl = TextEditingController();

  String _kategori = 'Laptop';
  String _kondisi = 'Baik';

  bool _isLoading = false;

  final List<String> _kategoriList = [
    'Laptop',
    'Desktop PC',
    'Printer',
    'Server',
    'Proyektor',
    'Lainnya',
  ];
  final List<String> _kondisiList = ['Baik', 'Rusak Ringan', 'Rusak Berat'];

  @override
  void initState() {
    super.initState();
    _kodeCtrl = TextEditingController(text: widget.initialCode);
  }

  @override
  void dispose() {
    _kodeCtrl.dispose();
    _namaCtrl.dispose();
    _merekCtrl.dispose();
    _modelCtrl.dispose();
    _nilaiCtrl.dispose();
    _lokasiCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AssetService.registerAsset({
        'kode': _kodeCtrl.text.trim(),
        'nama': _namaCtrl.text.trim(),
        'kategori': _kategori,
        'kondisi': _kondisi,
        'merek': _merekCtrl.text.trim(),
        'model': _modelCtrl.text.trim(),
        'lokasi': _lokasiCtrl.text.trim(),
        'nilai_perolehan': _nilaiCtrl.text.trim().replaceAll(
          RegExp(r'[^0-9]'),
          '',
        ), // hanya angka
        'status': 'tersedia',
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Aset berhasil didaftarkan!'),
          backgroundColor: Colors.green.shade600,
        ),
      );
      Navigator.pop(context); // Kembali ke scanner
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mendaftar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00558D),
        foregroundColor: Colors.white,
        title: Text(
          'Daftarkan Aset',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF00558D)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Aset ini belum terdaftar. Silakan lengkapi data untuk memasukannya ke dalam sistem inventaris SIGAP.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF00558D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _sectionLabel('Kode Aset (QR/Barcode)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _kodeCtrl,
                readOnly: true, // Tidak bisa diubah karena hasil scan
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
                decoration: _inputDecoration(
                  icon: Icons.qr_code,
                ).copyWith(fillColor: Colors.grey.shade100),
              ),
              const SizedBox(height: 16),

              _sectionLabel('Nama Aset *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _namaCtrl,
                validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
                decoration: _inputDecoration(
                  icon: Icons.computer,
                  hint: 'Cth: Laptop Admin 1',
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('Kategori *'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: _kategori,
                          items: _kategoriList
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _kategori = v!),
                          decoration: _inputDecoration(icon: Icons.category),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('Kondisi *'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: _kondisi,
                          items: _kondisiList
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _kondisi = v!),
                          decoration: _inputDecoration(
                            icon: Icons.health_and_safety,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('Merek'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _merekCtrl,
                          decoration: _inputDecoration(
                            icon: Icons.branding_watermark,
                            hint: 'Cth: Asus',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('Model/Tipe'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _modelCtrl,
                          decoration: _inputDecoration(
                            icon: Icons.model_training,
                            hint: 'Cth: Zenbook',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _sectionLabel('Lokasi Penyimpanan *'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lokasiCtrl,
                validator: (v) => v!.isEmpty ? 'Lokasi wajib diisi' : null,
                decoration: _inputDecoration(
                  icon: Icons.location_on,
                  hint: 'Cth: Ruang Server / Gudang IT',
                ),
              ),
              const SizedBox(height: 16),

              _sectionLabel('Nilai Perolehan (Rp)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nilaiCtrl,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(
                  icon: Icons.attach_money,
                  hint: 'Cth: 15000000',
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _isLoading ? 'Menyimpan...' : 'Simpan Aset',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00558D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  InputDecoration _inputDecoration({required IconData icon, String? hint}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF00558D), size: 20),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00558D), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
