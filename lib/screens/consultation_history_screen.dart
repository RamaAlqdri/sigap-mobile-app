import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models/consultation_session.dart';
import 'prescription_detail_screen.dart';

class ConsultationHistoryScreen extends StatelessWidget {
  const ConsultationHistoryScreen({super.key});

  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    final sessions = AppStateScope.of(context).consultationSessions;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Resep'),
      ),
      body: sessions.isEmpty
          ? const Center(
              child: Text('Belum ada sesi konsultasi.'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) =>
                  _SessionTile(session: sessions[index]),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: sessions.length,
            ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final ConsultationSession session;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Konsultasi • ${session.formattedDate}'),
        subtitle: Text(session.doctorName),
        trailing: Text('${session.items.length} obat'),
        onTap: () {
          Navigator.pushNamed(
            context,
            PrescriptionDetailScreen.routeName,
            arguments: session,
          );
        },
      ),
    );
  }
}
