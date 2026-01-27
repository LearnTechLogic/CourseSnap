class User {
  String name;
  String account;
  String password;
  String identity;
  String token;

  User({
    required this.name,
    required this.account,
    required this.password,
    required this.identity,
    required this.token
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      account: json['account'] ?? '',
      password: json['password'] ?? '',
      identity: json['identity'] ?? '',
      token: json['token'] ?? ''
    );
  }
}