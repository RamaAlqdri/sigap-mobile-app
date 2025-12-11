import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../app_state.dart';
import '../models/consultation_session.dart';
import '../models/doctor.dart';
import '../models/facility.dart';
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
    final facilities = appState.getNearestFacilities(limit: 3);

    return SigapScaffold(
      appBar: const SigapAppBar(title: 'Detail Resep'),
      applyContentPadding: false,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          const SizedBox(height: 12),
          if (session.doctorNotes != null) ...[
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
          ],
          if (facilities.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rekomendasi Fasilitas Kesehatan Terdekat',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Jika keluhan masih berlanjut, Anda dapat mengunjungi fasilitas berikut:',
                    ),
                    const SizedBox(height: 12),
                    ...facilities.map(
                      (facility) => _FacilityRecommendationTile(
                        facility: facility,
                        distanceKm: appState.distanceToFacility(facility),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          // Card(
          //   child: Padding(
          //     padding: const EdgeInsets.all(16),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         const Text(
          //           'Masih bingung dengan resep ini? Hubungi admin.',
          //         ),
          //         const SizedBox(height: 12),
          //         SizedBox(
          //           width: double.infinity,
          //           child: OutlinedButton.icon(
          //             onPressed: () => appState.openAdminWhatsAppSupport(context),
          //             icon: const Icon(Icons.support_agent_outlined),
          //             label: const Text('Chat Admin SIGAP'),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
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
    );
  }
}

class _FacilityRecommendationTile extends StatelessWidget {
  const _FacilityRecommendationTile({
    required this.facility,
    required this.distanceKm,
  });

  final Facility facility;
  final double distanceKm;

  Future<void> _openMaps(BuildContext context) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${facility.latitude},${facility.longitude}';
    final launched = await launchUrlString(url);
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka Maps.')),
      );
    }
  }

  Future<void> _callFacility(BuildContext context) async {
    if (facility.phone == null || facility.phone!.isEmpty) {
      return;
    }
    final url = 'tel:${facility.phone}';
    final launched = await launchUrlString(url);
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memulai panggilan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            facility.name,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '${facility.type} • ${distanceKm.toStringAsFixed(1)} km dari lokasi Anda',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
          ),
          const SizedBox(height: 4),
          Text(
            facility.address,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(
                onPressed: () => _openMaps(context),
                child: const Text('Lihat di Maps'),
              ),
              if (facility.phone != null && facility.phone!.isNotEmpty)
                TextButton(
                  onPressed: () => _callFacility(context),
                  child: const Text('Telepon'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
