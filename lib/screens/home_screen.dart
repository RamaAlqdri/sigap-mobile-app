import 'package:flutter/material.dart';

import '../app_state.dart';
import '../widgets/sigap_app_bar.dart';
import '../widgets/sigap_scaffold.dart';
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

    return SigapScaffold(
      appBar: const SigapAppBar(title: ''),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundImage:
                          AssetImage(AppState.defaultUserAvatarPath),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, $userName',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tetap siaga menjaga kesehatanmu dengan konsultasi online',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final crossAxisCount = width > 1100
                      ? 4
                      : width > 800
                          ? 3
                          : 2;
                  return GridView.builder(
                    itemCount: actions.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: width > 800 ? 1.1 : 0.95,
                    ),
                    itemBuilder: (context, index) {
                      final action = actions[index];
                      return _ActionCard(
                        action: action,
                        onTap: () => Navigator.pushNamed(
                          context,
                          action.routeName,
                        ),
                      );
                    },
                  );
                },
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
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  action.icon,
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                action.title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
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
