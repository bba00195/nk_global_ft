class UserResponseModel {
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

  UserResponseModel(
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

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
        userId: json['USER_ID'] != null ? json['USER_ID'] as String : "",
        userName: json['USER_NAME'] != null ? json['USER_NAME'] as String : "",
        password: json['PASSWORD'] != null ? json['PASSWORD'] as String : "",
        custCode: json['CUST_CODE'] != null ? json['CUST_CODE'] as String : "",
        custName: json['CUST_NAME'] != null ? json['CUST_NAME'] as String : "",
        userType: json['USER_TYPE'] != null ? json['USER_TYPE'] as String : "",
        userCode: json['USER_CODE'] != null ? json['USER_CODE'] as String : "",
        eMail: json['EMAIL'] != null ? json['USER_CODE'] as String : "",
        phone: json['PHONE'] != null ? json['PHONE'] as String : "",
        useFlag: json['USE_FLAG'] != null ? json['USE_FLAG'] as String : "");
  }
}

class UserResultModel {
  List<UserResponseModel> user;

  UserResultModel({required this.user});

  factory UserResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<UserResponseModel> userList =
        list.map((i) => UserResponseModel.fromJson(i)).toList();
    return UserResultModel(user: userList);
  }
}
