class User {
  String id;
  String userName;
  String role;
  String? token;

  User(
      {required this.id,
      required this.userName,
      required this.role,
      this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        '_id': String _id,
        'userName': String userName,
        'role': String role,
      } =>
        User(
          id: _id,
          userName: userName,
          role: role,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
