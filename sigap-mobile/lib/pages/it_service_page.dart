// lib/pages/it_service_page.dart
// Halaman Layanan IT — Form Pengajuan Tiket

import 'package:flutter/material.dart';
import '../widgets/tickets/ticket_form.dart';

class ItServicePage extends StatelessWidget {
  const ItServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layanan IT'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: TicketForm(),
      ),
    );
  }
}
