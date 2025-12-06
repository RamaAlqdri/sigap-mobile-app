import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/consultation_session.dart';
import '../widgets/sigap_scaffold.dart';

class PrescriptionDetailScreen extends StatelessWidget {
  const PrescriptionDetailScreen({super.key, required this.session});

  static const routeName = '/prescription-detail';

  final ConsultationSession session;

  Future<void> _shareViaWhatsApp(BuildContext context) async {
    final buffer = StringBuffer()
      ..writeln(
        'Resep konsultasi dengan ${session.doctorName} (${session.formattedDate})',
      );
    for (final item in session.items) {
      buffer.writeln('- ${item.medicineName}: ${item.instruction}');
    }
    final messenger = ScaffoldMessenger.of(context);
    final url =
        'whatsapp://send?text=${Uri.encodeComponent(buffer.toString())}';

    final launched = await launchUrlString(url);
    if (!launched) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Gagal membagikan via WhatsApp.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SigapScaffold(
      appBar: AppBar(
        title: const Text('Detail Resep'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.doctorName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text('Waktu konsultasi: ${session.formattedDate}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: session.items.length,
                  itemBuilder: (context, index) {
                    final item = session.items[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                        child: Text('${index + 1}'),
                      ),
                      title: Text(item.medicineName),
                      subtitle: Text(item.instruction),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(height: 1),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _shareViaWhatsApp(context),
                icon: const Icon(Icons.share),
                label: const Text('Bagikan via WhatsApp'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
