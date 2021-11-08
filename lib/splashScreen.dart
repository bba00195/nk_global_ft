import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:nk_global_ft/asModify.dart';
import 'package:nk_global_ft/common/common.dart';
import 'package:nk_global_ft/imageConfirm.dart';
import 'package:nk_global_ft/model/common_model.dart';
import 'package:nk_global_ft/history.dart';
import 'package:nk_global_ft/main.dart';
import 'package:nk_global_ft/model/image_model.dart';
import 'package:nk_global_ft/model/master_model.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String reqNo;
  late UserManager member;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  APIService apiService = new APIService();
  List<ImageResponseModel> imgVal = [];
  List<ImageResponseModel> imgVal2 = [];
  List<responseModel> result = [];
  List<Asset>? Imagelist = <Asset>[];
  List<Asset>? Imagelist2 = <Asset>[];
  String imgB = "";
  String imgF = "";
  List<String> BList = [];
  List<String> FList = [];
  List<MasterResponseModel> masterList = [];
  String imgs = "";
  String imgs2 = "";
  String reqName = "";
  String shipCust = "";
  String mmsiNo = "";
  String vesselName = "";
  String reqComment = "";
  String reqDate = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _init() async {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ImageConfirm(
                  reqNo: reqNo,
                  member: member,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Colors.white,
            strokeWidth: 6,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Now Loading...",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(offset: Offset(4, 4), color: Colors.white10)],
                decorationStyle: TextDecorationStyle.solid),
          )
        ],
      )),
    );
  }
}
