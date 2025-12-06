import 'package:flutter/material.dart';

import '../app_state.dart';
import 'consultation_history_screen.dart';
import 'doctor_list_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final userName = appState.currentUser?.name ?? 'Pengguna SIGAP';
    final actions = [
      _HomeAction(
        title: 'Dokter',
        description: 'Lihat daftar dokter dan konsultasi',
        icon: Icons.medical_services_outlined,
        routeName: DoctorListScreen.routeName,
      ),
      _HomeAction(
        title: 'Cari Obat',
        description: 'Temukan obat sesuai keluhanmu',
        icon: Icons.search,
        routeName: SearchScreen.routeName,
      ),
      _HomeAction(
        title: 'Keranjang Resep',
        description: 'Riwayat konsultasi dan resep',
        icon: Icons.history,
        routeName: ConsultationHistoryScreen.routeName,
      ),
      _HomeAction(
        title: 'Profil',
        description: 'Data pribadi pengguna',
        icon: Icons.person_outline,
        routeName: ProfileScreen.routeName,
      ),
      _HomeAction(
        title: 'Pengaturan',
        description: 'Kata sandi & perangkat',
        icon: Icons.settings_outlined,
        routeName: SettingsScreen.routeName,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGAP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage:
                      AssetImage(AppState.defaultUserAvatarPath),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, $userName',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      const Text('Pilih layanan yang kamu butuhkan'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: actions
                    .map(
                      (action) => _ActionCard(
                        action: action,
                        onTap: () => Navigator.pushNamed(
                          context,
                          action.routeName,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.action, required this.onTap});

  final _HomeAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, size: 36, color: Theme.of(context).primaryColor),
              const SizedBox(height: 12),
              Text(
                action.title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                action.description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeAction {
  const _HomeAction({
    required this.title,
    required this.description,
    required this.icon,
    required this.routeName,
  });

  final String title;
  final String description;
  final IconData icon;
  final String routeName;
}
