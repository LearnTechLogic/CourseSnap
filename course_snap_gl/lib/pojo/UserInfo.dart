class UserInfo {
  String name;
  int account;
  String password;
  int identity;
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
      account: json['account'] ?? 00000000,
      password: json['password'] ?? '',
      identity: json['identity'] ?? 0,
      token: json['token'] ?? ''
    );
  }
}