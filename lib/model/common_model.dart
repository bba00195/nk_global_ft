class responseModel {
  final String rsCode;
  final String rsMsg;

  responseModel({
    required this.rsCode,
    required this.rsMsg,
  });

  factory responseModel.fromJson(Map<String, dynamic> json) {
    return responseModel(
      rsCode: json['RS_CODE'] != null ? json['RS_CODE'] as String : "",
      rsMsg: json['RS_MSG'] != null ? json['RS_MSG'] as String : "",
    );
  }
}

class resultModel {
  List<responseModel> result;

  resultModel({required this.result});

  factory resultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<responseModel> resultList =
        list.map((i) => responseModel.fromJson(i)).toList();
    return resultModel(result: resultList);
  }
}
