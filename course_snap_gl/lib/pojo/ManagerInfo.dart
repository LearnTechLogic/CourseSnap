class ManagerInfo {
  String name;
  int account;
  String password;
  int identity;
  String token;
  int doing;
  int done;

  ManagerInfo({
    required this.name,
    required this.account,
    required this.password,
    required this.identity,
    required this.token,
    required this.doing,
    required this.done
  });

  factory ManagerInfo.fromJson(Map<String, dynamic> json) {
    return ManagerInfo(
      name: json['name'] ?? '',
      account: json['account'] ?? 00000000,
      password: json['password'] ?? '',
      identity: json['identity'] ?? 0,
      token: json['token'] ?? '',
      doing: json['doing'] ?? 0,
      done: json['done'] ?? 0
    );
  }
}