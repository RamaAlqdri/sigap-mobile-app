import 'package:flutter/material.dart';

import '../models/medicine.dart';
import '../widgets/sigap_scaffold.dart';

class MedicineDetailScreen extends StatelessWidget {
  const MedicineDetailScreen({super.key, required this.medicine});

  static const routeName = '/medicine-detail';

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    return SigapScaffold(
      appBar: AppBar(
        title: const Text('Detail Obat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 56,
                    backgroundImage: AssetImage(medicine.imagePath),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  medicine.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  'Deskripsi',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(medicine.description),
                const SizedBox(height: 16),
                Text(
                  'Aturan Pakai',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(medicine.usage),
                const SizedBox(height: 16),
                Text(
                  'Catatan',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Informasi ini bersifat dummy untuk prototipe SIGAP. Konsultasikan kembali dengan dokter sebelum mengonsumsi obat apa pun.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
