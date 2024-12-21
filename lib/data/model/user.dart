class User {
  String? id;
  String name;
  String role;
  User({
    this.id,
    required this.name,
    required this.role,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['username'],
      role: json['role'],
    );
  }
}
