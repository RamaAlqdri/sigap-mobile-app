import 'package:flutter/material.dart';

import '../models/medicine.dart';
import '../widgets/sigap_app_bar.dart';
import '../widgets/sigap_scaffold.dart';

class MedicineDetailScreen extends StatelessWidget {
  const MedicineDetailScreen({super.key, required this.medicine});

  static const routeName = '/medicine-detail';

  final Medicine medicine;

  List<String> _deriveTags() {
    final lower = medicine.name.toLowerCase();
    final tags = <String>{};
    if (lower.contains('vitamin')) {
      tags.add('Suplemen');
    }
    if (lower.contains('para') || lower.contains('ibu')) {
      tags.add('Pereda nyeri');
    }
    if (lower.contains('cillin') || lower.contains('amox')) {
      tags.add('Antibiotik');
    }
    if (lower.contains('flu') || lower.contains('batuk')) {
      tags.add('Flu & Batuk');
    }
    if (lower.contains('zinc')) {
      tags.add('Mineral');
    }
    if (lower.contains('lambung') ||
        lower.contains('gerd') ||
        lower.contains('prazo')) {
      tags.add('Lambung');
    }
    if (tags.isEmpty) {
      tags.add('Kesehatan');
    }
    return tags.toList();
  }

  @override
  Widget build(BuildContext context) {
    final tags = _deriveTags();
    final theme = Theme.of(context);
    final List<String> tips = [
      'Konsumsi sesuai jadwal yang direkomendasikan dokter.',
      'Gunakan segelas air putih dan hindari melebihi dosis.',
      'Stop pemakaian dan konsultasikan kembali jika muncul efek samping.',
    ];

    return SigapScaffold(
      appBar: const SigapAppBar(title: 'Detail Obat'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF93BFC7), Color(0xFF74A2B7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset(
                          medicine.imagePath,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rekomendasi SIGAP',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              medicine.name,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: tags
                                  .map(
                                    (tag) => Chip(
                                      label: Text(tag),
                                      labelStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      backgroundColor: Colors.white.withAlpha(10),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule_outlined,
                            color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Ikuti petunjuk dosis sesuai informasi di bawah dan rekomendasi dokter.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _InfoSection(
              icon: Icons.info_outline,
              title: 'Deskripsi Singkat',
              content: medicine.description,
            ),
            const SizedBox(height: 16),
            _InfoSection(
              icon: Icons.medical_services_outlined,
              title: 'Aturan Pakai',
              content: medicine.usage,
              backgroundColor:
                  theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 16),
            _TipsCard(tips: tips),
            const SizedBox(height: 16),
            const _DisclaimerCard(
              message:
                  'Informasi ini hanya contoh untuk prototipe SIGAP. Selalu konsultasikan dengan dokter terpercaya sebelum mengonsumsi obat apa pun.',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.icon,
    required this.title,
    required this.content,
    this.backgroundColor,
  });

  final IconData icon;
  final String title;
  final String content;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.tips});

  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFEFB),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates_outlined,
                  color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Tips Penggunaan',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(tip)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFC27D)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_outlined, color: Color(0xFFDA8B00)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
