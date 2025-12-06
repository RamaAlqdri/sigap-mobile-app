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

  static const _pageTitles = ['', 'Obat', 'Resep', 'Profil'];
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
      body: _tabs[_currentIndex],
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: _currentIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: false,
                iconSize: 26,
                onTap: (index) => setState(() => _currentIndex = index),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home_rounded),
                    label: 'Beranda',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.medical_information_outlined),
                    activeIcon: Icon(Icons.medical_services_rounded),
                    label: 'Obat',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.receipt_long_outlined),
                    activeIcon: Icon(Icons.receipt_long_rounded),
                    label: 'Resep',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person_rounded),
                    label: 'Profil',
                  ),
                ],
              ),
            ),
          ),
        ),
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
  static const _doctorHighlights = [
    'Respon cepat',
    '5+ tahun pengalaman',
    'Rating tinggi',
    'Direkomendasikan 200+ pasien',
  ];
  static const double _searchHeaderHeight = 172;

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
    final theme = Theme.of(context);
    final appState = AppStateScope.of(context);
    final doctors = appState.doctors
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

    final slivers = <Widget>[
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang di SIGAP',
              style: theme.textTheme.headlineSmall?.copyWith(
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
                          style: theme.textTheme.titleMedium,
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
          ],
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: _StickyHeaderDelegate(
          minHeight: _searchHeaderHeight,
          maxHeight: _searchHeaderHeight,
          child: Container(
            color: const Color(0xFFECF4E8),
            child: SizedBox(
              height: _searchHeaderHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                ],
              ),
            ),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,12),
          child: Text(
            'Dokter Populer',
            style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFFD56969),
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
      ),
    ];

    if (doctors.isEmpty) {
      slivers.add(
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: Text('Dokter tidak ditemukan.')),
        ),
      );
    } else {
      slivers.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final doctor = doctors[index];
              final highlight =
                  _doctorHighlights[index % _doctorHighlights.length];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == doctors.length - 1 ? 28 : 16,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset(
                              doctor.photoPath,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        doctor.name,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFECF4E8),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        doctor.specialty,
                                        style: theme.textTheme.labelSmall,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.verified_outlined,
                                      color: theme.colorScheme.primary,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      highlight,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: const [
                                    Icon(Icons.schedule, size: 16),
                                    SizedBox(width: 6),
                                    Text('08.00 - 21.00 WIB'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  color: theme.colorScheme.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Konsultasi via WhatsApp',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          FilledButton.icon(
                            onPressed: () => _consultDoctor(context, doctor),
                            icon: const Icon(Icons.send_rounded),
                            label: const Text('Chat'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: doctors.length,
          ),
        ),
      );
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: slivers,
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
  static const _medicineHighlights = [
    'Best seller',
    'Favorit keluarga',
    'Tanpa resep',
    'Direkomendasikan dokter',
  ];

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
                    final highlight =
                        _medicineHighlights[index % _medicineHighlights.length];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          appState.recordMedicineClick(medicine);
                          Navigator.pushNamed(
                            context,
                            MedicineDetailScreen.routeName,
                            arguments: medicine,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.08),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 16,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.asset(
                                  medicine.imagePath,
                                  width: 68,
                                  height: 68,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            medicine.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFECF4E8),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            highlight,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      medicine.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_hospital_outlined,
                                          size: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Klik untuk lihat detail aturan pakai',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
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
  static const _resepBadges = [
    'Butuh kontrol ulang',
    'Tindak lanjut selesai',
    'Resep baru',
  ];

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
    final appState = AppStateScope.of(context);
    final sessions = appState.consultationSessions;
    final doctorPhotos = {
      for (final doctor in appState.doctors) doctor.id: doctor.photoPath
    };
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
                    final badge = _resepBadges[index % _resepBadges.length];
                    final photoPath = doctorPhotos[session.doctorId] ??
                        AppState.defaultUserAvatarPath;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.08),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundImage: AssetImage(photoPath),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            session.doctorName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFECF4E8),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            badge,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      session.formattedDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.medication_outlined,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${session.items.length} obat disarankan dalam sesi ini',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          if (session.doctorNotes != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              '"${session.doctorNotes!}"',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.12),
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  PrescriptionDetailScreen.routeName,
                                  arguments: session,
                                );
                              },
                              icon: const Icon(Icons.visibility_outlined),
                              label: const Text('Lihat detail'),
                            ),
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

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight ||
        child != oldDelegate.child;
  }
}
