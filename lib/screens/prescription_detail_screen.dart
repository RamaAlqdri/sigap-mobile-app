import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../app_state.dart';
import '../models/consultation_session.dart';
import '../models/doctor.dart';
import '../widgets/sigap_app_bar.dart';
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
    final appState = AppStateScope.of(context);
    final Doctor? doctor = appState.doctors
        .cast<Doctor?>()
        .firstWhere((doc) => doc?.id == session.doctorId, orElse: () => null);
    final photoPath = doctor?.photoPath ?? AppState.defaultUserAvatarPath;

    return SigapScaffold(
      appBar: const SigapAppBar(title: 'Detail Resep'),
      applyContentPadding: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage(photoPath),
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
                          Text('Waktu konsultasi: ${session.formattedDate}'),
                        ],
                      ),
                    ),
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
                        backgroundImage: const AssetImage(
                          'assets/images/medicine_general.jpg',
                        ),
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
            if (session.doctorNotes != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Catatan Dokter',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(session.doctorNotes!),
                    ],
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
