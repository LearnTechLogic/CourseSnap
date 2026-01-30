class UserInfo {
  int account;
  String name;
  String password;
  int price;
  String state;
  String requirement;
  int qq;

  UserInfo({
    required this.account,
    required this.name,
    required this.password,
    required this.price,
    required this.state,
    required this.requirement,
    required this.qq,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      account: json['account'] ?? 0,
      name: json['name'] ?? '',
      password: json['password'] ?? '',
      price: json['price'] ?? 0,
      state: json['state'] ?? 0,
      requirement: json['requirement'] ?? '',
      qq: json['qq'] ?? 0,
    );
  }
}