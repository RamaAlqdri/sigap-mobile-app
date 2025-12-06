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

const Color kBackgroundColor = Color(0xFFECF4E8);
const Color kButtonColor = Color(0xFF93BFC7);

void main() {
  runApp(const SigapApp());
}

class SigapApp extends StatelessWidget {
  const SigapApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          scaffoldBackgroundColor: kBackgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: kBackgroundColor,
            surfaceTintColor: Colors.transparent,
            foregroundColor: Colors.black87,
            centerTitle: true,
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: kButtonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
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
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: inputBorder,
            enabledBorder: inputBorder,
            focusedBorder: inputBorder.copyWith(
              borderSide: const BorderSide(color: kButtonColor),
            ),
          ),
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
