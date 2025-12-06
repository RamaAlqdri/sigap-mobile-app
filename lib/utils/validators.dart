class Validators {
  static final _emailRegExp =
      RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$');
  static final _phoneRegExp = RegExp(r'^\+62\d{8,13}$');

  static String? validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Email wajib diisi';
    }
    if (!_emailRegExp.hasMatch(trimmed)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Nomor HP wajib diisi';
    }
    if (!trimmed.startsWith('+62')) {
      return 'Nomor harus diawali +62';
    }
    if (!_phoneRegExp.hasMatch(trimmed)) {
      return 'Nomor harus diawali +62 dan diikuti 8-13 digit angka';
    }
    return null;
  }
}
