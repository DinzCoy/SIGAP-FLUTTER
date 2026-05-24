// lib/pages/search_page.dart
// Halaman Pencarian Global: Aset & Tiket

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/asset_model.dart';
import '../models/ticket_model.dart';
import '../services/asset_service.dart';
import '../services/ticket_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  String _userRole = 'User';

  List<AssetModel> _allAssets = [];
  List<TicketModel> _allTickets = [];

  List<AssetModel> _filteredAssets = [];
  List<TicketModel> _filteredTickets = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      _userRole = prefs.getString('user_role') ?? 'User';

      final role = _userRole.toLowerCase();
      if (role == 'admin' || role == 'super admin' || role == 'super_admin') {
        _allAssets = await AssetService.getAssets();
        final ticketData = await TicketService.getAllTickets(limit: 50);
        _allTickets = (ticketData['data'] as List).cast<TicketModel>();
      } else {
        _allAssets = await AssetService.getUserAssets();
        final ticketData = await TicketService.getMyTickets(limit: 50);
        _allTickets = (ticketData['data'] as List).cast<TicketModel>();
      }
    } catch (e) {
      debugPrint('Error loading search data: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    final lowerQuery = query.toLowerCase().trim();

    if (lowerQuery.isEmpty) {
      setState(() {
        _filteredAssets = [];
        _filteredTickets = [];
      });
      return;
    }

    setState(() {
      _filteredAssets = _allAssets.where((a) {
        return a.nama.toLowerCase().contains(lowerQuery) ||
            a.kode.toLowerCase().contains(lowerQuery) ||
            (a.merek?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();

      _filteredTickets = _allTickets.where((t) {
        return t.judul.toLowerCase().contains(lowerQuery) ||
            t.deskripsi.toLowerCase().contains(lowerQuery) ||
            '#${t.id}'.contains(lowerQuery);
      }).toList();
    });
  }

  bool get _hasResults => _filteredAssets.isNotEmpty || _filteredTickets.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(color: AppColors.ink, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Cari aset atau tiket...',
            hintStyle: TextStyle(color: AppColors.inkMute, fontSize: 16),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.inkMute),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : null,
          ),
          onChanged: (v) {
            setState(() {}); // Rebuild for suffixIcon
            _onSearchChanged(v);
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_searchController.text.trim().isEmpty) {
      return _buildEmptyPrompt(
        icon: Icons.search_rounded,
        message: 'Ketik untuk mulai mencari',
        sub: 'Cari berdasarkan nama aset, no. BMN, atau judul tiket',
      );
    }

    if (!_hasResults) {
      return _buildEmptyPrompt(
        icon: Icons.search_off_rounded,
        message: 'Tidak ditemukan',
        sub: 'Tidak ada aset atau tiket yang cocok dengan\n"${_searchController.text}"',
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        if (_filteredAssets.isNotEmpty) ...[
          _buildSectionHeader('Aset', Icons.inventory_2_outlined, _filteredAssets.length),
          const SizedBox(height: 8),
          ..._filteredAssets.map(_buildAssetItem),
          const SizedBox(height: 20),
        ],
        if (_filteredTickets.isNotEmpty) ...[
          _buildSectionHeader('Tiket', Icons.confirmation_number_outlined, _filteredTickets.length),
          const SizedBox(height: 8),
          ..._filteredTickets.map(_buildTicketItem),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildEmptyPrompt({required IconData icon, required String message, required String sub}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.primary.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 20),
            Text(message, style: AppTextStyles.titleMedium.copyWith(color: AppColors.ink)),
            const SizedBox(height: 8),
            Text(
              sub,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.inkMute),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(title, style: AppTextStyles.titleSmall.copyWith(color: AppColors.ink, fontWeight: FontWeight.w700)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildAssetItem(AssetModel asset) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.computer_rounded, color: AppColors.primary, size: 22),
        ),
        title: Text(
          asset.nama.isNotEmpty ? asset.nama : 'Unknown Device',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.ink),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          asset.kode.isNotEmpty ? asset.kode : 'Kode tidak tersedia',
          style: TextStyle(fontSize: 12, color: AppColors.inkMute),
        ),
        trailing: _buildStatusChip(asset.loanStatusLabel, asset.loanStatusColor),
      ),
    );
  }

  Widget _buildTicketItem(TicketModel ticket) {
    final info = ticket.statusInfo;
    final labelColor = Color(info['color'] as int);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.confirmation_number_outlined, color: Colors.orange, size: 22),
        ),
        title: Text(
          ticket.judul,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.ink),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '#${ticket.id} • ${ticket.jenis}',
          style: TextStyle(fontSize: 12, color: AppColors.inkMute),
        ),
        trailing: _buildStatusChip(info['label'] as String, labelColor),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
