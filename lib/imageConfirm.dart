import 'package:nk_global_ft/api/api_Service.dart';
import 'package:nk_global_ft/model/image_model.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ImageConfirm extends StatefulWidget {
  @override
  _ImageConfirmState createState() => _ImageConfirmState();
}

class _ImageConfirmState extends State<ImageConfirm> {
  APIService apiService = new APIService();
  List<ImageResponseModel> imgVal = [];
  String img = "";

  @override
  void initState() {
    mainSchSearch();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  mainSchSearch() async {
    List<String> sParam = [];
    await apiService.getSelect("IMAGE_S1", sParam).then((value) {
      setState(() {
        if (value.image.isNotEmpty) {
          imgVal = value.image;
          img = imgVal.elementAt(0).fileSrc;
          // img = value.imageList.elementAt(0).fileSrc;
        } else {}
      });
    });
  }

  // var image = BASE64.

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
              children: [
                setImage(),
              ],
            ),
          ),
          onTap: () {},
        ),
      );
    });
  }
}
