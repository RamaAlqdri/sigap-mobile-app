import 'package:flutter/material.dart';

import 'app_state.dart';
import 'models/consultation_session.dart';
import 'models/medicine.dart';
import 'screens/change_password_screen.dart';
import 'screens/device_management_screen.dart';
import 'screens/home_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/login_screen.dart';
import 'screens/medicine_detail_screen.dart';
import 'screens/prescription_detail_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/register_screen.dart';

const Color kBackgroundColor = Color(0xFFECF4E8);
const Color kButtonColor = Color(0xFF93BFC7);

void main() {
  runApp(const SigapApp());
}

class SigapApp extends StatefulWidget {
  const SigapApp({super.key});

  @override
  State<SigapApp> createState() => _SigapAppState();
}

class _SigapAppState extends State<SigapApp> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    AppState.instance.ensureInitialized().then((_) {
      if (mounted) {
        setState(() => _ready = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.transparent),
    );
    final colorScheme = ColorScheme.fromSeed(
      seedColor: kButtonColor,
    ).copyWith(
      primary: kButtonColor,
      secondary: kButtonColor,
    );
    return AppStateScope(
      notifier: AppState.instance,
      child: MaterialApp(
        title: 'SIGAP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            foregroundColor: Colors.black87,
            centerTitle: true,
          ),
          cardTheme: CardThemeData(
            color: Colors.white.withValues(alpha: 0.95),
            elevation: 4,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kButtonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: kButtonColor,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
            border: inputBorder,
            enabledBorder: inputBorder,
            focusedBorder: inputBorder.copyWith(
              borderSide: const BorderSide(color: kButtonColor, width: 1.4),
            ),
          ),
          textTheme: ThemeData.light().textTheme.apply(
                bodyColor: Colors.black87,
                displayColor: Colors.black87,
              ),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: kButtonColor.withValues(alpha: 0.95),
          ),
        ),
        initialRoute: AppState.instance.hasSeenIntro
            ? LoginScreen.routeName
            : IntroScreen.routeName,
        routes: {
          IntroScreen.routeName: (_) => const IntroScreen(),
          LoginScreen.routeName: (_) => const LoginScreen(),
          RegisterScreen.routeName: (_) => const RegisterScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
          ProfileEditScreen.routeName: (_) => const ProfileEditScreen(),
          ChangePasswordScreen.routeName: (_) => const ChangePasswordScreen(),
          DeviceManagementScreen.routeName: (_) =>
              const DeviceManagementScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == PrescriptionDetailScreen.routeName) {
            final session = settings.arguments as ConsultationSession;
            return MaterialPageRoute(
              builder: (_) => PrescriptionDetailScreen(session: session),
            );
          }
          if (settings.name == MedicineDetailScreen.routeName) {
            final medicine = settings.arguments as Medicine;
            return MaterialPageRoute(
              builder: (_) => MedicineDetailScreen(medicine: medicine),
            );
          }
          return null;
        },
      ),
    );
  }
}
