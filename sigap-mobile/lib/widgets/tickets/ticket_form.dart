import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/ticket_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import 'ticket_header_banner.dart';
import 'ticket_jenis_grid.dart';
import 'ticket_foto_section.dart';

/// Form pengajuan tiket IT. Berisi semua logika submit dan state foto/jenis.
class TicketForm extends StatefulWidget {
  const TicketForm({super.key});

  @override
  State<TicketForm> createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {
  final _formKey     = GlobalKey<FormState>();
  final _judulCtrl   = TextEditingController();
  final _deskripsiCtrl = TextEditingController();

  String _selectedJenis = TicketJenisGrid.jenisLayanan.first;
  File?  _fotoFile;
  bool   _isLoading = false;

  @override
  void dispose() {
    _judulCtrl.dispose();
    _deskripsiCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await TicketFotoSection.pickImage(source);
    if (file != null) setState(() => _fotoFile = file);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await TicketService.createTicket(
        judul     : _judulCtrl.text.trim(),
        deskripsi : _deskripsiCtrl.text.trim(),
        jenis     : _selectedJenis,
        foto      : _fotoFile,
      );
      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal mengirim tiket: $e'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
            SizedBox(height: 16),
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(color: AppColors.successBg, shape: BoxShape.circle),
              child: Icon(Icons.check_circle_rounded, color: AppColors.success, size: 48),
            ),
            const SizedBox(height: 16),
            Text('Tiket Terkirim!', style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Laporan Anda telah diterima. Tim IT akan segera menindaklanjuti.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            AppButton.primary(
              label: 'Kembali ke Dashboard',
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
          const TicketHeaderBanner(),
          const SizedBox(height: 24),

          Text('Jenis Layanan *', style: AppTextStyles.titleSmall),
          const SizedBox(height: 10),
          TicketJenisGrid(
            selected: _selectedJenis,
            onSelected: (v) => setState(() => _selectedJenis = v),
          ),
          const SizedBox(height: 24),

          AppTextField(
            label: 'Judul Masalah *',
            hint: 'cth. Laptop tidak bisa menyala',
            controller: _judulCtrl,
            prefixIcon: const Icon(Icons.title_rounded),
            validator: (v) => v == null || v.trim().isEmpty ? 'Judul tidak boleh kosong' : null,
          ),
          const SizedBox(height: 16),

          AppTextField(
            label: 'Deskripsi Masalah *',
            hint: 'Jelaskan masalah secara detail...',
            controller: _deskripsiCtrl,
            prefixIcon: const Icon(Icons.description_rounded),
            maxLines: 5,
            validator: (v) => v == null || v.trim().length < 10
                ? 'Deskripsi minimal 10 karakter'
                : null,
          ),
          const SizedBox(height: 24),

          Text('Foto Masalah (Opsional)', style: AppTextStyles.titleSmall),
          const SizedBox(height: 8),
          TicketFotoSection(
            fotoFile : _fotoFile,
            onCamera : () => _pickImage(ImageSource.camera),
            onGallery: () => _pickImage(ImageSource.gallery),
            onRemove : () => setState(() => _fotoFile = null),
          ),
          const SizedBox(height: 32),

          AppButton.primary(
            label: 'Kirim Tiket Layanan IT',
            icon: const Icon(Icons.send_rounded, size: 20, color: Colors.white),
            isLoading: _isLoading,
            onTap: _submit,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
