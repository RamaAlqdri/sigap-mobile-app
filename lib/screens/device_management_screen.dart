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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _devices
            .map(
              (device) => Card(
                child: ListTile(
                  leading: const Icon(Icons.devices_outlined),
                  title: Text(device['name']!),
                  subtitle: Text('Login terakhir: ${device['lastLogin']}'),
                  trailing: const Icon(Icons.logout),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Simulasi logout dari ${device['name']}'),
                      ),
                    );
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
