import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models/consultation_session.dart';
import '../widgets/sigap_scaffold.dart';
import 'prescription_detail_screen.dart';

class ConsultationHistoryScreen extends StatelessWidget {
  const ConsultationHistoryScreen({super.key});

  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    final sessions = AppStateScope.of(context).consultationSessions;
    return SigapScaffold(
      appBar: AppBar(
        title: const Text('Keranjang Resep'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: sessions.isEmpty
            ? Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.medical_information_outlined, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada sesi konsultasi.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Mulai konsultasi dengan dokter pilihanmu dan resep akan tampil di sini.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : ListView.separated(
                itemBuilder: (context, index) =>
                    _SessionTile(session: sessions[index]),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: sessions.length,
              ),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.receipt_long),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.doctorName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text('Konsultasi • ${session.formattedDate}'),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  PrescriptionDetailScreen.routeName,
                  arguments: session,
                );
              },
              child: const Text('Detail'),
            ),
          ],
        ),
      ),
    );
  }
}
