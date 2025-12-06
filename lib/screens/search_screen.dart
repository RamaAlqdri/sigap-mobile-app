import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models/medicine.dart';
import '../widgets/sigap_app_bar.dart';
import '../widgets/sigap_scaffold.dart';
import 'medicine_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  late List<Medicine> _results;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _results = AppState.instance.filterMedicines('');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    final appState = AppStateScope.of(context);
    final filtered = appState.filterMedicines(query);
    appState
      ..recordSearchKeyword(query)
      ..recordMedicineResults(filtered);
    setState(() {
      _currentQuery = query;
      _results = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    return SigapScaffold(
      appBar: const SigapAppBar(title: 'Pencarian Obat'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'Ketik nama obat',
                        ),
                        onSubmitted: _performSearch,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => _performSearch(_controller.text),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        child: Text('Cari'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Statistik pencarian',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _StatChip(
                          label: 'Total pencarian',
                          value: '${appState.totalSearches}',
                        ),
                        _StatChip(
                          label: 'Riwayat pencarian',
                          value: appState.searchHistory.isEmpty
                              ? '-'
                              : appState.searchHistory.join(', '),
                        ),
                        _StatChip(
                          label: 'Obat terakhir dicari',
                          value: appState.searchedMedicines.isEmpty
                              ? '-'
                              : appState.searchedMedicines.join(', '),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _results.isEmpty
                      ? const Center(child: Text('Tidak ada obat ditemukan.'))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_currentQuery.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  'Hasil untuk "$_currentQuery"',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  final medicine = _results[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          AssetImage(medicine.imagePath),
                                    ),
                                    title: Text(medicine.name),
                                    subtitle: Text(
                                      medicine.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        MedicineDetailScreen.routeName,
                                        arguments: medicine,
                                      );
                                    },
                                    trailing: const Icon(Icons.chevron_right),
                                  );
                                },
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemCount: _results.length,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primary
            .withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[700]),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
