import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../app_state.dart';
import '../models/doctor.dart';
import '../widgets/sigap_app_bar.dart';
import '../widgets/sigap_scaffold.dart';
import 'change_password_screen.dart';
import 'device_management_screen.dart';
import 'login_screen.dart';
import 'medicine_detail_screen.dart';
import 'prescription_detail_screen.dart';
import 'profile_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const _pageTitles = ['Selamat datang di SIGAP', 'Obat', 'Resep', 'Profil'];
  static const _tabs = [
    _DoctorsTab(),
    _MedicinesTab(),
    _ResepTab(),
    _ProfileSettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return SigapScaffold(
      appBar: SigapAppBar(title: _pageTitles[_currentIndex]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _tabs[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information_outlined),
            label: 'Obat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Resep',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _DoctorsTab extends StatefulWidget {
  const _DoctorsTab();

  @override
  State<_DoctorsTab> createState() => _DoctorsTabState();
}

class _DoctorsTabState extends State<_DoctorsTab> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _consultDoctor(BuildContext context, Doctor doctor) async {
    final appState = AppStateScope.of(context);
    appState.createConsultationSession(doctor);
    final sanitizedNumber =
        doctor.whatsappNumber.replaceAll(RegExp('[^0-9]'), '');
    final message =
        'Halo Dr. ${doctor.name}, saya ingin konsultasi melalui SIGAP.';
    final messenger = ScaffoldMessenger.of(context);
    final url =
        'whatsapp://send?phone=$sanitizedNumber&text=${Uri.encodeComponent(message)}';

    final launched = await launchUrlString(url);
    if (!launched) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Gagal membuka WhatsApp. Pastikan aplikasi terpasang.'),
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Sesi konsultasi tersimpan di tab Resep.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctors = AppStateScope.of(context)
        .doctors
        .where(
          (doctor) =>
              doctor.name.toLowerCase().contains(_query.toLowerCase()) ||
              doctor.specialty.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    final specialties = {
      'Penyakit Dalam': Icons.favorite_outline,
      'Dokter Umum': Icons.local_hospital_outlined,
      'Anak': Icons.child_care_outlined,
      'Kulit dan Kelamin': Icons.spa_outlined,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat datang di SIGAP',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFCBF3BB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, ada rencana apa hari ini?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Yuk, mulai konsultasi hari ini. Kami siap melayani.',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/doctor_vector.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Cari nama dokter atau spesialisasi',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: specialties.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final entry = specialties.entries.elementAt(index);
              return ActionChip(
                avatar: Icon(entry.value, size: 18),
                label: Text(entry.key),
                onPressed: () => setState(() {
                  _controller.text = entry.key;
                  _query = entry.key;
                }),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Dokter Populer',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFFD56969),
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: doctors.isEmpty
              ? const Center(child: Text('Dokter tidak ditemukan.'))
              : ListView.separated(
                  itemCount: doctors.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x11000000),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(doctor.photoPath),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  doctor.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  doctor.specialty,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                          FilledButton(
                            onPressed: () => _consultDoctor(context, doctor),
                            child: const Text('Chat'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _MedicinesTab extends StatefulWidget {
  const _MedicinesTab();

  @override
  State<_MedicinesTab> createState() => _MedicinesTabState();
}

class _MedicinesTabState extends State<_MedicinesTab> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final medicines = appState.medicines.where((medicine) {
      final keywords = _query.trim().toLowerCase();
      if (keywords.isEmpty) {
        return true;
      }
      return medicine.name.toLowerCase().contains(keywords);
    }).toList();
    final searchHistory = appState.clickedMedicines;
    final suggestions = ['Vitamin', 'Antibiotik', 'Analgesik', 'Suplemen'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Cari obat',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => setState(() => _query = value),
          onSubmitted: (value) =>
              appState.recordSearchKeyword(value.trim()),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: suggestions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final label = suggestions[index];
              return ActionChip(
                avatar: const Icon(Icons.lightbulb_outline, size: 18),
                label: Text(label),
                onPressed: () {
                  setState(() {
                    _controller.text = label;
                    _query = label;
                  });
                  appState.recordSearchKeyword(label);
                },
              );
            },
          ),
        ),
        if (searchHistory.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Riwayat obat yang pernah dibuka: ${searchHistory.join(', ')}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 16),
        Expanded(
          child: medicines.isEmpty
              ? const Center(child: Text('Obat tidak ditemukan.'))
              : ListView.separated(
                  itemCount: medicines.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final medicine = medicines[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x11000000),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage(medicine.imagePath),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(medicine.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text(
                                  medicine.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
                              appState.recordMedicineClick(medicine);
                              Navigator.pushNamed(
                                context,
                                MedicineDetailScreen.routeName,
                                arguments: medicine,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ResepTab extends StatefulWidget {
  const _ResepTab();

  @override
  State<_ResepTab> createState() => _ResepTabState();
}

class _ResepTabState extends State<_ResepTab> {
  final _searchController = TextEditingController();
  String _query = '';
  DateTime? _selectedDate;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessions = AppStateScope.of(context).consultationSessions;
    final filtered = sessions.where((session) {
      final matchesQuery = session.doctorName
          .toLowerCase()
          .contains(_query.trim().toLowerCase());
      final matchesDate = _selectedDate == null
          ? true
          : session.date.year == _selectedDate!.year &&
              session.date.month == _selectedDate!.month &&
              session.date.day == _selectedDate!.day;
      return matchesQuery && matchesDate;
    }).toList();

    if (sessions.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada riwayat konsultasi.\nMulai dengan memilih dokter di tab Beranda.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Cari dokter/riwayat resep',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickDate(context),
              icon: const Icon(Icons.date_range),
              label: const Text('Filter tanggal'),
            ),
            const SizedBox(width: 8),
            if (_selectedDate != null)
              InputChip(
                label: Text(
                    '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                onDeleted: () => setState(() => _selectedDate = null),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('Tidak ada resep sesuai filter.'))
              : ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final session = filtered[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x11000000),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.receipt_long),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  session.doctorName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                                Text('Konsultasi - ${session.formattedDate}'),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                PrescriptionDetailScreen.routeName,
                                arguments: session,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ProfileSettingsTab extends StatelessWidget {
  const _ProfileSettingsTab();

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final user = appState.currentUser ?? appState.registeredUser;
    if (user == null) {
      return const Center(
        child: Text('Belum ada data pengguna. Silakan login.'),
      );
    }

    return ListView(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage(AppState.defaultUserAvatarPath),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(user.email),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _ProfileActionTile(
          icon: Icons.person_outline,
          title: 'Sunting Profil',
          subtitle: 'Perbarui data pribadi kamu',
          onTap: () => Navigator.pushNamed(
            context,
            ProfileEditScreen.routeName,
          ),
        ),
        _ProfileActionTile(
          icon: Icons.lock_outline,
          title: 'Kata Sandi',
          subtitle: 'Ganti kata sandi akunmu',
          onTap: () => Navigator.pushNamed(
            context,
            ChangePasswordScreen.routeName,
          ),
        ),
        _ProfileActionTile(
          icon: Icons.devices_other_outlined,
          title: 'Manajemen Perangkat',
          subtitle: 'Kelola perangkat yang pernah login',
          onTap: () => Navigator.pushNamed(
            context,
            DeviceManagementScreen.routeName,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              appState.logout();
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            },
            icon: const Icon(Icons.exit_to_app),
            label: const Text('Keluar dari Akun'),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
