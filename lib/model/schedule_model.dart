class ScheduleResponseModel {
  final String reqNo;
  final String custCode;
  final String userId;
  final String reqVesselName;
  final String date;
  final String mgtStatus;
  final String reqport;

  ScheduleResponseModel(
      {required this.reqNo,
      required this.custCode,
      required this.userId,
      required this.reqVesselName,
      required this.date,
      required this.mgtStatus,
      required this.reqport});

  factory ScheduleResponseModel.fromJson(Map<String, dynamic> json) {
    return ScheduleResponseModel(
        reqNo: json['REQ_NO'] != null ? json['REQ_NO'] as String : "",
        custCode: json['CUST_CODE'] != null ? json['CUST_CODE'] as String : "",
        userId: json['USER_ID'] != null ? json['USER_ID'] as String : "",
        reqVesselName: json['REQ_VESSEL_NAME'] != null
            ? json['REQ_VESSEL_NAME'] as String
            : "",
        date: json['DATE'] != null ? json['DATE'] as String : "",
        mgtStatus:
            json['MGT_STATUS'] != null ? json['MGT_STATUS'] as String : "",
        reqport: json['REQ_PORT'] != null ? json['REQ_PORT'] as String : "");
  }
}

class ScheduleResultModel {
  List<ScheduleResponseModel> schedule;

  ScheduleResultModel({required this.schedule});

  factory ScheduleResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<ScheduleResponseModel> scheduleList =
        list.map((i) => ScheduleResponseModel.fromJson(i)).toList();
    return ScheduleResultModel(schedule: scheduleList);
  }
}
