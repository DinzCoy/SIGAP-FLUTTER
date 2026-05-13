// lib/pages/admin_loans_page.dart
// Halaman Admin untuk Mengelola Peminjaman dan Mutasi

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/loan_model.dart';
import '../services/loan_service.dart';

class AdminLoansPage extends StatefulWidget {
  const AdminLoansPage({super.key});

  @override
  State<AdminLoansPage> createState() => _AdminLoansPageState();
}

class _AdminLoansPageState extends State<AdminLoansPage> with SingleTickerProviderStateMixin {
  late Future<List<LoanModel>> _loansFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _fetchLoans();
      }
    });
    _fetchLoans();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchLoans() {
    setState(() {
      String? status;
      if (_tabController.index == 0) status = 'menunggu';
      if (_tabController.index == 1) status = 'disetujui'; // Atau aktif
      if (_tabController.index == 2) status = 'selesai'; // Termasuk ditolak/kembali
      
      _loansFuture = LoanService.getAllLoans(status: status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00558D),
        foregroundColor: Colors.white,
        title: Text('Kelola Peminjaman (Admin)', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Menunggu'),
            Tab(text: 'Aktif'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: FutureBuilder<List<LoanModel>>(
        future: _loansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('Tidak ada data.', style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade600)),
                ],
              ),
            );
          }

          final loans = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async => _fetchLoans(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: loans.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildAdminLoanCard(loans[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdminLoanCard(LoanModel loan) {
    final statusInfo = loan.statusInfo;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(statusInfo['bgColor']).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Color(statusInfo['color']).withValues(alpha: 0.3)),
                ),
                child: Text(
                  statusInfo['label'],
                  style: GoogleFonts.inter(color: Color(statusInfo['color']), fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
              Text('#${loan.id}', style: GoogleFonts.inter(color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(loan.namaUser ?? 'User ID: ${loan.userId}', style: GoogleFonts.inter(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(loan.jenis == 'permanen' ? Icons.transfer_within_a_station : Icons.calendar_today, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                '${loan.jenis == 'permanen' ? 'Mutasi' : 'Pinjam'}: ${loan.namaAset}',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Alasan: ${loan.alasan}', style: GoogleFonts.inter(fontSize: 13, color: Colors.black87)),
          
          if (loan.status == 'menunggu_persetujuan') ...[
            const SizedBox(height: 16),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _processLoan(loan, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Tolak'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _processLoan(loan, true),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    child: const Text('Setujui'),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Future<void> _processLoan(LoanModel loan, bool isApprove) async {
    final catatanCtrl = TextEditingController();
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isApprove ? 'Setujui Pengajuan?' : 'Tolak Pengajuan?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: catatanCtrl,
              decoration: const InputDecoration(
                labelText: 'Catatan Admin (Opsional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            )
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: isApprove ? Colors.green : Colors.red, foregroundColor: Colors.white),
            child: Text(isApprove ? 'Setujui' : 'Tolak'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await LoanService.approveLoan(
          loanId: loan.id,
          status: isApprove ? 'disetujui' : 'ditolak',
          catatan: catatanCtrl.text,
        );
        _fetchLoans();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil diproses'), backgroundColor: Colors.green));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red));
        }
      }
    }
  }
}
