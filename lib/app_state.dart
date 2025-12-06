import 'package:flutter/widgets.dart';

import 'models/consultation_session.dart';
import 'models/doctor.dart';
import 'models/medicine.dart';
import 'models/prescription_item.dart';
import 'models/user.dart';

class AppState extends ChangeNotifier {
  AppState._internal() {
    doctors = [
      const Doctor(
        id: 'd1',
        name: 'Dr. Maya Pratiwi',
        specialty: 'Penyakit Dalam',
        whatsappNumber: '+628111222333',
      ),
      const Doctor(
        id: 'd2',
        name: 'Dr. Aditia Nugraha',
        specialty: 'Dokter Umum',
        whatsappNumber: '+6281234567890',
      ),
      const Doctor(
        id: 'd3',
        name: 'Dr. Ratna Dewi',
        specialty: 'Anak',
        whatsappNumber: '+628987654321',
      ),
      const Doctor(
        id: 'd4',
        name: 'Dr. Fajar Maulana',
        specialty: 'Kulit dan Kelamin',
        whatsappNumber: '+628135791113',
      ),
    ];

    medicines = const [
      Medicine(id: 'm1', name: 'Paracetamol 500 mg'),
      Medicine(id: 'm2', name: 'Vitamin C 500 mg'),
      Medicine(id: 'm3', name: 'Ibuprofen 400 mg'),
      Medicine(id: 'm4', name: 'Amoxicillin 500 mg'),
      Medicine(id: 'm5', name: 'Cetirizine 10 mg'),
      Medicine(id: 'm6', name: 'Ambroxol 30 mg'),
      Medicine(id: 'm7', name: 'Lansoprazole 30 mg'),
      Medicine(id: 'm8', name: 'Zinc 20 mg'),
    ];
  }

  static final AppState instance = AppState._internal();

  User? _registeredUser;
  User? _currentUser;

  late final List<Doctor> doctors;
  late final List<Medicine> medicines;

  final List<ConsultationSession> _sessions = [];
  final List<String> _searchHistory = [];
  final List<String> _clickedMedicines = [];
  int _searchCount = 0;

  User? get currentUser => _currentUser;
  User? get registeredUser => _registeredUser;
  bool get hasRegisteredUser => _registeredUser != null;

  List<ConsultationSession> get consultationSessions =>
      List.unmodifiable(_sessions);
  List<String> get searchHistory => List.unmodifiable(_searchHistory);
  List<String> get clickedMedicines => List.unmodifiable(_clickedMedicines);
  int get totalSearches => _searchCount;

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

  void recordClickedMedicine(Medicine medicine) {
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
