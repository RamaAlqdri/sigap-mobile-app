import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../app_state.dart';
import '../models/doctor.dart';
import '../widgets/sigap_app_bar.dart';
import '../widgets/sigap_scaffold.dart';

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({super.key});

  static const routeName = '/doctors';

  Future<void> _handleConsult(BuildContext context, Doctor doctor) async {
    final appState = AppStateScope.of(context);
    appState.createConsultationSession(doctor);

    final sanitizedNumber =
        doctor.whatsappNumber.replaceAll(RegExp('[^0-9]'), '');
    final message =
        'Halo Dr. ${doctor.name}, saya ingin konsultasi melalui SIGAP.';
    final messenger = ScaffoldMessenger.of(context);
    final url =
        'whatsapp://send?phone=$sanitizedNumber&text=${Uri.encodeComponent(message)}';

    final launched = await launchUrlString(url);
    if (!launched) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Gagal membuka WhatsApp. Pastikan aplikasi terpasang.'),
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Sesi konsultasi tersimpan di Keranjang Resep.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctors = AppStateScope.of(context).doctors;
    return SigapScaffold(
      appBar: const SigapAppBar(title: 'Daftar Dokter'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundImage: AssetImage(doctor.photoPath),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                doctor.specialty,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Konsultasi langsung via WhatsApp',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _handleConsult(context, doctor),
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text('Hubungi'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemCount: doctors.length,
      ),
    );
  }
}
