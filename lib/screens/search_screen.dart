import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models/medicine.dart';

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
    appState.recordSearchKeyword(query);
    setState(() {
      _currentQuery = query;
      _results = appState.filterMedicines(query);
    });
  }

  void _handleMedicineTap(Medicine medicine) {
    final appState = AppStateScope.of(context);
    appState.recordClickedMedicine(medicine);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${medicine.name} ditambahkan ke riwayat klik.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian Obat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Ketik nama obat',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _performSearch,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _performSearch(_controller.text),
                  child: const Text('Cari'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Total pencarian: ${appState.totalSearches}'),
            const SizedBox(height: 8),
            Text(
              'Riwayat pencarian: ${appState.searchHistory.isEmpty ? '-' : appState.searchHistory.join(', ')}',
            ),
            const SizedBox(height: 8),
            Text(
              'Obat yang diklik: ${appState.clickedMedicines.isEmpty ? '-' : appState.clickedMedicines.join(', ')}',
            ),
            const SizedBox(height: 16),
            if (_currentQuery.isNotEmpty)
              Text(
                'Hasil untuk "$_currentQuery":',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            const SizedBox(height: 8),
            Expanded(
              child: _results.isEmpty
                  ? const Center(child: Text('Tidak ada obat ditemukan.'))
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        final medicine = _results[index];
                        return ListTile(
                          title: Text(medicine.name),
                          onTap: () => _handleMedicineTap(medicine),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        );
                      },
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemCount: _results.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
