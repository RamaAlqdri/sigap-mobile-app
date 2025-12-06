import 'package:flutter/material.dart';

import 'app_state.dart';
import 'models/consultation_session.dart';
import 'screens/consultation_history_screen.dart';
import 'screens/doctor_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/prescription_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const SigapApp());
}

class SigapApp extends StatelessWidget {
  const SigapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: AppState.instance,
      child: MaterialApp(
        title: 'SIGAP',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          RegisterScreen.routeName: (_) => const RegisterScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
          DoctorListScreen.routeName: (_) => const DoctorListScreen(),
          SearchScreen.routeName: (_) => const SearchScreen(),
          ConsultationHistoryScreen.routeName: (_) =>
              const ConsultationHistoryScreen(),
          ProfileScreen.routeName: (_) => const ProfileScreen(),
          SettingsScreen.routeName: (_) => const SettingsScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == PrescriptionDetailScreen.routeName) {
            final session = settings.arguments as ConsultationSession;
            return MaterialPageRoute(
              builder: (_) => PrescriptionDetailScreen(session: session),
            );
          }
          return null;
        },
      ),
    );
  }
}
