import 'package:flutter/material.dart';

import '../app_state.dart';
import '../models/user.dart';
import '../utils/validators.dart';
import '../widgets/sigap_app_bar.dart';
import '../widgets/sigap_scaffold.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isEditing = false;
  User? _lastUser;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final user = appState.currentUser ?? appState.registeredUser;
    return SigapScaffold(
      appBar: SigapAppBar(
        title: 'Profil Pengguna',
        actions: user == null
            ? null
            : [
                IconButton(
                  icon: Icon(_isEditing ? Icons.close : Icons.edit),
                  onPressed: () {
                    setState(() => _isEditing = !_isEditing);
                  },
                ),
              ],
      ),
      body: user == null
          ? const Center(
              child: Text('Belum ada data pengguna. Silakan login.'),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 52,
                              backgroundImage:
                                  AssetImage(AppState.defaultUserAvatarPath),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              user.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _ProfileField(
                            label: 'Nama',
                            controller: _nameController,
                            isEditing: _isEditing,
                          ),
                          _ProfileField(
                            label: 'Email',
                            controller: _emailController,
                            isEditing: _isEditing,
                          ),
                          _ProfileField(
                            label: 'Nomor HP',
                            controller: _phoneController,
                            isEditing: _isEditing,
                          ),
                          const SizedBox(height: 24),
                          if (_isEditing)
                            ElevatedButton(
                              onPressed: _saveProfile,
                              child: const Text('Simpan Perubahan'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.controller,
    required this.isEditing,
  });

  final String label;
  final TextEditingController controller;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        readOnly: !isEditing,
      ),
    );
  }
}
