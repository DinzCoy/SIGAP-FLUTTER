// lib/pages/maintenance_history_page.dart
// Halaman Riwayat Maintenance — untuk Teknisi melihat semua pekerjaan yang sudah selesai

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/ticket_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/common/fade_in.dart';

class MaintenanceHistoryPage extends StatefulWidget {
  /// Jika true, halaman ini dirender tanpa AppBar (embedded dalam tab).
  final bool embeddedMode;

  const MaintenanceHistoryPage({super.key, this.embeddedMode = false});

  @override
  State<MaintenanceHistoryPage> createState() => _MaintenanceHistoryPageState();
}

class _MaintenanceHistoryPageState extends State<MaintenanceHistoryPage> {
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMsg;
  int _page = 1;
  int _lastPage = 1;
  int _total = 0;
  bool _isKetuaTim = false; // dari response backend

  String? _selectedBulan; // format YYYY-MM
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetch(reset: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _page < _lastPage) {
      _fetchMore();
    }
  }

  Future<void> _fetch({bool reset = false}) async {
    if (reset) {
      setState(() {
        _page = 1;
        _items = [];
        _isLoading = true;
        _errorMsg = null;
      });
    }
    try {
      final result = await TicketService.getMaintenanceHistory(
        page: 1,
        limit: 20,
        bulan: _selectedBulan,
      );
      if (mounted) {
        final list = (result['data'] as List).cast<Map<String, dynamic>>();
        setState(() {
          _items      = list;
          _total      = result['total'] ?? list.length;
          _lastPage   = result['last_page'] ?? 1;
          _isKetuaTim = result['is_ketua_tim'] == true;
          _page       = 1;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _errorMsg = 'Gagal memuat: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchMore() async {
    if (_isLoadingMore || _page >= _lastPage) return;
    setState(() => _isLoadingMore = true);
    try {
      final result = await TicketService.getMaintenanceHistory(
        page: _page + 1,
        limit: 20,
        bulan: _selectedBulan,
      );
      if (mounted) {
        final more = (result['data'] as List).cast<Map<String, dynamic>>();
        setState(() {
          _items.addAll(more);
          _page++;
          _lastPage = result['last_page'] ?? _lastPage;
        });
      }
    } catch (_) {}
    finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _pickBulan() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'Pilih Bulan',
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() => _selectedBulan = DateFormat('yyyy-MM').format(picked));
      _fetch(reset: true);
    }
  }

  void _clearBulan() {
    setState(() => _selectedBulan = null);
    _fetch(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        // ── Filter Bar ───────────────────────────────────────────────────────
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.history_rounded, size: 18, color: AppColors.inkMute),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _isLoading ? 'Memuat...' : '$_total pekerjaan selesai',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ),
              // Filter bulan
              GestureDetector(
                onTap: _pickBulan,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _selectedBulan != null ? AppColors.primary : AppColors.canvasSoft,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedBulan != null ? AppColors.primary : AppColors.hairline,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 14,
                        color: _selectedBulan != null ? Colors.white : AppColors.inkMute,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _selectedBulan != null
                            ? _formatBulan(_selectedBulan!)
                            : 'Filter Bulan',
                        style: AppTextStyles.caption.copyWith(
                          color: _selectedBulan != null ? Colors.white : AppColors.inkMute,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_selectedBulan != null) ...[
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: _clearBulan,
                          child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(height: 1, color: AppColors.hairline),

        // ── Content ──────────────────────────────────────────────────────────
        Expanded(child: _buildContent()),
      ],
    );

    if (widget.embeddedMode) return body;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text('Riwayat Maintenance', style: AppTextStyles.titleMedium),
        centerTitle: true,
      ),
      body: body,
    );
  }

  Widget _buildContent() {
    if (_isLoading) return _buildSkeleton();
    if (_errorMsg != null) return _buildError();
    if (_items.isEmpty) return _buildEmpty();
    return _buildTimeline();
  }

  Widget _buildTimeline() {
    return RefreshIndicator(
      onRefresh: () => _fetch(reset: true),
      color: AppColors.primary,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _items.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (ctx, i) {
          if (i == _items.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          return FadeIn(
            delay: Duration(milliseconds: 50 * (i % 10)),
            child: _MaintenanceCard(
              item: _items[i],
              index: i,
              isKetuaTim: _isKetuaTim,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, _) => const _MaintenanceCardSkeleton(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_rounded, size: 56, color: AppColors.inkMute.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(_errorMsg!, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          TextButton.icon(onPressed: () => _fetch(reset: true), icon: const Icon(Icons.refresh_rounded), label: const Text('Coba Lagi')),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.build_circle_outlined, size: 72, color: AppColors.primary.withValues(alpha: 0.25)),
          const SizedBox(height: 16),
          Text(
            _selectedBulan != null ? 'Tidak ada riwayat di bulan ini' : 'Belum ada riwayat maintenance',
            style: AppTextStyles.titleSmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Pekerjaan yang selesai dikerjakan akan muncul di sini.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  String _formatBulan(String ym) {
    try {
      final dt = DateFormat('yyyy-MM').parse(ym);
      return DateFormat('MMM yyyy', 'id_ID').format(dt);
    } catch (_) {
      return ym;
    }
  }
}

// ─── Card Maintenance ─────────────────────────────────────────────────────────

class _MaintenanceCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;
  final bool isKetuaTim; // Ketua Tim melihat semua pekerjaan tim

  const _MaintenanceCard({
    required this.item,
    required this.index,
    this.isKetuaTim = false,
  });

  @override
  Widget build(BuildContext context) {
    final selesai = item['selesai_pada'] != null
        ? DateFormat('d MMM yyyy', 'id_ID').format(DateTime.parse(item['selesai_pada']))
        : '-';
    final dibuat = item['dibuat_pada'] != null
        ? DateFormat('d MMM yyyy', 'id_ID').format(DateTime.parse(item['dibuat_pada']))
        : '-';

    final String kategori = item['kategori'] ?? item['tipe'] ?? '-';
    final bool isService   = kategori.toLowerCase() == 'service';
    // Tiket yang dikerjakan anggota tim (bukan oleh si Ketua sendiri)
    final bool isDelegated = isKetuaTim && (item['is_delegated'] == true);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
        border: Border.all(
          color: isDelegated ? AppColors.primary.withValues(alpha: 0.25) : AppColors.hairline,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header Row ─────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ikon kategori
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isService ? AppColors.errorBg : AppColors.infoBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isService ? Icons.build_rounded : Icons.search_rounded,
                    color: isService ? AppColors.error : AppColors.info,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['judul'] ?? 'Tanpa Judul',
                        style: AppTextStyles.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '#${item['id']} · $kategori',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                // Badge status + delegasi
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.successBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Selesai',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Tampilkan badge "Tim" jika Ketua Tim melihat pekerjaan anggota
                    if (isDelegated) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.group_outlined, size: 11, color: AppColors.primary),
                            const SizedBox(width: 3),
                            Text(
                              'Tim',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            // ── Divider ────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.hairline, height: 1),
            ),

            // ── Meta Info ──────────────────────────────────────────────────
            _MetaRow(icon: Icons.devices_outlined, label: item['nama_aset'] ?? 'Aset tidak diketahui'),
            if (item['lokasi'] != null) ...[
              const SizedBox(height: 6),
              _MetaRow(icon: Icons.location_on_outlined, label: item['lokasi']),
            ],
            if (item['pelapor'] != null) ...[
              const SizedBox(height: 6),
              _MetaRow(icon: Icons.person_outline_rounded, label: 'Pelapor: ${item['pelapor']}'),
            ],
            // Tampilkan nama teknisi yang mengerjakan (penting untuk Ketua Tim)
            if (item['teknisi'] != null) ...[
              const SizedBox(height: 6),
              _MetaRow(
                icon: Icons.engineering_outlined,
                label: isDelegated
                    ? 'Teknisi: ${item['teknisi']}'
                    : 'Dikerjakan: ${item['teknisi']}',
              ),
            ],

            const SizedBox(height: 10),

            // ── Date Row ───────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _DateChip(label: 'Dibuat', value: dibuat, color: AppColors.inkMute),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DateChip(label: 'Selesai', value: selesai, color: AppColors.success),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.inkMute),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _DateChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.canvasSoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textHint)),
          const SizedBox(height: 2),
          Text(value, style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── Skeleton ─────────────────────────────────────────────────────────────────

class _MaintenanceCardSkeleton extends StatelessWidget {
  const _MaintenanceCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.hairline, borderRadius: BorderRadius.circular(12))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 160, decoration: BoxDecoration(color: AppColors.hairline, borderRadius: BorderRadius.circular(6))),
                    const SizedBox(height: 6),
                    Container(height: 10, width: 80, decoration: BoxDecoration(color: AppColors.hairline, borderRadius: BorderRadius.circular(6))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: AppColors.hairline),
          const SizedBox(height: 12),
          Container(height: 10, width: 180, decoration: BoxDecoration(color: AppColors.hairline, borderRadius: BorderRadius.circular(6))),
          const SizedBox(height: 8),
          Container(height: 10, width: 120, decoration: BoxDecoration(color: AppColors.hairline, borderRadius: BorderRadius.circular(6))),
        ],
      ),
    );
  }
}
