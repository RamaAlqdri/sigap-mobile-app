import 'package:flutter/material.dart';

import '../app_state.dart';
import '../utils/validators.dart';
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
      applyContentPadding: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 600 ? 480.0 : double.infinity;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: Align(
                alignment: const Alignment(0, -0.2),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Selamat datang di SIGAP',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Masuk untuk melanjutkan konsultasi kesehatanmu',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Kata Sandi',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kata sandi wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed:
                            appState.hasRegisteredUser ? _handleLogin : null,
                        child: const Text('Masuk'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          RegisterScreen.routeName,
                        ),
                        child: const Text('Belum punya akun? Daftar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
