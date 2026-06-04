import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_snackbar.dart';
import '../widgets/common/app_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nipController = TextEditingController();

  String _userId = '';
  String _currentPhotoUrl = '';
  File? _selectedPhoto;
  bool _removePhoto = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('user_id') ?? '';
      _nameController.text = prefs.getString('user_name') ?? '';
      _emailController.text = prefs.getString('user_email') ?? '';
      _phoneController.text = prefs.getString('user_phone') ?? '';
      _nipController.text = prefs.getString('user_nip') ?? '';
      _currentPhotoUrl = prefs.getString('user_photo_url') ?? '';
    });
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      final file = File(picked.path);
      final bytes = await file.length();
      if (bytes > 2 * 1024 * 1024) { // 2MB
        if (mounted) {
          AppSnackbar.showError(
            context,
            title: 'File Terlalu Besar',
            message: 'Ukuran foto melebihi batas maksimal 2 MB.',
          );
        }
        return;
      }
      setState(() {
        _selectedPhoto = file;
        _removePhoto = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.updateProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        nip: _nipController.text,
        fotoProfil: _selectedPhoto,
        hapusFoto: _removePhoto,
      );

      if (result is Map && result['status'] == 'success') {
        // Save back to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', _nameController.text);
        await prefs.setString('user_email', _emailController.text);
        await prefs.setString('user_phone', _phoneController.text);
        await prefs.setString('user_nip', _nipController.text);
        
        final newPhotoUrl = result['data']?['photo_url'] ?? '';
        await prefs.setString('user_photo_url', newPhotoUrl);

        if (mounted) {
          AppSnackbar.showSuccess(
            context,
            title: 'Berhasil',
            message: 'Profil Anda berhasil diperbarui.',
          );
          Navigator.pop(context, true); // return true to indicate success
        }
      } else {
        if (mounted) {
          AppSnackbar.showError(
            context,
            title: 'Gagal Memperbarui',
            message: result is String ? result : 'Terjadi kesalahan saat memperbarui profil.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(
          context,
          title: 'Kesalahan Sistem',
          message: e.toString(),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nipController.dispose();
    super.dispose();
  }

  Widget _buildPhotoEditor() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.border,
              backgroundImage: _selectedPhoto != null
                  ? FileImage(_selectedPhoto!) as ImageProvider
                  : (!_removePhoto && _currentPhotoUrl.isNotEmpty)
                      ? NetworkImage(_currentPhotoUrl)
                      : null,
              child: (_selectedPhoto == null && (_removePhoto || _currentPhotoUrl.isEmpty))
                  ? Icon(Icons.person_rounded, size: 50, color: AppColors.slate)
                  : null,
            ),
            GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const Icon(Icons.camera_alt_rounded, size: 18, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_selectedPhoto != null || (!_removePhoto && _currentPhotoUrl.isNotEmpty))
          TextButton(
            onPressed: () {
              setState(() {
                _selectedPhoto = null;
                _removePhoto = true;
              });
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Hapus Foto',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.error),
            ),
          ),
        const SizedBox(height: 4),
        Text(
          'Format: JPG, PNG, WEBP\nUkuran maksimal: 2 MB',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.slate, height: 1.4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: _userId.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPhotoEditor(),
                    const SizedBox(height: 32),
                    AppTextField(
                      label: "Nama Lengkap",
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person_rounded),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Nama Lengkap tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: "Email",
                      controller: _emailController,
                      prefixIcon: const Icon(Icons.email_rounded),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: "Nomor Telepon",
                      controller: _phoneController,
                      prefixIcon: const Icon(Icons.phone_rounded),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: "NIP / ID",
                      controller: _nipController,
                      prefixIcon: const Icon(Icons.badge_rounded),
                    ),
                    const SizedBox(height: 32),
                    AppButton.primary(
                      label: "Simpan Perubahan",
                      isLoading: _isLoading,
                      onTap: _saveProfile,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
