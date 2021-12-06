import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:nk_global_ft/asDetail2.dart';
import 'package:nk_global_ft/asModify.dart';
import 'package:nk_global_ft/common/common.dart';
import 'package:nk_global_ft/home_page.dart';
import 'package:nk_global_ft/model/common_model.dart';
import 'package:nk_global_ft/history.dart';
import 'package:nk_global_ft/main.dart';
import 'package:nk_global_ft/model/image_model.dart';
import 'package:nk_global_ft/model/master_model.dart';
import 'package:nk_global_ft/signature.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ImageConfirm extends StatefulWidget {
  final String reqNo;
  final UserManager member;
  final String split12;

  ImageConfirm(
      {required this.reqNo, required this.member, required this.split12});
  @override
  _ImageConfirmState createState() => _ImageConfirmState();
}

class _ImageConfirmState extends State<ImageConfirm> {
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
  late Uint8List _bytes;
  List<MasterResponseModel> masterList = [];
  String imgs = "";
  String imgs2 = "";
  String reqName = "";
  String shipCust = "";
  String mmsiNo = "";
  String vesselName = "";
  String reqComment = "";
  String reqDate = "";
  String reqtype = '';
  String reqport = '';
  String reqquantity = '';
  bool state1 = false;
  late String signsrc = '';
  late String signname = '';
  late String signdata;
  String signCode = "C";
  var picksign;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _picksign = [];

  final _sign = GlobalKey<SignatureState>();
  ByteData _signimg = ByteData(0);
  late AnimationController controller;

  DateTime datetime = DateTime.now();
  String strDate = '';
  DateFormat format2 = DateFormat("yyyy-MM-dd HH:mm:ss");

  @override
  void initState() {
    reqNo = widget.reqNo;
    member = widget.member;
    _init();
    selectMaster();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _init() async {
    mainSchSearch();
    mainSch2Search();
  }

  // void loadData() async {
  //   try {
  //     EasyLoading.show(status: 'Loading...');
  //     mainSchSearch();
  //     mainSch2Search();
  //     EasyLoading.dismiss();
  //   } catch (e) {
  //     EasyLoading.showError(e.toString());
  //     print(e);
  //   }
  // }

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

  histroyDelete(String reqNo) async {
    List<String> sParam = [reqNo, member.user.userId];

    await apiService.getDelete("HISTORY_APP_D1", sParam).then((value) {
      setState(() {
        if (value.result.isNotEmpty) {
          result = value.result;
          if (value.result.elementAt(0).rsCode == "E") {
            Show(message: value.result.elementAt(0).rsMsg);
          } else {
            Show(message: "Success Delete.");
          }
        } else {
          Show(message: "Fail to Delete");
        }
      });
    });
  }

  mainSchSearch() async {
    List<String> sParam = [reqNo];
    await apiService.getSelect("IMAGE_S1", sParam).then((value) {
      setState(() {
        if (value.image.isNotEmpty) {
          imgVal = value.image;
          for (int i = 0; i < imgVal.length; i++) {
            imgB = imgVal.elementAt(i).fileSrc;
            BList.add(imgB);
          }

          // img = value.imageList.elementAt(0).fileSrc;
        } else {}
      });
    });
  }

  mainSch2Search() async {
    List<String> sParam = [reqNo];
    await apiService.getSelect("IMAGE_S2", sParam).then((value) {
      setState(() {
        if (value.image.isNotEmpty) {
          imgVal2 = value.image;
          for (int i = 0; i < imgVal2.length; i++) {
            imgF = imgVal2.elementAt(i).fileSrc;
            FList.add(imgF);
          }

          // img = value.imageList.elementAt(0).fileSrc;
        } else {}
      });
    });
  }

  getImage() async {
    List<Asset> resultList = <Asset>[];
    String err = "error";
    try {
      resultList =
          await MultiImagePicker.pickImages(maxImages: 10, enableCamera: true);
    } on NoImagesSelectedException catch (e) {
      err = e.toString();
    }

    setState(() {
      Imagelist = resultList;
    });
  }

  clearImage() async {
    setState(() {
      Imagelist!.clear();
    });
  }

  getImage2() async {
    List<Asset> resultList2 = <Asset>[];
    String err = "error";
    try {
      resultList2 =
          await MultiImagePicker.pickImages(maxImages: 10, enableCamera: true);
    } on NoImagesSelectedException catch (e) {
      err = e.toString();
      return;
    }

    setState(() {
      Imagelist2 = resultList2;
    });
  }

  clearImage2() async {
    setState(() {
      Imagelist2!.clear();
    });
  }

  selectMaster() async {
    List<String> sParam = [
      reqNo,
    ];
    await apiService.getSelect("MASTER_S1", sParam).then((value) {
      setState(() {
        if (value.master.isNotEmpty) {
          masterList = value.master;

          reqName = masterList.elementAt(0).reqName;
          shipCust = masterList.elementAt(0).shipCust;
          vesselName = masterList.elementAt(0).vesselName;
          mmsiNo = masterList.elementAt(0).mmsiNo;
          reqComment = masterList.elementAt(0).reqComment;
          reqDate = masterList.elementAt(0).reqDate;
          reqport = masterList.elementAt(0).reqport;
          reqtype = masterList.elementAt(0).reqtype;
          reqquantity = masterList.elementAt(0).reqquantity;
        } else {
          print('fail');
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

  void imageSign() async {
    final List<XFile>? signs = await _picker.pickMultiImage();
    if (signs != null) {
      setState(() {
        _picksign = signs;
        picksign = signs[0];
      });
    }
  }

  Widget asTable(String reqName, String shipCust, String vesselName,
      String mmsiNo, String reqComment, String reqDate) {
    return Padding(
        padding: EdgeInsets.all(0),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(5),
            1: FlexColumnWidth(5),
          },
          border: TableBorder.all(
              color: Colors.grey, style: BorderStyle.solid, width: 1),
          children: [
            TableRow(children: [
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ENGINEER NAME",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(
                      member.user.userName,
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Req Date",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(reqDate,
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                    ]),
              )
            ]),
            TableRow(children: [
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Owner",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(shipCust,
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Req Name",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(reqName,
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                    ]),
              )
            ]),
            TableRow(children: [
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Vessel Name",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(vesselName,
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MMSI NO.",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      mmsiNo,
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              )
            ]),
            TableRow(children: [
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Port",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(reqport,
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Service",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(reqtype,
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                    ]),
              )
            ]),
          ],
        ));
  }

  Widget bigo(String reqComment) {
    return Container(
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(10),
        },
        border: TableBorder.all(
            color: Colors.grey, style: BorderStyle.solid, width: 1),
        children: [
          TableRow(children: [
            Container(
              padding: EdgeInsets.only(left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cust Comment",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    reqComment,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ])
        ],
      ),
    );
  }

  // var image = BASE64.

  testImage(int seq) {
    imgs = BList[seq];
    if (imgs != "") {
      return Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.memory(
                Uri.parse(imgs).data!.contentAsBytes(),
                fit: BoxFit.cover,
                height: 200,
                width: 200,
              )),
          SizedBox(
            width: 10,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  testImage2(int seq2) {
    imgs2 = FList[seq2];
    if (imgs2 != "") {
      return Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.memory(
                Uri.parse(imgs2).data!.contentAsBytes(),
                fit: BoxFit.cover,
                height: 200,
                width: 200,
              )),
          SizedBox(
            width: 10,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  // setImage() {
  //   if (img != "") {
  //     return Image.memory(Uri.parse(img).data!.contentAsBytes());
  //   } else {
  //     return Container();
  //   }
  // }

  box2() {
    return Column(
      children: [
        (_picksign.length == 0)
            ? Container(
                height: 150,
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
                height: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(picksign.path)))),
              )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //  ImageConfirm imageConfirm=
    //     context.findAncestorStateOfType<_ImageConfirmState>();
    return Sizer(builder: (context, orientation, deviceType) {
      return WillPopScope(
          onWillPop: () {
            return Future(() => false);
          },
          child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
              appBar: NkAppBar(
                  globalKey: scaffoldKey,
                  member: member,
                  menuName: "A/S Result"),
              drawer: NkDrawer(globalKey: scaffoldKey, member: member),
              body: GestureDetector(
                child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(),
                    child: Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.grey, width: 2.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(3, 2, 0, 1),
                            height: 20,
                            width: 100.w,
                            color: Colors.grey,
                            child: Text(
                              "Information",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          asTable(reqName, shipCust, vesselName, mmsiNo,
                              reqComment, reqDate),
                          bigo(reqComment),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(
                                "A/S Before",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    // FutureBuilder(
                                    //   future: mainSchSearch(),
                                    //   builder: (context, snapshot) {
                                    //     if (snapshot.hasData) {
                                    //      for(int i =0; i< BList.length; i++){
                                    //        testImage(i);
                                    //      }

                                    //     } else if (snapshot.hasError) {
                                    //       return Text("error");
                                    //     }
                                    //     return CircularProgressIndicator();
                                    //   },

                                    // )
                                    if (BList.length > 0)
                                      for (int i = 0; i < BList.length; i++)
                                        testImage(i),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text("A/S After",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    if (FList.length > 0)
                                      for (int j = 0; j < FList.length; j++)
                                        testImage2(j),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.confirm,
                                        text: "업로드된 사진을 재등록 하시겠습니까?",
                                        confirmBtnText: "Allow",
                                        confirmBtnColor: Colors.indigo,
                                        cancelBtnText: "Deny",
                                        cancelBtnTextStyle:
                                            TextStyle(color: Colors.black),
                                        onConfirmBtnTap: () async {
                                          histroyDelete(reqNo);
                                          Navigator.pushReplacement(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      ASmanagement2(
                                                        member: member,
                                                        reqNo: reqNo,
                                                        split12: '',
                                                      )));
                                        });
                                    // showDialog(
                                    //     context: context,
                                    //     builder: (context) {
                                    //       return CupertinoAlertDialog(
                                    //         title: Text("Waring!!!"),
                                    //         content:
                                    //             Text("업로드된 서명과 사진을 새로 등록하시겠습니까?"),
                                    //         actions: [
                                    //           CupertinoDialogAction(
                                    //             child: Text("yes"),
                                    //             onPressed: () async {
                                    //               histroyDelete(reqNo);
                                    //               Navigator.pushReplacement(
                                    //                   context,
                                    //                   CupertinoPageRoute(
                                    //                       builder: (context) =>
                                    //                           ASmodify(
                                    //                               member: member,
                                    //                               reqNo: reqNo)));
                                    //             },
                                    //           ),
                                    //           CupertinoDialogAction(
                                    //             child: Text("No"),
                                    //             onPressed: () {
                                    //               Navigator.pop(context);
                                    //             },
                                    //           ),
                                    //         ],
                                    //       );
                                    //     });
                                  },
                                  child: Text("Re-Upload"),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.indigo),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 3,
                                child: ElevatedButton(
                                  child: Text("Signature"),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.indigo),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => SignaturePage(
                                                reqNo: reqNo, member: member)));
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 3,
                                child: ElevatedButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                HomePage(member: member)));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.indigo),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              )));
    });
  }
}
