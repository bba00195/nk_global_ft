import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:nk_global_ft/home_page.dart';
import 'package:nk_global_ft/imageConfirm.dart';
import 'package:nk_global_ft/model/master_model.dart';
import 'package:nk_global_ft/model/common_model.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'common/common.dart';
import 'model/image_model.dart';

class ASmanagement2 extends StatefulWidget {
  final UserManager member;
  final String reqNo;
  final String split12;

  ASmanagement2({
    required this.member,
    required this.reqNo,
    required this.split12,
  });
  @override
  _ASmanagementState2 createState() => _ASmanagementState2();
}

class _ASmanagementState2 extends State<ASmanagement2> {
  List<Asset>? Imagelist = <Asset>[];
  List<Asset>? Imagelist2 = <Asset>[];
  List<Uint8List> imgs = [];
  late Uint8List signbyte;
  List<MultipartFile> mImageList = [];
  Dio dio = Dio();
  List<responseModel> result = [];
  List<ImageResponseModel> imgVal = [];
  String _error = 'No Error Dectected';
  APIService apiService = new APIService();

  late String split12 = '';
  late UserManager member;
  late String reqNo;
  late String filename = '';
  late String filename2 = '';
  late String filesrc = '';
  late String filesrc2 = '';

  late String signdata;
  late String signname = "";
  late String signsrc = "";

  ByteData _signimg = ByteData(0);

  String asAfter = "F";
  String asBefore = "B";
  String signCode = "C";
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  // String Status = '';
  late String base64Image;
  late String imageName;
  late String imageName2;
  bool _isChoosed = false;

  List<MasterResponseModel> masterList = [];
  String reqName = '';
  String shipCust = '';
  String vesselName = '';
  String mmsiNo = '';
  String reqComment = '';
  String reqDate = '';
  String reqport = '';
  String reqtype = '';
  String reqquantity = '';

  String errmsg = 'Error Uploading Image';
  String uri = 'http://www.kuls.co.kr/NK/flutter/DBHelper.php';

  late String file_name1;
  late String Base64Image;

  DateFormat format2 = DateFormat("yyyy-MM-dd HH:mm:ss");

  DateTime datetime = DateTime.now();
  String strDate = '';

  final _sign = GlobalKey<SignatureState>();

  ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    member = widget.member;
    reqNo = widget.reqNo;
    split12 = widget.split12;

    selectMaster();
  }

  @override
  void dispose() {
    super.dispose();
  }

  portSelSeref() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      split12 = (_prefs.getString('port') ?? '');
    });
  }
  // mainSchImg() async {
  //   List<String> sParam = [reqNo];
  //   await apiService.getSelect("IMAGE_S1", sParam).then((value) {
  //     setState(() {
  //       if (value.image.isNotEmpty) {
  //         imgVal = value.image;
  //         for (int i = 0; i < imgVal.length; i++) {
  //           img = imgVal.elementAt(i).fileSrc;

  //         }

  //         // img = value.imageList.elementAt(0).fileSrc;
  //       } else {}
  //     });
  //   });
  // }

  Future writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Widget buildGridview() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      children: List.generate(Imagelist!.length, (index) {
        Asset asset = Imagelist![index];
        return AssetThumb(asset: asset, width: 40, height: 40);
      }),
    );
  }

  void show_alert() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Signature Error"),
            content: Text("Sign here,please"),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("check"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  completeTaskAlert(String reqNo, String userid, String filetype,
      String filename, var filesrc) {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Do you want to complete the task?"),
            actions: [
              CupertinoDialogAction(
                child: Text("Allow"),
                onPressed: () async {
                  masterUpdate2(reqNo);
                  // as_After_fileUpload(
                  //     reqNo, userid, filetype, filename, filesrc);
                  Navigator.of(context).pop();
                  // Navigator.pushReplacement(
                  //   context,
                  //   CupertinoPageRoute(
                  //     builder: (context) => ASmanagement(
                  //       member: member,
                  //     ),
                  //   ),
                  // );
                },
              ),
              CupertinoDialogAction(
                child: Text("Deny"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
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

  // mainSchSearch() async {
  //   List<String> sParam = [
  //     member.user.userId,
  //   ];
  //   await apiService.getSelect("HISTORY_S1", sParam).then((value) {
  //     setState(() {
  //       if (value.mainSch.isNotEmpty) {
  //         mainSchList = value.mainSch;
  //       } else {}
  //     });
  //   });
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

  as_After_fileUpload(String reqNo, String filetype, String userid,
      String filename, String filesrc) async {
    List<String> sParam = [
      reqNo,
      filetype,
      member.user.userId,
      filename,
      filesrc,
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

  as_Before_fileUpload(String reqNo, String filetype, String userid,
      String filename2, String filesrc2) async {
    List<String> sParam = [
      reqNo,
      asBefore,
      member.user.userId,
      filename2,
      filesrc2,
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

  signature_fileUpload(String reqNo, String filetype, String userid,
      String filename2, String filesrc2) async {
    List<String> sParam = [
      reqNo,
      signCode,
      member.user.userId,
      signname,
      signdata,
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

  fileimage_upload(String reqNo, String userid, String filetype,
      String filename, String filesrc) async {
    List<String> sParam = [
      reqNo,
      filetype,
      member.user.userId,
      imageName,
      base64Image
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

  final IconTheme = ThemeData(
      colorScheme: ThemeData().colorScheme.copyWith(
            secondary: Colors.green,
          ));

  addpick() {
    return Container(
      width: 200,
      height: 200,
      child: IconButton(
          icon: Icon(
            CupertinoIcons.add_circled_solid,
            size: 50,
          ),
          onPressed: () {
            addpickimg();
          }),
    );
  }

  addpickimg() async {
    List<Asset> pickadd = <Asset>[];
    try {
      pickadd =
          await MultiImagePicker.pickImages(maxImages: 10, enableCamera: false);
    } on NoImagesSelectedException catch (e) {
      e.toString();
      return;
    }
    setState(() {
      for (int i = 0; i < pickadd.length; i++) {
        Asset assimg = pickadd.elementAt(i);
        Imagelist!.add(assimg);
      }
    });
  }

  addpick2() {
    return Container(
      width: 200,
      height: 200,
      child: IconButton(
          icon: Icon(
            CupertinoIcons.add_circled_solid,
            size: 50,
          ),
          onPressed: () {
            addpickimg2();
          }),
    );
  }

  addpickimg2() async {
    List<Asset> pickadd = <Asset>[];
    try {
      pickadd =
          await MultiImagePicker.pickImages(maxImages: 10, enableCamera: false);
    } on NoImagesSelectedException catch (e) {
      e.toString();
      return;
    }
    setState(() {
      for (int i = 0; i < pickadd.length; i++) {
        Asset assimg = pickadd.elementAt(i);
        Imagelist2!.add(assimg);
      }
    });
  }

  //Information
  Widget asTable(String reqName, String shipCust, String vesselName,
      String mmsiNo, String reqComment, String reqDate, String split12) {
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
                    Text(split12,
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

  Widget detailContainer(String reqNo, String categoryName, String type,
      String quantity, String vesselName, String imono) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        minHeight: 120,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: AutoSizeText(
                      vesselName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      minFontSize: 18,
                      maxLines: 1,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: AutoSizeText(
                      "$reqNo   /  $imono",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(169, 169, 169, 1.0),
                      ),
                      minFontSize: 12,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText(
                    categoryName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(169, 169, 169, 1.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 8,
                    child: AutoSizeText(
                      type,
                      textAlign: ui.TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AutoSizeText(
                      quantity,
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
          key: scaffoldKey,
          appBar: NkAppBar(
            globalKey: scaffoldKey,
            member: member,
            menuName: 'A/S Management',
          ),
          drawer: NkDrawer(
            globalKey: scaffoldKey,
            member: member,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.grey, width: 2.0))),
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
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  asTable(reqName, shipCust, vesselName, mmsiNo, reqComment,
                      reqDate, split12),
                  bigo(reqComment),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Container(
                        child: ExpansionTile(
                          leading: Icon(
                            Icons.check_rounded,
                          ),
                          title: Text("A/S Before",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          children: [
                            Imagelist2!.isEmpty
                                ? Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    child: DottedBorder(
                                      child: Container(
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {
                                              getImage2();
                                            },
                                            icon: Icon(CupertinoIcons.camera),
                                          ),
                                        ),
                                      ),
                                      color: Colors.grey,
                                      dashPattern: [5, 3],
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(10),
                                    ),
                                  )
                                : Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: Imagelist2!.length + 1,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (index == 0) {
                                          return addpick2();
                                        }
                                        Asset asset = Imagelist2![index - 1];
                                        return Stack(children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: AssetThumb(
                                              asset: asset,
                                              width: 200,
                                              height: 200,
                                            ),
                                          ),
                                          Positioned(
                                              right: -2,
                                              top: -9,
                                              child: IconButton(
                                                  icon: Icon(
                                                    Icons.cancel,
                                                    color: Colors.red
                                                        .withOpacity(0.8),
                                                    size: 25,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      Imagelist2!
                                                          .removeAt(index - 1);
                                                    });
                                                  }))
                                        ]);
                                      },
                                    ),
                                  ),

                            // ElevatedButton(
                            //   child: Text("test"),
                            //   onPressed: () {
                            //     getImage2();
                            //   },
                            // )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            child: ExpansionTile(
                              leading: Icon(
                                Icons.check_rounded,
                              ),
                              title: Text("A/S After",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                              children: [
                                Imagelist!.isEmpty
                                    ? Container(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: DottedBorder(
                                          child: Container(
                                            child: Center(
                                              child: IconButton(
                                                onPressed: () {
                                                  getImage();
                                                },
                                                icon:
                                                    Icon(CupertinoIcons.camera),
                                              ),
                                            ),
                                          ),
                                          color: Colors.grey,
                                          dashPattern: [5, 3],
                                          borderType: BorderType.RRect,
                                          radius: Radius.circular(10),
                                        ),
                                      )
                                    : Container(
                                        height: 200,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: Imagelist!.length + 1,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (index == 0) {
                                              return addpick();
                                            }
                                            Asset asset = Imagelist![index - 1];
                                            return Stack(children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: AssetThumb(
                                                    asset: asset,
                                                    width: 200,
                                                    height: 200),
                                              ),
                                              Positioned(
                                                  right: -2,
                                                  top: -9,
                                                  child: IconButton(
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        color: Colors.red
                                                            .withOpacity(0.8),
                                                        size: 25,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          Imagelist!.removeAt(
                                                              index - 1);
                                                        });
                                                      })),
                                            ]);
                                          },
                                        ),
                                      ),

                                // ElevatedButton(
                                //   child: Text("test"),
                                //   onPressed: () {
                                //     getImage2();
                                //   },
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Column(
                      //   children: [
                      //     Column(
                      //       children: [
                      //         Center(
                      //           child: Text(
                      //             "Signature",
                      //             style: TextStyle(
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           height: 10,
                      //         ),
                      //         Container(
                      //           height: 200,
                      //           decoration: BoxDecoration(
                      //               border: Border.all(
                      //                   color: Colors.grey, width: 1)),
                      //           child: Signature(
                      //             color: Colors.black,
                      //             key: _sign,
                      //             onSign: () {
                      //               final sign = _sign.currentState;
                      //               debugPrint(
                      //                   '${sign!.points.length} points in the signature');
                      //             },
                      //             strokeWidth: 2.5,
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //     Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //       children: [
                      //         Container(
                      //           child: IconButton(
                      //             icon: Icon(
                      //               Icons.refresh,
                      //               color: Colors.green,
                      //             ),
                      //             onPressed: () {
                      //               setState(() {
                      //                 final sign = _sign.currentState;
                      //                 sign!.clear();
                      //                 setState(() {
                      //                   _signimg = ByteData(0);
                      //                 });
                      //               });
                      //             },
                      //           ),
                      //         ),
                      //       ],
                      //     )
                      //   ],
                      // ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                          child: Container(
                              width: 70.w,
                              child: ElevatedButton(
                                  child: Text("SAVE"),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.indigo),
                                  onPressed: () async {
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.confirm,
                                        text:
                                            "Do you want to complete the task?",
                                        confirmBtnText: "Allow",
                                        confirmBtnColor: Colors.indigo,
                                        cancelBtnText: "Deny",
                                        cancelBtnTextStyle:
                                            TextStyle(color: Colors.black),
                                        onConfirmBtnTap: () async {
                                          for (int i = 0;
                                              i < Imagelist2!.length;
                                              i++) {
                                            ByteData byteData2 =
                                                await Imagelist2![i]
                                                    .getByteData(quality: 20);
                                            List<int> imgData2 =
                                                byteData2.buffer.asUint8List();
                                            filename2 = Imagelist2![i].name!;
                                            filesrc2 =
                                                "${base64Encode(imgData2)}";

                                            as_Before_fileUpload(
                                                reqNo,
                                                asBefore,
                                                member.user.userId,
                                                filename2,
                                                filesrc2);
                                          }

                                          for (int i = 0;
                                              i < Imagelist!.length;
                                              i++) {
                                            ByteData byteData =
                                                await Imagelist![i]
                                                    .getByteData(quality: 20);
                                            List<int> imgData =
                                                byteData.buffer.asUint8List();
                                            filename = Imagelist![i].name!;
                                            filesrc =
                                                "${base64Encode(imgData)}";

                                            as_After_fileUpload(
                                                reqNo,
                                                asAfter,
                                                member.user.userId,
                                                filename,
                                                filesrc);
                                          }

                                          // final sign = _sign.currentState;
                                          // final img = await sign!.getData();
                                          // var data = await img.toByteData(
                                          //     format: ui.ImageByteFormat.png);

                                          // List<int> encoded =
                                          //     data!.buffer.asUint8List();
                                          // setState(() {
                                          //   _signimg = data;
                                          //   signsrc =
                                          //       "${base64Encode(encoded)}";
                                          //   signname = member.user.userId +
                                          //       "_" +
                                          //       reqNo +
                                          //       "_"
                                          //           "signature" +
                                          //       ".png";

                                          //   as_Signature_upload(
                                          //       reqNo,
                                          //       signCode,
                                          //       member.user.userId,
                                          //       signname,
                                          //       signsrc);

                                          Navigator.pushReplacement(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      ImageConfirm(
                                                        member: member,
                                                        reqNo: reqNo,
                                                        split12: split12,
                                                      )));

                                          // return showDialog(
                                          //     context: context,
                                          //     builder: (context) {
                                          //       return CupertinoAlertDialog(
                                          //         title: Text(
                                          //             "Do you want to complete the task?"),
                                          //         actions: [
                                          //           CupertinoDialogAction(
                                          //             child: Text("Allow"),
                                          //             onPressed: () async {
                                          //               for (int i = 0;
                                          //                   i < Imagelist2!.length;
                                          //                   i++) {
                                          //                 ByteData byteData2 =
                                          //                     await Imagelist2![i]
                                          //                         .getByteData(
                                          //                             quality: 20);
                                          //                 List<int> imgData2 = byteData2
                                          //                     .buffer
                                          //                     .asUint8List();
                                          //                 filename2 =
                                          //                     Imagelist2![i].name!;
                                          //                 filesrc2 =
                                          //                     "${base64Encode(imgData2)}";

                                          //                 as_Before_fileUpload(
                                          //                     reqNo,
                                          //                     asBefore,
                                          //                     member.user.userId,
                                          //                     filename2,
                                          //                     filesrc2);
                                          //               }

                                          //               for (int i = 0;
                                          //                   i < Imagelist!.length;
                                          //                   i++) {
                                          //                 ByteData byteData =
                                          //                     await Imagelist![i]
                                          //                         .getByteData(
                                          //                             quality: 20);
                                          //                 List<int> imgData = byteData
                                          //                     .buffer
                                          //                     .asUint8List();
                                          //                 filename = Imagelist![i].name!;
                                          //                 filesrc =
                                          //                     "${base64Encode(imgData)}";

                                          //                 as_After_fileUpload(
                                          //                     reqNo,
                                          //                     asAfter,
                                          //                     member.user.userId,
                                          //                     filename,
                                          //                     filesrc);
                                          //               }

                                          //               final sign = _sign.currentState;
                                          //               final img = await sign!.getData();
                                          //               var data = await img.toByteData(
                                          //                   format:
                                          //                       ui.ImageByteFormat.png);

                                          //               List<int> encoded =
                                          //                   data!.buffer.asUint8List();
                                          //               setState(() {
                                          //                 _signimg = data;
                                          //                 signsrc =
                                          //                     "${base64Encode(encoded)}";
                                          //                 signname = member.user.userId +
                                          //                     "_" +
                                          //                     reqNo +
                                          //                     "_"
                                          //                         "signature" +
                                          //                     ".png";

                                          //                 as_Signature_upload(
                                          //                     reqNo,
                                          //                     signCode,
                                          //                     member.user.userId,
                                          //                     signname,
                                          //                     signsrc);
                                          //               });
                                          //               masterUpdate2(reqNo);
                                          //               Navigator.pushReplacement(
                                          //                   context,
                                          //                   CupertinoPageRoute(
                                          //                       builder: (context) =>
                                          //                           HomePage(
                                          //                               member: member)));
                                          //             },
                                          //           ),
                                          //           CupertinoDialogAction(
                                          //             child: Text("Deny"),
                                          //             onPressed: () {
                                          //               Navigator.of(context).pop();
                                          //             },
                                          //           )
                                          //         ],
                                          //       );
                                          //     });
                                        });
                                  })))
                    ],
                  )
                ],
              ),
            ),
          ));
    });
  }
}
