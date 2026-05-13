import 'package:flutter/material.dart';

import 'login_page.dart';
import 'profile_page.dart';

class TechnicianDashboardPage extends StatefulWidget {
  const TechnicianDashboardPage({super.key});

  @override
  State<TechnicianDashboardPage> createState() =>
      _TechnicianDashboardPageState();
}

class _TechnicianDashboardPageState extends State<TechnicianDashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SIGAP',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00558D),
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Text(
                  'BPS',
                  style: TextStyle(
                    color: Color(0xFF00558D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          PlatformHeaderAvatar(),
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
          : Container(
              color: Colors.grey[100],
              child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, top: 8.0),
                child: Text(
                  'Dashboard Teknisi',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF00558D),
                  ),
                ),
              ),

              // Row 1: Stat Cards
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Ditunggu',
                          5,
                          Colors.grey,
                          Icons.access_time_filled,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Proses',
                          2,
                          Colors.blue,
                          Icons.build,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Selesai',
                          8,
                          Colors.green,
                          Icons.check_circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Batal',
                          1,
                          Colors.red,
                          Icons.cancel,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Row 2: Prioritas & Timeline
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 800;
                  final Widget leftContent = _buildPrioritasCard();
                  final Widget rightContent = _buildTimelineCard();

                  return isMobile
                      ? Column(
                          children: [
                            leftContent,
                            const SizedBox(height: 24),
                            rightContent,
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: leftContent),
                            const SizedBox(width: 24),
                            Expanded(flex: 2, child: rightContent),
                          ],
                        );
                },
              ),
              const SizedBox(height: 24),

              // Row 3: Denah & Placeholder
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 800;
                  final Widget leftContent = _buildDenahCard();
                  final Widget rightContent = _buildInfoPlaceholderCard();

                  return isMobile
                      ? Column(
                          children: [
                            leftContent,
                            const SizedBox(height: 24),
                            rightContent,
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: leftContent),
                            const SizedBox(width: 24),
                            Expanded(child: rightContent),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Action for QR Code
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Membuka Scanner QR...')),
          );
        },
        backgroundColor: const Color(0xFF00558D),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan QR Perangkat'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF00558D),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.computer), label: 'Aset'),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'User'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritasCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Aktivitas Terakhir',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
              ],
            ),
            const SizedBox(),
            _buildTaskItem(
              priorityColor: Colors.red,
              initials: 'M.A.',
              title: 'Laptop Mati Total',
              subtitle: 'BMN-001 - Ruang Rapat 3A',
              icon: Icons.laptop_windows,
              timestamp: '14/04/2026 10:30',
            ),
            const Divider(),
            _buildTaskItem(
              priorityColor: Colors.amber,
              initials: 'S.T.',
              title: 'Internet Lambat',
              subtitle: 'Koneksi LAN Lt. 2 - Bagian Umum',
              icon: Icons.wifi_off,
              timestamp: '14/04/2026 09:15',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem({
    required Color priorityColor,
    required String initials,
    required String title,
    required String subtitle,
    required IconData icon,
    required String timestamp,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Color(0xFF00558D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(icon, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(color: Colors.grey[700], fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (timestamp.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alur Perbaikan Terakhir',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTimelineItem(
              'Selesai Diperbaiki',
              'Laptop PC Error System - BMN-001 - Ruang Rapat',
              '10:30 WIB, Hari ini',
              isLast: false,
            ),
            _buildTimelineItem(
              'Mulai Pengerjaan',
              'Laptop PC Error System - BMN-001 - Ruang Rapat',
              '09:00 WIB, Hari ini',
              isLast: false,
              isDone: true,
            ),
            _buildTimelineItem(
              'Tugas Diambil',
              'Laptop PC Error System - BMN-001 - Ruang Rapat',
              '08:45 WIB, Hari ini',
              isLast: true,
              isDone: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String desc,
    String time, {
    bool isLast = false,
    bool isDone = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? Colors.blue : const Color(0xFF00558D),
                border: isDone
                    ? Border.all(color: Colors.blue.shade200, width: 3)
                    : null,
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 50, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDenahCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cek Lokasi Perangkat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.map, size: 48, color: Colors.grey),
                    const SizedBox(height: 8),
                    const Text(
                      'Denah Kantor BPS',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(
                          label: const Text('Ruang Rapat 3A'),
                          backgroundColor: Colors.red.shade100,
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: const Text('Bagian Umum'),
                          backgroundColor: Colors.amber.shade100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPlaceholderCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Sistem',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              alignment: Alignment.center,
              child: const Text(
                'Tidak ada pemberitahuan baru.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlatformHeaderAvatar extends StatelessWidget {
  const PlatformHeaderAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person, color: Color(0xFF00558D)),
      ),
    );
  }
}
