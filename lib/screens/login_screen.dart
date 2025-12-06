import 'package:flutter/material.dart';

import '../app_state.dart';
import '../utils/validators.dart';
import '../widgets/auth_hero.dart';
import '../widgets/sigap_app_bar.dart';
import '../widgets/sigap_scaffold.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _didPrefill = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrefill) {
      return;
    }
    final user = AppStateScope.of(context).registeredUser;
    if (user != null) {
      _emailController.text = user.email;
      _passwordController.text = user.password;
      _didPrefill = true;
    }
  }

  void _handleLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final appState = AppStateScope.of(context);
    final success = appState.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success) {
      setState(() => _errorMessage = null);
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      setState(() => _errorMessage = 'Email atau kata sandi tidak sesuai.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    return SigapScaffold(
      appBar: const SigapAppBar(title: ''),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 720 ? 520.0 : double.infinity;
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthHero(
                      title: 'Selamat datang kembali',
                      subtitle:
                          'Masuk untuk melanjutkan konsultasi dan pantau resep terbarumu.',
                      imagePath: 'assets/images/doctor_vector.png',
                      highlights: [
                        'Resep tersimpan otomatis',
                        'Konsultasi via WhatsApp',
                        'Dokter profesional',
                      ],
                    ),
                    const SizedBox(height: 28),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.black12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x12000000),
                            blurRadius: 18,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Masuk akun SIGAP',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.mail_outline),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.validateEmail,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Kata Sandi',
                                  prefixIcon: Icon(Icons.lock_outline),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Kata sandi wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Fitur lupa kata sandi belum tersedia di prototipe.',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Lupa kata sandi?'),
                                ),
                              ),
                              if (_errorMessage != null)
                                Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              if (!appState.hasRegisteredUser)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Belum ada akun terdaftar. Silakan registrasi terlebih dahulu.',
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: appState.hasRegisteredUser
                                    ? _handleLogin
                                    : null,
                                child: const Text('Masuk ke SIGAP'),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Belum punya akun?',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pushNamed(
                                      context,
                                      RegisterScreen.routeName,
                                    ),
                                    child: const Text('Daftar sekarang'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
