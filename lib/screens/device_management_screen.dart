import 'package:flutter/material.dart';

import '../widgets/sigap_app_bar.dart';
import '../widgets/sigap_scaffold.dart';

class DeviceManagementScreen extends StatelessWidget {
  const DeviceManagementScreen({super.key});

  static const routeName = '/device-management';

  static const List<Map<String, String>> _devices = [
    {'name': 'Perangkat ini', 'lastLogin': 'Hari ini'},
    {'name': 'Perangkat lain', 'lastLogin': 'Kemarin'},
    {'name': 'Tablet keluarga', 'lastLogin': '3 hari lalu'},
  ];

  @override
  Widget build(BuildContext context) {
    return SigapScaffold(
      appBar: const SigapAppBar(title: 'Manajemen Perangkat'),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          final device = _devices[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Simulasi logout dari ${device['name']}'),
                    ),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.devices_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              device['name']!,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Login terakhir: ${device['lastLogin']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.logout,
                        color: Colors.redAccent.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
