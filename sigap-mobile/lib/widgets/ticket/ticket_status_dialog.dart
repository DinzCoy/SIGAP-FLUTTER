// lib/widgets/ticket/ticket_status_dialog.dart
// Dialog untuk update status tiket oleh Admin

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/ticket_model.dart';
import '../../services/ticket_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class TicketStatusDialog extends StatefulWidget {
  final TicketModel ticket;
  const TicketStatusDialog({super.key, required this.ticket});

  @override
  State<TicketStatusDialog> createState() => _TicketStatusDialogState();
}

class _TicketStatusDialogState extends State<TicketStatusDialog> {
  late String _selectedStatus;
  final _tanggapanCtrl = TextEditingController();

  // Urutan alur status sesuai Ticket.php di Laravel
  static const List<Map<String, dynamic>> _statusOptions = [
    {
      'value': TicketModel.statusMenungguPengelola,
      'label': 'Menunggu Pengelola',
      'icon': Icons.hourglass_empty_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'value': TicketModel.statusKeKetuaTim,
      'label': 'Teruskan ke Ketua Tim',
      'icon': Icons.supervisor_account_rounded,
      'color': Color(0xFF7C3AED),
    },
    {
      'value': TicketModel.statusKeTeknisi,
      'label': 'Teruskan ke Teknisi',
      'icon': Icons.engineering_rounded,
      'color': Color(0xFF0891B2),
    },
    {
      'value': TicketModel.statusInProgress,
      'label': 'In Progress',
      'icon': Icons.autorenew_rounded,
      'color': Color(0xFF3B82F6),
    },
    {
      'value': TicketModel.statusMenungguBiaya,
      'label': 'Menunggu Persetujuan Biaya',
      'icon': Icons.attach_money_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'value': TicketModel.statusApproved,
      'label': 'Approved',
      'icon': Icons.verified_rounded,
      'color': Color(0xFF6366F1),
    },
    {
      'value': TicketModel.statusSelesai,
      'label': 'Selesai',
      'icon': Icons.check_circle_rounded,
      'color': Color(0xFF22C55E),
    },
    {
      'value': TicketModel.statusDibatalkan,
      'label': 'Batalkan Tiket',
      'icon': Icons.cancel_rounded,
      'color': Color(0xFFEF4444),
    },
  ];

  int? _userRoleId;
  List<Map<String, dynamic>> _technicians = [];
  int? _selectedTechnicianId;
  bool _isLoadingTech = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.ticket.status;
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleId = prefs.getInt('user_role_id');
    setState(() {
      _userRoleId = roleId;
    });

    if (roleId == 2 || roleId == 7) {
      _fetchTechnicians();
    }
  }

  Future<void> _fetchTechnicians() async {
    setState(() => _isLoadingTech = true);
    final list = await TicketService.getTechnicians();
    setState(() {
      _technicians = list;
      _isLoadingTech = false;

      if (widget.ticket.technicianId != null) {
        final hasTech = list.any((tech) => int.tryParse(tech['id'].toString()) == widget.ticket.technicianId);
        if (hasTech) {
          _selectedTechnicianId = widget.ticket.technicianId;
        }
      }
    });
  }

  List<Map<String, dynamic>> _getFilteredOptions() {
    if (_userRoleId == null) {
      // Selagi loading, tampilkan status aktif saat ini saja agar tidak kosong
      return _statusOptions.where((opt) => opt['value'] == widget.ticket.status).toList();
    }

    final int roleId = _userRoleId!;
    final List<String> allowedStatuses;

    if (roleId == 2) { // Admin
      allowedStatuses = [
        TicketModel.statusMenungguPengelola,
        TicketModel.statusKeKetuaTim,
        TicketModel.statusKeTeknisi,
        TicketModel.statusInProgress,
        TicketModel.statusMenungguBiaya,
        TicketModel.statusApproved,
        TicketModel.statusSelesai,
        TicketModel.statusDibatalkan,
      ];
    } else if (roleId == 4) { // Pengelola Barang
      allowedStatuses = [
        TicketModel.statusKeKetuaTim,
        TicketModel.statusMenungguBiaya,
        TicketModel.statusApproved,
        TicketModel.statusSelesai,
        TicketModel.statusDibatalkan,
      ];
    } else if (roleId == 7) { // Ketua Tim
      allowedStatuses = [
        TicketModel.statusKeTeknisi,
        TicketModel.statusSelesai,
        TicketModel.statusDibatalkan,
      ];
    } else if (roleId == 3) { // Teknisi
      allowedStatuses = [
        TicketModel.statusInProgress,
        TicketModel.statusMenungguBiaya,
        TicketModel.statusSelesai,
        TicketModel.statusDibatalkan,
      ];
    } else {
      // Role lain tidak berwenang mengupdate
      allowedStatuses = [];
    }

    // Pastikan status saat ini dari tiket selalu muncul sebagai opsi terpilih
    final filtered = _statusOptions.where((opt) {
      final val = opt['value'] as String;
      return allowedStatuses.contains(val) || val == widget.ticket.status;
    }).toList();

    return filtered;
  }

  @override
  void dispose() {
    _tanggapanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.canvas,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Judul dialog ────────────────────────────────────
            Text('Update Status Tiket', style: AppTextStyles.titleLarge),
            const SizedBox(height: 4),
            Text(
              '#${widget.ticket.id} — ${widget.ticket.judul}',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.slate),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16),
            Divider(color: AppColors.hairline),
            const SizedBox(height: 12),

            // ── Pilih status ─────────────────────────────────────
            Text('Pilih Status Baru:', style: AppTextStyles.labelMedium),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.35,
              ),
              child: Builder(
                builder: (context) {
                  final opts = _getFilteredOptions();
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: opts.length,
                    itemBuilder: (context, i) {
                      final opt = opts[i];
                      final isSelected = _selectedStatus == opt['value'];
                      final color = opt['color'] as Color;

                      return InkWell(
                        onTap: () => setState(() => _selectedStatus = opt['value'] as String),
                        borderRadius: BorderRadius.circular(8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? color.withAlpha(25) : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? color : AppColors.hairline,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(opt['icon'] as IconData, size: 18, color: color),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  opt['label'] as String,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: isSelected ? color : AppColors.ink,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(Icons.check_rounded, size: 18, color: color),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              ),
            ),
            const SizedBox(height: 12),

            // ── Opsi Pilih Teknisi (Jika status adalah "Diteruskan ke Teknisi" & role adalah Admin/Ketua Tim) ────────
            if (_selectedStatus == TicketModel.statusKeTeknisi && (_userRoleId == 2 || _userRoleId == 7)) ...[
              Text('Pilih Teknisi untuk Ditugaskan:', style: AppTextStyles.labelMedium),
              const SizedBox(height: 8),
              _isLoadingTech
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : _technicians.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Tidak ada teknisi aktif yang ditemukan.',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
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
                              value: _selectedTechnicianId,
                              hint: Text(
                                'Pilih Teknisi...',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.slate),
                              ),
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down_rounded, color: AppColors.inkMute),
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.ink),
                              dropdownColor: AppColors.canvas,
                              borderRadius: BorderRadius.circular(8),
                              items: _technicians.map((tech) {
                                return DropdownMenuItem<int>(
                                  value: int.tryParse(tech['id'].toString()),
                                  child: Text(tech['name'].toString()),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedTechnicianId = val;
                                });
                              },
                            ),
                          ),
                        ),
              if (_selectedTechnicianId == null) ...[
                const SizedBox(height: 4),
                Text(
                  '* Harap pilih teknisi sebelum menyimpan status ini.',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.error, fontSize: 11),
                ),
              ],
              const SizedBox(height: 16),
            ],

            // ── Tanggapan/Catatan ─────────────────────────────────
            Text('Tanggapan (opsional):', style: AppTextStyles.labelMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _tanggapanCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tulis catatan atau tanggapan...',
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
                contentPadding: const EdgeInsets.all(12),
              ),
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),

            // ── Tombol aksi ──────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
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
                    onPressed: (_selectedStatus == TicketModel.statusKeTeknisi && (_userRoleId == 2 || _userRoleId == 7) && _selectedTechnicianId == null)
                        ? null
                        : () {
                            final Map<String, dynamic> result = {
                              'status': _selectedStatus,
                              'tanggapan': _tanggapanCtrl.text,
                            };
                            if (_selectedStatus == TicketModel.statusKeTeknisi) {
                              result['technician_id'] = _selectedTechnicianId;
                            }
                            Navigator.pop(context, result);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.border,
                      disabledForegroundColor: AppColors.textHint,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Simpan', style: AppTextStyles.labelMedium.copyWith(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
