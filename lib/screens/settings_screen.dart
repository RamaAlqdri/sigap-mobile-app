import 'package:flutter/material.dart';

import '../app_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final List<Map<String, String>> _devices = const [
    {'name': 'Perangkat ini', 'lastLogin': 'Hari ini'},
    {'name': 'Perangkat lain', 'lastLogin': 'Kemarin'},
    {'name': 'Tablet keluarga', 'lastLogin': '3 hari lalu'},
  ];

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi kata sandi baru tidak cocok.')),
      );
      return;
    }
    final appState = AppStateScope.of(context);
    final success = appState.changePassword(
      oldPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
    );
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi berhasil diubah.')),
      );
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi lama tidak sesuai.')),
      );
    }
  }

  void _handleDeviceTap(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Simulasi logout dari $name')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ganti Kata Sandi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _oldPasswordController,
              decoration: const InputDecoration(
                labelText: 'Kata sandi lama',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                labelText: 'Kata sandi baru',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi kata sandi baru',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _handleChangePassword,
              child: const Text('Simpan Kata Sandi'),
            ),
            const SizedBox(height: 32),
            Text(
              'Manajemen Perangkat',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ..._devices.map(
              (device) => Card(
                child: ListTile(
                  title: Text(device['name']!),
                  subtitle: Text('Login terakhir: ${device['lastLogin']}'),
                  trailing: const Icon(Icons.logout),
                  onTap: () => _handleDeviceTap(device['name']!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
