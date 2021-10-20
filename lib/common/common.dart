class User {
  final String userId;
  final String userName;
  final String password;
  final String custCode;
  final String custName;
  final String userCode;
  final String userType;
  final String eMail;
  final String phone;
  final String useFlag;

  User(
      {required this.userId,
      required this.userName,
      required this.password,
      required this.custCode,
      required this.custName,
      required this.userCode,
      required this.userType,
      required this.eMail,
      required this.phone,
      required this.useFlag});
}

class UserManager {
  late User _user;

  // ignore: unnecessary_getters_setters
  User get user => _user;

  // ignore: unnecessary_getters_setters
  set user(User user) {
    _user = user;
  }
}
