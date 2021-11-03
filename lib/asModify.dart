import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nk_global_ft/home_page.dart';
import 'package:nk_global_ft/model/common_model.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'common/common.dart';
import 'package:nk_global_ft/image_Utils_class.dart';

class ASmodify extends StatefulWidget {
  final UserManager member;
  final String reqNo;

  ASmodify({
    required this.member,
    required this.reqNo,
  });

  @override
  _ASmodifyState createState() => _ASmodifyState();
}

class _ASmodifyState extends State<ASmodify> {
  late UserManager member;
  APIService apiService = new APIService();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Asset>? Imagelist = <Asset>[];
  List<Asset>? Imagelist2 = <Asset>[];

  base64ToImage(String base64string) {}
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
          key: scaffoldKey,
          appBar: NkAppBar(
            globalKey: scaffoldKey,
            member: member,
            menuName: "AS Report Edit ",
          ),
          drawer: NkDrawer(globalKey: scaffoldKey, member: member),
          bottomNavigationBar: nkNaviBottomBar(
              globalKey: scaffoldKey, member: member, selectedIndex: 3),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(10),
            ),
          ));
    });
  }
}
