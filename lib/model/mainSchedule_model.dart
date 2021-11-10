class MainSchResponseModel {
  final String reqNo;
  final String userId;
  final String startDate;
  final String endDate;
  final String custCode;
  final String vesselName;
  final String reqStatus;
  final String mgtStatus;
  final String reqport;
  final String reqtype;
  final String reqQuantity;

  MainSchResponseModel({
    required this.reqNo,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.custCode,
    required this.vesselName,
    required this.reqStatus,
    required this.mgtStatus,
    required this.reqport,
    required this.reqtype,
    required this.reqQuantity,
  });

  factory MainSchResponseModel.fromJson(Map<String, dynamic> json) {
    return MainSchResponseModel(
      reqNo: json['REQ_NO'] != null ? json['REQ_NO'] as String : "",
      userId: json['USER_ID'] != null ? json['USER_ID'] as String : "",
      startDate: json['START_DATE'] != null ? json['START_DATE'] as String : "",
      endDate: json['END_DATE'] != null ? json['END_DATE'] as String : "",
      custCode: json['CUST_CODE'] != null ? json['CUST_CODE'] as String : "",
      vesselName: json['REQ_VESSEL_NAME'] != null
          ? json['REQ_VESSEL_NAME'] as String
          : "",
      reqStatus: json['REQ_STATUS'] != null ? json['REQ_STATUS'] as String : "",
      mgtStatus: json['MGT_STATUS'] != null ? json['MGT_STATUS'] as String : "",
      reqport: json['REQ_PORT'] != null ? json['REQ_PORT'] as String : "",
      reqtype: json['REQ_TYPE'] != null ? json['REQ_TYPE'] as String : "",
      reqQuantity:
          json['REQ_QUANTITY'] != null ? json['REQ_QUANTITY'] as String : "",
    );
  }
}

class MainSchResultModel {
  List<MainSchResponseModel> mainSch;

  MainSchResultModel({
    required this.mainSch,
  });

  factory MainSchResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<MainSchResponseModel> mainSchList =
        list.map((i) => MainSchResponseModel.fromJson(i)).toList();

    return MainSchResultModel(
      mainSch: mainSchList,
    );
  }
}
