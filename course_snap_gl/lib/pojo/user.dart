class UserInfo {
  String name;
  String account;
  String password;
  String identity;
  String token;

  UserInfo({
    required this.name,
    required this.account,
    required this.password,
    required this.identity,
    required this.token
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'] ?? '',
      account: json['account'] ?? '',
      password: json['password'] ?? '',
      identity: json['identity'] ?? '',
      token: json['token'] ?? ''
    );
  }
}