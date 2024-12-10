class UserInfo {
  UserInfo._internal();

  static UserInfo _userInfo = UserInfo._internal();

  factory UserInfo() {
    return _userInfo;
  }

  String? userName = '';
  String? id;
  String? token;
  String? role = '';
}
