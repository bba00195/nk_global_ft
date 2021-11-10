class PortlistResponseModel {
  final String reqport;
  PortlistResponseModel({
    required this.reqport,
  });

  factory PortlistResponseModel.fromJson(Map<String, dynamic> json) {
    return PortlistResponseModel(
      reqport: json['REQ_PORT'] != null ? json['REQ_PORT'] as String : "",
    );
  }
}

class PortlistResultModel {
  List<PortlistResponseModel> port;

  PortlistResultModel({required this.port});

  factory PortlistResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    List<PortlistResponseModel> portlist =
        list.map((i) => PortlistResponseModel.fromJson(i)).toList();
    return PortlistResultModel(port: portlist);
  }
}
