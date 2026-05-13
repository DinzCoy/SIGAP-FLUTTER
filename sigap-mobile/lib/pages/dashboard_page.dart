import 'package:flutter/material.dart';
import 'login_page.dart';

class BaseDashboard extends StatelessWidget {
  final String role;
  
  const BaseDashboard({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard $role'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            tooltip: 'Keluar',
          ),
        ],
      ),
      body: _buildDashboardContent(context),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    switch (role) {
      case 'Pengelola Barang':
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nama Barang', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Alokasi', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('No Seri', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('No BMN', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Kondisi', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Ruangan', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('PC Desktop HP')),
                  DataCell(Text('Divisi IPDS')),
                  DataCell(Text('SN889234')),
                  DataCell(Text('BMN-001')),
                  DataCell(Text('Baik')),
                  DataCell(Text('Ruang Server')),
                ]),
              ],
            ),
          ),
        );

      case 'User':
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Aset Saya', 
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                      SizedBox(height: 12),
                      ListTile(
                        leading: Icon(Icons.laptop_mac),
                        title: Text('Laptop ASUS Zenbook'),
                        subtitle: Text('SN: ASUS-12345'),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lapor Kerusakan dipanggil.')),
                    );
                  },
                  icon: const Icon(Icons.report_problem),
                  label: const Text(
                    'Lapor Kerusakan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        );

      default:
        // Admin, Pimpinan, Teknisi, Pengelola Ruangan
        return Center(
          child: Text(
            'Selamat datang, $role!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
    }
  }
}
