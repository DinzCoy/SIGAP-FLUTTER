import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/asset_model.dart';
import '../../pages/loan_request_page.dart';
import '../../pages/permanent_transfer_page.dart';
import '../../pages/it_service_page.dart';
import '../../services/asset_service.dart';
import '../common/app_snackbar.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Bottom sheet yang tampil setelah user scan QR aset.
/// Desain Premium Clean List UI.
class AssetDetailSheet extends StatefulWidget {
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
      backgroundColor: Colors.transparent,
      builder: (_) =>
          AssetDetailSheet(asset: asset, onScanAnother: onScanAnother),
    );
  }

  @override
  State<AssetDetailSheet> createState() => _AssetDetailSheetState();
}

class _AssetDetailSheetState extends State<AssetDetailSheet> {
  int? _userRoleId;
  late String _currentLokasi;

  @override
  void initState() {
    super.initState();
    _currentLokasi = widget.asset.lokasi;
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleId = prefs.getInt('user_role_id');
    if (mounted) {
      setState(() {
        _userRoleId = roleId;
      });
    }
  }

  Future<void> _showEditRoomDialog() async {
    List<Map<String, dynamic>> rooms = [];
    int? selectedRoomId;
    final textCtrl = TextEditingController();
    bool isLoadingRooms = true;
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: !isSaving,
      builder: (dialogCtx) {
        final dialogNavigator = Navigator.of(dialogCtx);
        return StatefulBuilder(
          builder: (context, setDialogState) {
            if (rooms.isEmpty && isLoadingRooms) {
              AssetService.getRooms().then((list) {
                setDialogState(() {
                  rooms = list;
                  isLoadingRooms = false;
                  final match = list.firstWhere(
                    (r) => r['name'].toString().toLowerCase() == _currentLokasi.toLowerCase(),
                    orElse: () => <String, dynamic>{},
                  );
                  if (match.isNotEmpty) {
                    selectedRoomId = match['id'] as int?;
                  }
                });
              }).catchError((e) {
                setDialogState(() {
                  isLoadingRooms = false;
                });
                if (!context.mounted) return;
                AppSnackbar.showError(context, title: 'Error', message: 'Gagal mengambil daftar ruangan: $e');
              });
            }

            return Dialog(
              backgroundColor: AppColors.canvas,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Edit Ruangan Aset', style: AppTextStyles.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      'Ubah lokasi ruangan untuk aset "${widget.asset.nama}"',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.slate),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: AppColors.hairline),
                    const SizedBox(height: 12),

                    Text('Pilih Ruangan yang Ada:', style: AppTextStyles.labelMedium),
                    const SizedBox(height: 8),
                    isLoadingRooms
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.canvasSoft,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.hairline),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: selectedRoomId,
                                hint: Text(
                                  'Pilih Ruangan...',
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.slate),
                                ),
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down_rounded, color: AppColors.inkMute),
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.ink),
                                dropdownColor: AppColors.canvas,
                                borderRadius: BorderRadius.circular(8),
                                items: [
                                  DropdownMenuItem<int>(
                                    value: null,
                                    child: Text(
                                      '-- Tidak Ada / Kosongkan --',
                                      style: TextStyle(color: AppColors.slate, fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  ...rooms.map((r) => DropdownMenuItem<int>(
                                        value: r['id'] as int,
                                        child: Text(r['name'].toString()),
                                      )),
                                ],
                                onChanged: isSaving
                                    ? null
                                    : (val) {
                                        setDialogState(() {
                                          selectedRoomId = val;
                                          if (val != null) {
                                            textCtrl.clear();
                                          }
                                        });
                                      },
                              ),
                            ),
                          ),
                    const SizedBox(height: 16),

                    Text('Atau Buat Ruangan Baru:', style: AppTextStyles.labelMedium),
                    const SizedBox(height: 8),
                    TextField(
                      controller: textCtrl,
                      enabled: !isSaving,
                      onChanged: (val) {
                        if (val.trim().isNotEmpty && selectedRoomId != null) {
                          setDialogState(() {
                            selectedRoomId = null;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Ketik nama ruangan baru...',
                        hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.slate),
                        filled: true,
                        fillColor: AppColors.canvasSoft,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.hairline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.hairline),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isSaving ? null : () => dialogNavigator.pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.hairline),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text('Batal', style: AppTextStyles.labelMedium),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isSaving
                                ? null
                                : () async {
                                    setDialogState(() => isSaving = true);
                                    try {
                                      final res = await AssetService.updateAssetRoom(
                                        widget.asset.id,
                                        roomId: selectedRoomId,
                                        newRoomName: textCtrl.text,
                                      );
                                      final updatedRoom = res['data']['room'] as String;

                                      setState(() {
                                        _currentLokasi = updatedRoom;
                                        widget.asset.lokasi = updatedRoom;
                                      });

                                      dialogNavigator.pop();
                                      if (!context.mounted) return;
                                      AppSnackbar.showSuccess(
                                        context,
                                        title: 'Berhasil',
                                        message: 'Ruangan berhasil diupdate menjadi "$updatedRoom"',
                                      );
                                    } catch (e) {
                                      setDialogState(() => isSaving = false);
                                      String errMsg = e.toString();
                                      if (errMsg.startsWith('Exception: ')) errMsg = errMsg.substring(11);
                                      if (!context.mounted) return;
                                      AppSnackbar.showError(context, title: 'Gagal', message: 'Gagal mengupdate ruangan: $errMsg');
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text('Simpan', style: AppTextStyles.labelMedium.copyWith(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.computer_rounded,
                    color: Color(0xFF5E4BFF),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.asset.nama,
                        style: AppTextStyles.displayMedium.copyWith(
                          fontSize: 22,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'NO. BMN: ${widget.asset.kode}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.slate,
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Badge(
                  label: widget.asset.statusLabel.toUpperCase(),
                  color: widget.asset.statusColor,
                ),
                _Badge(
                  label: widget.asset.loanStatusLabel.toUpperCase(),
                  color: widget.asset.loanStatusColor,
                ),
                _Badge(
                  label: (widget.asset.kode.trim().isNotEmpty && widget.asset.kode.trim() != '-') 
                      ? 'BMN TERDAFTAR' 
                      : 'BELUM ADA BMN',
                  color: (widget.asset.kode.trim().isNotEmpty && widget.asset.kode.trim() != '-') 
                      ? AppColors.success 
                      : AppColors.slate,
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (widget.asset.activeLoan != null)
              _ActiveLoanBanner(activeLoan: widget.asset.activeLoan!),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  _DetailItem(
                    label: 'Kondisi',
                    value: widget.asset.kondisi,
                    icon: Icons.verified_user_outlined,
                  ),
                  Divider(height: 24, color: AppColors.border),
                  _DetailItem(
                    label: 'Lokasi',
                    value: _currentLokasi,
                    icon: Icons.location_on_outlined,
                    trailing: _userRoleId == 2
                        ? InkWell(
                            onTap: _showEditRoomDialog,
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : null,
                  ),
                  Divider(height: 24, color: AppColors.border),
                  _DetailItem(
                    label: 'Pemegang/Peminjam',
                    value: widget.asset.pemegang?.isNotEmpty == true ? widget.asset.pemegang! : '-',
                    icon: Icons.person_outline_rounded,
                  ),
                  Divider(height: 24, color: AppColors.border),
                  _DetailItem(
                    label: 'Merek',
                    value: widget.asset.merek?.isNotEmpty == true ? widget.asset.merek! : '-',
                    icon: Icons.branding_watermark_outlined,
                  ),
                  Divider(height: 24, color: AppColors.border),
                  _DetailItem(
                    label: 'Tgl. Perolehan',
                    value: widget.asset.tanggalPerolehan?.isNotEmpty == true
                        ? widget.asset.tanggalPerolehan!
                        : '-',
                    icon: Icons.calendar_today_outlined,
                  ),
                  Divider(height: 24, color: AppColors.border),
                  _DetailItem(
                    label: 'Servis Terakhir',
                    value: 'Belum pernah diservis',
                    icon: Icons.build_circle_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    List<Widget> actions = [];

    if (widget.asset.isAvailable) {
      actions.add(
        _ActionButton(
          label: 'Pinjam Aset',
          icon: Icons.assignment_add,
          color: AppColors.primary,
          isFilled: true,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LoanRequestPage(asset: widget.asset),
              ),
            );
          },
        ),
      );
      actions.add(const SizedBox(height: 12));

      actions.add(
        _ActionButton(
          label: 'Ambil Permanen / Alokasi',
          icon: Icons.move_to_inbox_rounded,
          color: const Color(0xFF7C3AED),
          isFilled: true,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PermanentTransferPage(asset: widget.asset),
              ),
            );
          },
        ),
      );
      actions.add(const SizedBox(height: 12));
    } else if (widget.asset.isPendingLoan) {
      actions.add(
        _InfoBanner(
          icon: Icons.hourglass_top_rounded,
          color: AppColors.warning,
          message:
              'Aset ini sedang dalam proses pengajuan peminjaman oleh pengguna lain.',
        ),
      );
      actions.add(const SizedBox(height: 12));
    } else if (widget.asset.isActiveLoan) {
      actions.add(
        _InfoBanner(
          icon: Icons.lock_clock_rounded,
          color: AppColors.error,
          message: 'Aset ini sedang dipinjam. Tidak dapat diajukan kembali.',
        ),
      );
      actions.add(const SizedBox(height: 12));
    }

    actions.add(
      _ActionButton(
        label: 'Lapor Kendala / Kerusakan',
        icon: Icons.warning_amber_rounded,
        color: AppColors.warning,
        isFilled: false,
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ItServicePage(),
            ),
          );
        },
      ),
    );
    actions.add(const SizedBox(height: 12));

    actions.add(
      _ActionButton(
        label: 'Scan Aset Lain',
        icon: Icons.qr_code_scanner_rounded,
        color: AppColors.slate,
        isFilled: false,
        onTap: () {
          Navigator.pop(context);
          widget.onScanAnother();
        },
      ),
    );

    return Column(children: actions);
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E0FF)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_box_rounded,
            color: Color(0xFF5E4BFF),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dipinjam oleh: ${activeLoan['borrower'] ?? '-'}',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.ink,
                  ),
                ),
                if (activeLoan['due_date'] != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Kembali: ${activeLoan['due_date']}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.slate,
                    ),
                  ),
                ]
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
  const _InfoBanner({
    required this.icon,
    required this.color,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
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

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Widget? trailing;
  const _DetailItem({
    required this.label,
    required this.value,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF5E4BFF)),
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
        trailing ?? const SizedBox.shrink(),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isFilled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isFilled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: isFilled
          ? ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, color: Colors.white, size: 20),
              label: Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            )
          : OutlinedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, color: color, size: 20),
              label: Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(color: color),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color.withValues(alpha: 0.5), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
    );
  }
}
