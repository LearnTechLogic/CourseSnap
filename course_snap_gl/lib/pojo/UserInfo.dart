class UserInfo {
  int account;
  String name;
  String password;
  int price;
  String state;
  String requirement;
  String qq;
  String image1;
  String image2;

  UserInfo({
    required this.account,
    required this.name,
    required this.password,
    required this.price,
    required this.state,
    required this.requirement,
    required this.qq,
    required this.image1,
    required this.image2,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      account: json['account'] ?? 0,
      name: json['name'] ?? '',
      password: json['password'] ?? '',
      price: json['price'] ?? 0,
      state: json['state'] ?? '',
      requirement: json['requirement'] ?? '',
      qq: json['qq'] ?? '',
      image1: json['images1'] ?? '',
      image2: json['images2'] ?? '',
    );
  }
}