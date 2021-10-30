class MasterResponseModel {
  final String reqName;
  final String shipCust;
  final String vesselName;
  final String mmsiNo;
  final String reqComment;

  MasterResponseModel({
    required this.reqName,
    required this.shipCust,
    required this.vesselName,
    required this.mmsiNo,
    required this.reqComment,
  });

  factory MasterResponseModel.fromJson(Map<String, dynamic> json) {
    return MasterResponseModel(
        reqName: json['REQ_NAME'] != null ? json['REQ_NAME'] as String : "",
        shipCust: json['SHIP_CUST'] != null ? json['SHIP_CUST'] as String : "",
        vesselName:
            json['VESSEL_NAME'] != null ? json['VESSEL_NAME'] as String : "",
        mmsiNo: json['MMSI_NO'] != null ? json['MMSI_NO'] as String : "",
        reqComment:
            json['REQ_COMMENT'] != null ? json['REQ_COMMENT'] as String : "");
  }
}

class MasterResultModel {
  List<MasterResponseModel> master;

  MasterResultModel({required this.master});

  factory MasterResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<MasterResponseModel> masterList =
        list.map((i) => MasterResponseModel.fromJson(i)).toList();
    return MasterResultModel(master: masterList);
  }
}
