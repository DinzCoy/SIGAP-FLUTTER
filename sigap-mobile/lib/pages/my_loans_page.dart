// lib/pages/my_loans_page.dart
// Halaman Daftar Peminjaman User

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/loan_model.dart';
import '../services/loan_service.dart';

class MyLoansPage extends StatefulWidget {
  const MyLoansPage({super.key});

  @override
  State<MyLoansPage> createState() => _MyLoansPageState();
}

class _MyLoansPageState extends State<MyLoansPage> {
  late Future<List<LoanModel>> _loansFuture;

  @override
  void initState() {
    super.initState();
    _fetchLoans();
  }

  void _fetchLoans() {
    setState(() {
      _loansFuture = LoanService.getMyLoans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00558D),
        foregroundColor: Colors.white,
        title: Text(
          'Riwayat Peminjaman',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<List<LoanModel>>(
        future: _loansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat data:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchLoans,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_turned_in_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat peminjaman.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
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
                return _buildLoanCard(loans[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoanCard(LoanModel loan) {
    final statusInfo = loan.statusInfo;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Color(statusInfo['bgColor']).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Color(statusInfo['color']).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  statusInfo['label'],
                  style: GoogleFonts.inter(
                    color: Color(statusInfo['color']),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              if (loan.jenis == 'permanen')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Mutasi Permanen',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.purple.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            loan.namaAset,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            loan.kodeAset,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF00558D),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    loan.isPinjam
                        ? '${_formatShortDate(loan.tanggalMulai)} s/d ${_formatShortDate(loan.tanggalKembali)}'
                        : 'Diajukan pada ${_formatShortDate(loan.createdAt)}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Keperluan:',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            loan.alasan,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.black87),
          ),

          if (loan.catatanAdmin != null && loan.catatanAdmin!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Text(
                'Catatan Admin: ${loan.catatanAdmin}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.red.shade800,
                ),
              ),
            ),
          ],

          if (loan.isAktif && loan.isPinjam) ...[
            const SizedBox(height: 16),
            const Divider(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _returnAsset(loan.id),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF00558D),
                  side: const BorderSide(color: Color(0xFF00558D)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Kembalikan Aset Sekarang'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _returnAsset(int loanId) async {
    // Tampilkan dialog konfirmasi kondisi aset
    String kondisi = 'Baik';
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Kembalikan Aset'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pilih kondisi aset saat dikembalikan:'),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  isExpanded: true,
                  value: kondisi,
                  items: ['Baik', 'Rusak Ringan', 'Rusak Berat']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => kondisi = v!),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00558D),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Proses Pengembalian'),
              ),
            ],
          );
        },
      ),
    );

    if (confirm == true) {
      try {
        await LoanService.returnAsset(loanId: loanId, kondisiKembali: kondisi);
        _fetchLoans();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aset berhasil dikembalikan'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  String _formatShortDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
