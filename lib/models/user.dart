class User {
  String email;
  String password;
  String nickname;

  User({required this.email, required this.password, required this.nickname});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'nickname': nickname,
    };
  }
}
