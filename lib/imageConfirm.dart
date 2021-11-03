import 'package:nk_global_ft/api/api_Service.dart';
import 'package:nk_global_ft/common/common.dart';
import 'package:nk_global_ft/model/image_model.dart';
import 'package:sizer/sizer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ImageConfirm extends StatefulWidget {
  final String reqNo;

  ImageConfirm({required this.reqNo});
  @override
  _ImageConfirmState createState() => _ImageConfirmState();
}

class _ImageConfirmState extends State<ImageConfirm> {
  late String reqNo;

  APIService apiService = new APIService();
  List<ImageResponseModel> imgVal = [];
  String img = "";
  List<String> imgList = [];
  List<String> testList = [];
  String imgs = "";
  @override
  void initState() {
    reqNo = widget.reqNo;
    mainSchSearch();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  mainSchSearch() async {
    List<String> sParam = [reqNo];
    await apiService.getSelect("IMAGE_S1", sParam).then((value) {
      setState(() {
        if (value.image.isNotEmpty) {
          imgVal = value.image;
          for (int i = 0; i < imgVal.length; i++) {
            img = imgVal.elementAt(i).fileSrc;
            imgList.add(img);
          }

          // img = value.imageList.elementAt(0).fileSrc;
        } else {}
      });
    });
  }

  // var image = BASE64.

  testImage() {
    for (int i = 0; i < imgList.length; i++) {
      imgs = imgList[i];
      return Image.memory(Uri.parse(imgs).data!.contentAsBytes());
    }
    return Container();
  }

  setImage() {
    if (img != "") {
      return Image.memory(Uri.parse(img).data!.contentAsBytes());
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        body: GestureDetector(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(),
            child: Column(
              children: [],
            ),
          ),
          onTap: () {},
        ),
      );
    });
  }
}
