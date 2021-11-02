class ImageResponseModel {
  final String fileSrc;

  ImageResponseModel({
    required this.fileSrc,
  });

  factory ImageResponseModel.fromJson(Map<String, dynamic> json) {
    return ImageResponseModel(
        fileSrc:
            json['FILE_SOURCE'] != null ? json['FILE_SOURCE'] as String : "");
  }
}

class ImageResultModel {
  List<ImageResponseModel> image;

  ImageResultModel({required this.image});

  factory ImageResultModel.fromJson(Map<String, dynamic> json) {
    var list = json['RESULT'] != null ? json['RESULT'] as List : [];
    // print(list.runtimeType);
    List<ImageResponseModel> imageList =
        list.map((i) => ImageResponseModel.fromJson(i)).toList();
    return ImageResultModel(image: imageList);
  }
}
