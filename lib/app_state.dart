import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'models/consultation_session.dart';
import 'models/doctor.dart';
import 'models/facility.dart';
import 'models/medicine.dart';
import 'models/prescription_item.dart';
import 'models/user.dart';

class AppState extends ChangeNotifier {
  static const String defaultUserAvatarPath = 'assets/images/user_default.png';

  AppState._internal() {
    facilities = const [
      Facility(
        id: 'f1',
        name: 'RSUP H. Adam Malik',
        type: 'Rumah Sakit',
        latitude: 3.5182212,
        longitude: 98.6085392,
        address: 'Jl. Bunga Lau No.17, Medan Tuntungan',
        phone: '+62618360143',
      ),
      Facility(
        id: 'f2',
        name: 'RSU Royal Prima',
        type: 'Rumah Sakit',
        latitude: 3.5978716,
        longitude: 98.6543127,
        address: 'Jl. Ayahanda No.68A, Medan Petisah',
        phone: '+626188813182',
      ),
      Facility(
        id: 'f3',
        name: 'RS Columbia Asia Medan',
        type: 'Rumah Sakit',
        latitude: 3.5859628,
        longitude: 98.6768861,
        address: 'Jl. Listrik No.2A, Medan Petisah',
        phone: '+62614566368',
      ),
      Facility(
        id: 'f4',
        name: 'RSU Bunda Thamrin',
        type: 'Rumah Sakit',
        latitude: 3.5853658,
        longitude: 98.6506539,
        address: 'Jl. Sei Batanghari No.28-34, Medan Sunggal',
        phone: '+62614557318',
      ),
      Facility(
        id: 'f5',
        name: 'Puskesmas Padang Bulan',
        type: 'Puskesmas',
        latitude: 3.5604273,
        longitude: 98.6623181,
        address: 'Jl. Jamin Ginting No.31, Medan Baru',
        phone: '+62618223282',
      ),
    ];

    doctors = [
      const Doctor(
        id: 'd1',
        name: 'dr. Agebrina Satolom, Sp.OG',
        specialty: 'Kandungan dan Kebidanan',
        whatsappNumber: '+6282273421481',
        photoPath: 'assets/images/doctor4.jpeg',
      ),
      const Doctor(
        id: 'd2',
        name: 'dr. Adhitya Indrapraja, Sp.OG',
        specialty: 'Kandungan dan Kebidanan',
        whatsappNumber: '+628111222333',
        photoPath: 'assets/images/doctor1.jpeg',
      ),
      const Doctor(
        id: 'd3',
        name: 'dr. Adrian Setiawan, Sp.OG',
        specialty: 'Kandungan dan Kebidanan',
        whatsappNumber: '+6281234567890',
        photoPath: 'assets/images/doctor2.png',
      ),
      const Doctor(
        id: 'd4',
        name: 'dr. Adnan Abadi, Sp.OG-KFER',
        specialty: 'Kandungan dan Kebidanan',
        whatsappNumber: '+628987654321',
        photoPath: 'assets/images/doctor3.png',
      ),
      const Doctor(
        id: 'd5',
        name: 'dr. Agnes Imelda Imanuel, Sp.OG',
        specialty: 'Kandungan dan Kebidanan',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor5.png',
      ),
      const Doctor(
        id: 'd6',
        name: 'dr. Afaf Susilawati , Sp. A, Subsp. Neo (K)',
        specialty: 'Anak',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor6.png',
      ),
      const Doctor(
        id: 'd7',
        name: 'dr. Adi Suryanto Budhipramono, Sp.A',
        specialty: 'Anak',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor7.png',
      ),
      const Doctor(
        id: 'd8',
        name: 'Dr. Agustina Santi Sp.A, M.Sc, IBCLC',
        specialty: 'Anak',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor8.png',
      ),
      const Doctor(
        id: 'd9',
        name: 'dr. Andy Japutra, Sp.A',
        specialty: 'Anak',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor9.png',
      ),
      const Doctor(
        id: 'd10',
        name: 'dr. Alexander Leonard C.J, Sp.A',
        specialty: 'Anak',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor10.jpeg',
      ),
      const Doctor(
        id: 'd11',
        name: 'dr. AA. Yunda Prabundari , M.Biomed, Sp.PD',
        specialty: 'Penyakit Dalam',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor11.jpeg',
      ),
      const Doctor(
        id: 'd12',
        name: 'Prof. dr. Abdul Majid, Sp.PD-KKV',
        specialty: 'Penyakit Dalam',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor12.jpeg',
      ),
      const Doctor(
        id: 'd13',
        name: 'dr. Abram Pratama, Sp.PD',
        specialty: 'Penyakit Dalam',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor13.png',
      ),
      const Doctor(
        id: 'd14',
        name: 'dr. Aditya Tjandra Sp.PD',
        specialty: 'Penyakit Dalam',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor14.png',
      ),
      const Doctor(
        id: 'd15',
        name: 'dr. Akhmad Fajrin Priadinata , Sp.PD',
        specialty: 'Penyakit Dalam',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor15.jpeg',
      ),
      const Doctor(
        id: 'd16',
        name: 'dr. Adi Agung Anantawijaya Daryago, Sp.DV',
        specialty: 'Kulit dan Kelamin',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor16.jpeg',
      ),
      const Doctor(
        id: 'd17',
        name: 'dr. Adi Gunadi, Sp.KK, FINSDV, FAADV',
        specialty: 'Kulit dan Kelamin',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor17.png',
      ),
      const Doctor(
        id: 'd18',
        name: 'dr. Alfonsus Rendy Laksditalia Nugroho, Sp.DV',
        specialty: 'Kulit dan Kelamin',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor18.jpeg',
      ),
      const Doctor(
        id: 'd19',
        name: 'dr. Andravita Fenti Mitaart, Sp.KK',
        specialty: 'Kulit dan Kelamin',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor19.png',
      ),
      const Doctor(
        id: 'd20',
        name: 'dr. Andy Manggabarani, Sp.KK',
        specialty: 'Kulit dan Kelamin',
        whatsappNumber: '+628135791113',
        photoPath: 'assets/images/doctor20.png',
      ),
    ];

    medicines = const [
      Medicine(
        id: 'm1',
        name: 'Paracetamol 500 mg',
        imagePath: 'assets/images/medicine_pain.jpg',
        description: 'Obat penurun demam dan pereda nyeri untuk sakit kepala, gigi, dan flu.',
        usage: 'Dewasa: 1 tablet setiap 6-8 jam setelah makan. Maks 4 tablet/hari.',
      ),
      Medicine(
        id: 'm2',
        name: 'Vitamin C 500 mg',
        imagePath: 'assets/images/medicine_vitamin.jpg',
        description: 'Suplemen untuk menjaga daya tahan tubuh dan kesehatan kulit.',
        usage: '1 tablet setiap pagi setelah sarapan.',
      ),
      Medicine(
        id: 'm3',
        name: 'Ibuprofen 400 mg',
        imagePath: 'assets/images/medicine_pain.jpg',
        description: 'Anti inflamasi non steroid untuk nyeri otot, sendi, dan demam.',
        usage: '1 tablet setiap 8 jam setelah makan. Tidak dianjurkan bagi penderita maag.',
      ),
      Medicine(
        id: 'm4',
        name: 'Amoxicillin 500 mg',
        imagePath: 'assets/images/medicine_general.jpg',
        description: 'Antibiotik spektrum luas untuk infeksi bakteri.',
        usage: '1 kapsul setiap 8 jam. Habiskan sesuai resep dokter.',
      ),
      Medicine(
        id: 'm5',
        name: 'Cetirizine 10 mg',
        imagePath: 'assets/images/medicine_general.jpg',
        description: 'Antihistamin untuk meredakan alergi, gatal, dan bersin.',
        usage: '1 tablet sekali sehari sebelum tidur.',
      ),
      Medicine(
        id: 'm6',
        name: 'Ambroxol 30 mg',
        imagePath: 'assets/images/medicine_general.jpg',
        description: 'Mukolitik untuk membantu mengencerkan dahak saat batuk berdahak.',
        usage: '1 tablet tiga kali sehari setelah makan.',
      ),
      Medicine(
        id: 'm7',
        name: 'Lansoprazole 30 mg',
        imagePath: 'assets/images/medicine_general.jpg',
        description: 'Obat penurun asam lambung untuk GERD atau maag.',
        usage: '1 kapsul sebelum makan pagi selama 14 hari atau sesuai petunjuk dokter.',
      ),
      Medicine(
        id: 'm8',
        name: 'Zinc 20 mg',
        imagePath: 'assets/images/medicine_vitamin.jpg',
        description: 'Mineral untuk membantu penyembuhan luka dan meningkatkan imunitas.',
        usage: '1 tablet setelah makan malam.',
      ),
    ];

    _registeredUser = User(
      name: 'Pasien SIGAP',
      email: 'pasien@sigap.app',
      password: '123456',
      phone: '+628123456789',
    );
  }

  static final AppState instance = AppState._internal();
  static const String adminWhatsAppNumber = '+6282273421481';


  User? _registeredUser;
  User? _currentUser;
  bool _hasSeenIntro = false;
  bool _initialized = false;
  final double _userLatitude = 3.595195;
  final double _userLongitude = 98.672222;

  late final List<Doctor> doctors;
  late final List<Facility> facilities;
  late final List<Medicine> medicines;

  final List<ConsultationSession> _sessions = [];
  final List<String> _searchHistory = [];
  final List<String> _searchedMedicines = [];
  final List<String> _clickedMedicines = [];
  int _searchCount = 0;

  User? get currentUser => _currentUser;
  User? get registeredUser => _registeredUser;
  bool get hasRegisteredUser => _registeredUser != null;
  bool get hasSeenIntro => _hasSeenIntro;
  bool get isInitialized => _initialized;

  List<ConsultationSession> get consultationSessions =>
      List.unmodifiable(_sessions);
  List<String> get searchHistory => List.unmodifiable(_searchHistory);
  List<String> get searchedMedicines => List.unmodifiable(_searchedMedicines);
  List<String> get clickedMedicines => List.unmodifiable(_clickedMedicines);
  int get totalSearches => _searchCount;
  String get userAvatarPath => defaultUserAvatarPath;

  void registerUser(User user) {
    _registeredUser = user.copy();
    _currentUser = null;
    notifyListeners();
  }

  bool login(String email, String password) {
    final user = _registeredUser;
    if (user == null) {
      return false;
    }

    if (user.email.trim().toLowerCase() == email.trim().toLowerCase() &&
        user.password == password) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> ensureInitialized() async {
    if (_initialized) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    _hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
    _initialized = true;
    notifyListeners();
  }

  Future<void> markIntroSeen() async {
    if (_hasSeenIntro) {
      return;
    }
    _hasSeenIntro = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);
  }

  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    final user = _registeredUser;
    if (user == null) {
      return;
    }

    user
      ..name = name
      ..email = email
      ..phone = phone;

    if (_currentUser != null) {
      _currentUser!
        ..name = name
        ..email = email
        ..phone = phone;
    }
    notifyListeners();
  }

  bool changePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    final user = _registeredUser;
    if (user == null || user.password != oldPassword) {
      return false;
    }

    user.password = newPassword;
    if (_currentUser != null) {
      _currentUser!.password = newPassword;
    }
    notifyListeners();
    return true;
  }

  void createConsultationSession(Doctor doctor) {
    final session = ConsultationSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      doctorId: doctor.id,
      doctorName: doctor.name,
      date: DateTime.now(),
      items: _buildDummyPrescriptionItems(),
      doctorNotes:
          'Silakan hubungi kami kembali jika keluhan berlanjut setelah 3 hari.',
    );
    _sessions.insert(0, session);
    notifyListeners();
  }

  void recordSearchKeyword(String keyword) {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) {
      return;
    }
    _searchCount++;
    _searchHistory.insert(0, trimmed);
    if (_searchHistory.length > 5) {
      _searchHistory.removeLast();
    }
    notifyListeners();
  }

  void recordMedicineResults(List<Medicine> medicines) {
    if (medicines.isEmpty) {
      return;
    }
    for (final medicine in medicines.take(3)) {
      _searchedMedicines.remove(medicine.name);
      _searchedMedicines.insert(0, medicine.name);
    }
    if (_searchedMedicines.length > 5) {
      _searchedMedicines.removeRange(5, _searchedMedicines.length);
    }
    notifyListeners();
  }

  void recordMedicineClick(Medicine medicine) {
    _clickedMedicines.remove(medicine.name);
    _clickedMedicines.insert(0, medicine.name);
    if (_clickedMedicines.length > 5) {
      _clickedMedicines.removeLast();
    }
    notifyListeners();
  }

  List<Medicine> filterMedicines(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return List<Medicine>.from(medicines);
    }
    final lower = trimmed.toLowerCase();
    return medicines
        .where(
          (medicine) => medicine.name.toLowerCase().contains(lower),
        )
        .toList();
  }

  List<Facility> getNearestFacilities({int limit = 3}) {
    final pairs = facilities
        .map(
          (facility) => (
            facility: facility,
            distance: _calculateDistanceTo(facility.latitude, facility.longitude),
          ),
        )
        .toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));

    return pairs.take(limit).map((pair) => pair.facility).toList();
  }

  double distanceToFacility(Facility facility) {
    return _calculateDistanceTo(facility.latitude, facility.longitude);
  }

  Future<void> openAdminWhatsAppSupport(BuildContext context) async {
    final message =
        'Halo Admin SIGAP, saya ingin bertanya tentang penggunaan aplikasi.';
    final url =
        'whatsapp://send?phone=${adminWhatsAppNumber.replaceAll(RegExp('[^0-9+]'), '')}&text=${Uri.encodeComponent(message)}';
    final messenger = ScaffoldMessenger.of(context);
    final launched = await launchUrlString(url);
    if (!launched) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Gagal membuka WhatsApp. Pastikan aplikasi terpasang.'),
        ),
      );
    }
  }

  List<PrescriptionItem> _buildDummyPrescriptionItems() {
    return const [
      PrescriptionItem(
        medicineName: 'Paracetamol 500 mg',
        instruction: '3x1 tablet setelah makan',
      ),
      PrescriptionItem(
        medicineName: 'Vitamin C 500 mg',
        instruction: '1x1 tablet pagi hari',
      ),
      PrescriptionItem(
        medicineName: 'Omeprazole 20 mg',
        instruction: '1x1 kapsul sebelum makan',
      ),
    ];
  }

  double _calculateDistanceTo(double lat, double lng) {
    const double earthRadiusKm = 6371;
    final double dLat = _degreesToRadians(lat - _userLatitude);
    final double dLon = _degreesToRadians(lng - _userLongitude);

    final double lat1 = _degreesToRadians(_userLatitude);
    final double lat2 = _degreesToRadians(lat);

    final double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2));
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degree) => degree * (pi / 180);
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AppState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in context');
    return scope!.notifier!;
  }
}
