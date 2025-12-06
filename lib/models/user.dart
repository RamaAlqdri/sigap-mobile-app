class User {
  User({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  String name;
  String email;
  String password;
  String phone;

  User copy() => User(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
}
