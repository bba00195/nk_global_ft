class ImageResponseModel {
  final String reqNo;
  final dynamic fileSrc;

  ImageResponseModel({
    required this.reqNo,
    required this.fileSrc,
  });

  factory ImageResponseModel.fromJson(Map<dynamic, dynamic> json) {
    return ImageResponseModel(
        reqNo: json['REQ_NO'] != null ? json['REQ_NO'] as String : "",
        fileSrc:
            json['FILE_SOURCE'] != null ? json['FILE_SOURCE'] as dynamic : "");
  }
}

class ImageResultModel {
  List<ImageResponseModel> image;

  ImageResultModel({required this.image});

  factory ImageResultModel.fromJson(Map<dynamic, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<ImageResponseModel> imageList =
        list.map((i) => ImageResponseModel.fromJson(i)).toList();
    return ImageResultModel(image: imageList);
  }
}
