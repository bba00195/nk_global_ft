import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:nk_global_ft/asDetail2.dart';
import 'package:nk_global_ft/asModify.dart';
import 'package:nk_global_ft/common/common.dart';
import 'package:nk_global_ft/home_page.dart';
import 'package:nk_global_ft/imageConfirm.dart';
import 'package:nk_global_ft/model/common_model.dart';
import 'package:nk_global_ft/history.dart';
import 'package:nk_global_ft/main.dart';
import 'package:nk_global_ft/model/image_model.dart';
import 'package:nk_global_ft/model/master_model.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'common/common.dart';

class SignaturePage extends StatefulWidget {
  final String reqNo;
  final UserManager member;

  SignaturePage({required this.reqNo, required this.member});

  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  final ImagePicker _picker = ImagePicker();
  APIService apiService = new APIService();
  List<responseModel> result = [];
  List<XFile> _picksign = [];
  var picksign;
  late String reqNo;
  late UserManager member;
  String sign64 = '';

  DateTime datetime = DateTime.now();
  String strDate = '';
  DateFormat format2 = DateFormat("yyyy-MM-dd HH:mm:ss");
  late String signsrc = '';
  late String signname = '';
  String signCode = 'C';

  final _sign = GlobalKey<SignatureState>();
  ByteData _signimg = ByteData(0);
  List<File> filelist = [];

  @override
  void initState() {
    reqNo = widget.reqNo;
    member = widget.member;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  as_Signature_upload(String reqNo, String filetype, String userid,
      String signname, String filesrc) async {
    List<String> sParam = [
      reqNo,
      filetype,
      member.user.userId,
      signname,
      filesrc
    ];
    await apiService.getInsert("FILE_I1", sParam).then((value) {
      setState(() {
        if (value.result.isNotEmpty) {
          result = value.result;
          if (value.result.elementAt(0).rsCode == "E") {
            Show(message: value.result.elementAt(0).rsMsg);
          } else {
            Show(message: "Success upload.");
          }
        } else {
          Show(message: "Fail to upload");
        }
      });
    });
  }

  masterUpdate2(String reqNo) async {
    strDate = format2.format(datetime);
    List<String> sParam = [
      reqNo,
      member.user.userId,
      strDate,
    ];
    await apiService.getUpdate("MASTER_U2", sParam).then((value) {
      setState(() {
        if (value.result.isNotEmpty) {
          if (value.result.elementAt(0).rsCode == "E") {
            Show(message: value.result.elementAt(0).rsMsg);
          } else {
            Show(message: "Success save.");
          }
        } else {
          Show(message: "Fail to save");
        }
      });
    });
  }

  box2() {
    return Column(
      children: [
        (_picksign.length == 0)
            ? Container(
                height: 250,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1)),
                child: Signature(
                  color: Colors.black,
                  key: _sign,
                  onSign: () {
                    final sign = _sign.currentState;
                    debugPrint(
                        '${sign!.points.length} points in the signature');
                  },
                  strokeWidth: 2.5,
                ),
              )
            : Container(
                height: 250,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(picksign.path)))),
              )
      ],
    );
  }

  // void _XfiletoFile(List<XFile> _picksign){
  //   _picksign.forEach((element) {
  //     filelist.add(File(element.path));
  //   })
  // }

  Future<void> imageSign() async {
    void imageSign() async {
      final List<XFile>? signs = await _picker.pickMultiImage();
      if (signs != null) {
        setState(() {
          _picksign = signs;
          picksign = _picksign[0];
          final bytes = File(picksign.path).readAsBytesSync();
          sign64 = base64Encode(bytes);
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                "Signature",
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.navigate_before,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ImageConfirm(
                              reqNo: reqNo, member: member, split12: "")));
                },
              ),
            ),
            body: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 45.w,
                  ),
                  box2(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: IconButton(
                          iconSize: 30,
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            setState(() {
                              final sign = _sign.currentState;
                              if (sign != null) {
                                sign.clear();
                              } else
                                _picksign.clear();

                              setState(() {
                                _signimg = ByteData(0);
                              });
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Container(
                        child: IconButton(
                            iconSize: 30,
                            onPressed: () {
                              imageSign();
                            },
                            icon: Icon(
                              Icons.upload,
                              color: Colors.blue,
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 50.w,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.indigo),
                        onPressed: () async {
                          if (_picksign.isNotEmpty) {
                            setState(() {
                              signsrc = sign64;
                              signname = member.user.userId +
                                  "_" +
                                  "signature" +
                                  ".png";
                              as_Signature_upload(reqNo, signCode,
                                  member.user.userId, signname, sign64);
                            });
                          } else {
                            final sign = _sign.currentState;
                            final img = await sign!.getData();

                            var data = await img.toByteData(
                                format: ui.ImageByteFormat.png);
                            List<int> encode = data!.buffer.asUint8List();
                            setState(() {
                              _signimg = data;
                              signsrc = "${base64Encode(encode)}";
                              signname = member.user.userId +
                                  "_" +
                                  "signature" +
                                  ".png";
                              as_Signature_upload(reqNo, signCode,
                                  member.user.userId, signname, signsrc);
                            });
                          }
                          masterUpdate2(reqNo);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      HomePage(member: member)));
                        },
                        child: Text("Submit")),
                  )
                ],
              ),
            )),
        onWillPop: () {
          return Future(() => false);
        },
      );
    }
  }
}
