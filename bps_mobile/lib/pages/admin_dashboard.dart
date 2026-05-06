import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';
import 'profile_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Clean light gray background
      appBar: AppBar(
        backgroundColor: const Color(0xFF00558D), // Deep blue header
        title: Text(
          "SIGAP",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            // Wrapping in aspect ratio helps the circle container contain text nicely
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "BPS",
                style: GoogleFonts.inter(
                  color: const Color(0xFF00558D),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Color(0xFF00558D)),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Keluar',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _selectedIndex == 4
          ? const ProfilePage()
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dashboard Admin",
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              // Row 1: Quick Stats Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return Row(
                      children: [
                        Expanded(child: _buildStatCard(
                          title: "Total Perangkat",
                          count: "1,245",
                          subtitle: "+12 minggu ini",
                          subtitleColor: Colors.green,
                          icon: Icons.computer,
                          accentColor: const Color(0xFF00558D),
                        )),
                        const SizedBox(width: 16),
                        Expanded(child: _buildStatCard(
                          title: "Perangkat Baik",
                          count: "1,180",
                          subtitle: "Baik (94.7%)",
                          subtitleColor: Colors.grey.shade700,
                          icon: Icons.check_circle_outline,
                          accentColor: Colors.green,
                        )),
                        const SizedBox(width: 16),
                        Expanded(child: _buildStatCard(
                          title: "Perangkat Rusak",
                          count: "65",
                          subtitle: "Rusak Ringan/Berat (5.3%)",
                          subtitleColor: Colors.grey.shade700,
                          icon: Icons.warning_amber_rounded,
                          accentColor: Colors.orange,
                        )),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildStatCard(
                          title: "Total Perangkat",
                          count: "1,245",
                          subtitle: "+12 minggu ini",
                          subtitleColor: Colors.green,
                          icon: Icons.computer,
                          accentColor: const Color(0xFF00558D),
                        ),
                        const SizedBox(height: 16),
                        _buildStatCard(
                          title: "Perangkat Baik",
                          count: "1,180",
                          subtitle: "Baik (94.7%)",
                          subtitleColor: Colors.grey.shade700,
                          icon: Icons.check_circle_outline,
                          accentColor: Colors.green,
                        ),
                        const SizedBox(height: 16),
                        _buildStatCard(
                          title: "Perangkat Rusak",
                          count: "65",
                          subtitle: "Rusak Ringan/Berat (5.3%)",
                          subtitleColor: Colors.grey.shade700,
                          icon: Icons.warning_amber_rounded,
                          accentColor: Colors.orange,
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
              
              // Row 2: Chart & Repair List
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildDonutChart()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildRepairList()),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildDonutChart(),
                        const SizedBox(height: 16),
                        _buildRepairList(),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 24),

              // Row 3: Activity Log
              _buildActivityLog(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF00558D),
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.computer), label: "Aset"),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart), label: "Laporan"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "User"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required String subtitle,
    required Color subtitleColor,
    required IconData icon,
    required Color accentColor,
  }) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accentColor, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: subtitleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonutChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Status Perangkat Saat Ini",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
               // Suggestion: use fl_chart package for actual chart implementation
               // Currently using a placeholder circular container for donut chart UI
               Container(
                 width: 120,
                 height: 120,
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   border: Border.all(color: const Color(0xFF00558D), width: 12),
                 ),
                 child: Center(
                   child: Text(
                     "1,245\nTotal",
                     textAlign: TextAlign.center,
                     style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
                   ),
                 ),
               ),
               const SizedBox(width: 24),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     _buildLegendItem("Laptop", const Color(0xFF00558D)),
                     const SizedBox(height: 8),
                     _buildLegendItem("Desktop PC", Colors.blue.shade600),
                     const SizedBox(height: 8),
                     _buildLegendItem("Printer", Colors.orange),
                     const SizedBox(height: 8),
                     _buildLegendItem("Lainnya", Colors.grey.shade400),
                   ],
                 ),
               )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildRepairList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Laporan Kerusakan Terbaru",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildRepairItem(
                initials: "M. A.",
                icon: Icons.computer_outlined,
                title: "Laptop Macet",
                status: "Sedang Diperbaiki",
                statusColor: Colors.amber.shade800,
              ),
              const Divider(),
              _buildRepairItem(
                initials: "A. S.",
                icon: Icons.print_outlined,
                title: "Printer Mati Total",
                status: "Menunggu Teknisi",
                statusColor: Colors.red.shade600,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRepairItem({
    required String initials,
    required IconData icon,
    required String title,
    required String status,
    required Color statusColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Text(
          initials,
          style: GoogleFonts.inter(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      title: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          status,
          style: GoogleFonts.inter(
            color: statusColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityLog() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Log Aktivitas Terbaru",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildLogEntry("14:30 - Admin mengalokasikan Laptop BMN-001 ke Ruang Rapat."),
          const SizedBox(height: 12),
          _buildLogEntry("13:15 - Teknisi Budi menyelesaikan perbaikan Printer P-02."),
          const SizedBox(height: 12),
          _buildLogEntry("10:05 - User Siti melaporkan Desktop PC D-14 error system."),
        ],
      ),
    );
  }

  Widget _buildLogEntry(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6.0, right: 8.0),
          child: Icon(Icons.circle, size: 8, color: Color(0xFF00558D)),
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: Colors.black87,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
