class UserInfo {
  static final UserInfo _userInfo = UserInfo._internal();

  factory UserInfo() {
    return _userInfo;
  }

  UserInfo._internal();

  String? userName = '';
  String? id;
  String? token;
  String? role = '';
}
