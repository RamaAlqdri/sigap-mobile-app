import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../app_state.dart';
import '../models/doctor.dart';
import '../models/user.dart';
import '../utils/validators.dart';
import '../widgets/sigap_app_bar.dart';
import '../widgets/sigap_scaffold.dart';
import 'medicine_detail_screen.dart';
import 'prescription_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const _pageTitles = ['Beranda', 'Obat', 'Resep', 'Profil'];
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
      children: [
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
    final medicines = AppStateScope.of(context)
        .medicines
        .where(
          (medicine) => medicine.name
              .toLowerCase()
              .contains(_query.trim().toLowerCase()),
        )
        .toList();

    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Cari obat',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: medicines.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final medicine = medicines[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(medicine.imagePath),
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ResepTab extends StatelessWidget {
  const _ResepTab();

  @override
  Widget build(BuildContext context) {
    final sessions = AppStateScope.of(context).consultationSessions;
    if (sessions.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada riwayat konsultasi.\nMulai dengan memilih dokter di tab Beranda.',
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.separated(
      itemCount: sessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Card(
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.receipt_long),
            ),
            title: Text(session.doctorName),
            subtitle: Text('Konsultasi • ${session.formattedDate}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(
                context,
                PrescriptionDetailScreen.routeName,
                arguments: session,
              );
            },
          ),
        );
      },
    );
  }
}

class _ProfileSettingsTab extends StatefulWidget {
  const _ProfileSettingsTab();

  @override
  State<_ProfileSettingsTab> createState() => _ProfileSettingsTabState();
}

class _ProfileSettingsTabState extends State<_ProfileSettingsTab> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  User? _lastUser;

  final List<Map<String, String>> _devices = const [
    {'name': 'Perangkat ini', 'lastLogin': 'Hari ini'},
    {'name': 'Perangkat lain', 'lastLogin': 'Kemarin'},
    {'name': 'Tablet keluarga', 'lastLogin': '3 hari lalu'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = AppStateScope.of(context);
    final user = appState.currentUser ?? appState.registeredUser;
    if (user != null && user != _lastUser) {
      _lastUser = user;
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
    }
  }

  void _saveProfile() {
    final appState = AppStateScope.of(context);
    final name = _nameController.text.trim();
    final emailError = Validators.validateEmail(_emailController.text);
    final phoneError = Validators.validatePhone(_phoneController.text);

    String? errorMessage;
    if (name.isEmpty) {
      errorMessage = 'Nama wajib diisi';
    } else if (emailError != null) {
      errorMessage = emailError;
    } else if (phoneError != null) {
      errorMessage = phoneError;
    }

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return;
    }

    appState.updateProfile(
      name: name,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui.')),
    );
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
        _ProfileActionCard(
          icon: Icons.person_outline,
          title: 'Sunting Profil',
          subtitle: 'Perbarui nama, email, dan nomor HP',
          child: Column(
            children: [
              _ProfileField(
                label: 'Nama',
                controller: _nameController,
                readOnly: false,
              ),
              _ProfileField(
                label: 'Email',
                controller: _emailController,
                readOnly: false,
              ),
              _ProfileField(
                label: 'Nomor HP',
                controller: _phoneController,
                readOnly: false,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Simpan Profil'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _ProfileActionCard(
          icon: Icons.lock_outline,
          title: 'Kata Sandi',
          subtitle: 'Ganti kata sandi akunmu',
          child: Column(
            children: [
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleChangePassword,
                  child: const Text('Simpan Kata Sandi'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _ProfileActionCard(
          icon: Icons.devices_other_outlined,
          title: 'Manajemen Perangkat',
          subtitle: 'Kelola perangkat yang pernah login',
          child: Column(
            children: _devices
                .map(
                  (device) => ListTile(
                    leading: const Icon(Icons.devices_outlined),
                    title: Text(device['name']!),
                    subtitle: Text('Login terakhir: ${device['lastLogin']}'),
                    trailing: const Icon(Icons.logout),
                    onTap: () => _handleDeviceTap(device['name']!),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _ProfileActionCard extends StatefulWidget {
  const _ProfileActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  State<_ProfileActionCard> createState() => _ProfileActionCardState();
}

class _ProfileActionCardState extends State<_ProfileActionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: Icon(widget.icon),
        title: Text(widget.title),
        subtitle: Text(widget.subtitle),
        initiallyExpanded: _expanded,
        onExpansionChanged: (value) => setState(() => _expanded = value),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.controller,
    required this.readOnly,
  });

  final String label;
  final TextEditingController controller;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
