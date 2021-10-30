import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nk_global_ft/asReport.dart';
import 'package:nk_global_ft/home_page.dart';
import 'package:nk_global_ft/model/common_model.dart';
import 'package:nk_global_ft/model/master_model.dart';
import 'package:nk_global_ft/schedule.dart';
import 'package:signature/signature.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'common/common.dart';

class ASmanagement2 extends StatefulWidget {
  final UserManager member;
  final String reqNo;
  final String filetype = '';

  ASmanagement2({required this.member, required this.reqNo});
  @override
  _ASmanagementState2 createState() => _ASmanagementState2();
}

class _ASmanagementState2 extends State<ASmanagement2> {
  List<Asset>? Imagelist = <Asset>[];
  List<Asset>? Imagelist2 = <Asset>[];
  List<MultipartFile> mImageList = [];
  Dio dio = Dio();

  String _error = 'No Error Dectected';
  APIService apiService = new APIService();
  late UserManager member;
  late String reqNo;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  XFile? file;
  XFile? file2;
  late File tmpFile;
  late File tmpFile2;
  String Status = '';
  late String base64Image;
  late String imageName;
  late String imageName2;
  bool _isChoosed = false;

  List<responseModel> result = [];
  List<XFile>? _pickedImgs = [];
  List<MasterResponseModel> masterListValue = [];
  String errmsg = 'Error Uploading Image';
  String uri = 'http://www.kuls.co.kr/NK/flutter/DBHelper.php';

  late String file_name1;
  late String Base64Image;
  late ImagePicker _picker = ImagePicker();
  late ImagePicker _picker2 = ImagePicker();

  final ImagePicker _imagePicker = ImagePicker();

  SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.grey,
  );

  late String reqName = '';
  late String shipCust = '';
  late String vesselName = '';
  late String mmsiNo = '';
  late String reqComment = '';

  @override
  void initState() {
    super.initState();
    member = widget.member;
    reqNo = widget.reqNo;

    _controller.addListener(() {
      print('값 변경됨.');
    });
    selectMaster();
  }

  @override
  void dispose() {
    super.dispose();
  }

  selectMaster() async {
    List<String> sParam = [
      reqNo,
    ];
    await apiService.getSelect("MASTER_S1", sParam).then((value) {
      setState(() {
        if (value.master.isNotEmpty) {
          masterListValue = value.master;

          reqName = masterListValue.elementAt(0).reqName;
          shipCust = masterListValue.elementAt(0).shipCust;
          vesselName = masterListValue.elementAt(0).vesselName;
          mmsiNo = masterListValue.elementAt(0).mmsiNo;
          reqComment = masterListValue.elementAt(0).reqComment;
        } else {
          print('fail');
        }
      });
    });
  }

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

  Widget ConfirmCheck(BuildContext context) => IconButton(
        iconSize: 20,
        icon: Icon(Icons.check, color: Colors.red),
        onPressed: () async {
          if (_controller.isNotEmpty) {
            final signature = await exportSignature();
          }
        },
      );

  Future<Uint8List?> exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      points: _controller.points,
    );

    final signature = await exportController.toPngBytes();
    exportController.dispose();

    return signature;
  }

  Future<void> loadAsset() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 20,
        enableCamera: true,
        selectedAssets: Imagelist!,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Photo",
          allViewTitle: "All photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on NoImagesSelectedException catch (e) {
      error = e.toString();
      return;
    } on Exception catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      Imagelist = resultList;
      _error = error;
    });
  }

  _saveImage() async {
    if (Imagelist != null) {
      for (var i = 0; i < Imagelist!.length; i++) {
        ByteData byteData = await Imagelist![i].getByteData();
        List<int> ImagelistData = byteData.buffer.asUint8List();

        MultipartFile multipartFile = new MultipartFile.fromBytes(
          ImagelistData,
          filename: Imagelist![i].name,
          contentType: MediaType('image', 'jpg'),
        );
        mImageList.add(multipartFile);
      }
    }
  }

  completeTaskAlert(String reqNo) {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Do you want to complete the task?"),
            actions: [
              CupertinoDialogAction(
                child: Text("Allow"),
                onPressed: () async {
                  await masterUpdate2(reqNo);
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
    List<String> sParam = [
      reqNo,
      member.user.userId,
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

  fileUpload(String reqNo, String userid, String filetype, String filename,
      String filesrc) async {
    for (int i = 0; i < Imagelist!.length; i++) {
      fileimage_upload(reqNo, userid, filetype, filename, filesrc) async {
        List<String> sParam = [
          reqNo,
          filetype = "F",
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
    }
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

  fileimage_upload2(
      String reqNo, String userid, String filename, String filesrc) async {
    List<String> sParam = [reqNo, member.user.userId, imageName2, base64Image];
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

  final IconTheme = ThemeData(
      colorScheme: ThemeData().colorScheme.copyWith(
            secondary: Colors.green,
          ));

  //Information
  asTable() {
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
            // TableRow(children: [
            //   Container(
            //     padding: EdgeInsets.only(left: 5),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text("작성자",
            //             style: TextStyle(
            //                 color: Colors.black, fontWeight: FontWeight.bold)),
            //         Text(
            //           "홍길동",
            //           style: TextStyle(
            //               color: Colors.grey, fontWeight: FontWeight.bold),
            //         ),
            //       ],
            //     ),
            //   ),
            //   Container(
            //     padding: EdgeInsets.only(left: 5),
            //     child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text("작성일자",
            //               style: TextStyle(
            //                   color: Colors.black, fontWeight: FontWeight.bold)),
            //           Text("2021-08-08",
            //               style: TextStyle(
            //                   color: Colors.grey, fontWeight: FontWeight.bold)),
            //         ]),
            //   )
            // ]),
            TableRow(children: [
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("선주",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    Text(reqName,
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("조선소",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      Text("DSME",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold)),
                    ]),
              )
            ]),
            TableRow(children: [
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("선명",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    Text("MARAN GAS SPETSES",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "호선NO.",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "H2458",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    )
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
                    Text("수주",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    Text("85103",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Calling Port.",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Singapore",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ]),
          ],
        ));
  }

  final bigo = Container(
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
                  "비고",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  "2020.10.25 onboared Singapore",
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

  final contentTable = Container(
    decoration: BoxDecoration(
        border: Border.all(
      width: 2,
      color: Colors.grey,
    )),
  );

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
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  asTable(), //infomation
                  bigo, // 비고
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
                                      itemCount: Imagelist2!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Asset asset = Imagelist2![index];
                                        return AssetThumb(
                                            asset: asset,
                                            width: 200,
                                            height: 200);
                                      },
                                    ),
                                  ),
                            ElevatedButton(
                                onPressed: () {
                                  clearImage2();
                                },
                                child: Text("Clear")),
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
                                          itemCount: Imagelist!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Asset asset = Imagelist![index];
                                            return AssetThumb(
                                                asset: asset,
                                                width: 200,
                                                height: 200);
                                          },
                                        ),
                                      ),
                                ElevatedButton(
                                    onPressed: () {
                                      clearImage();
                                    },
                                    child: Text("Clear")),
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
                      Column(
                        children: [
                          Container(
                            child: ExpansionTile(
                              leading: Icon(
                                Icons.check_rounded,
                              ),
                              title: Text("Confirm Signature",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      height: 250,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1)),
                                      child: Signature(
                                        controller: _controller,
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ConfirmCheck(context),
                                    Container(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.refresh,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _controller.clear();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          width: 70.w,
                          child: ElevatedButton(
                              onPressed: () async {
                                await completeTaskAlert(reqNo);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Schedule(
                                      member: member,
                                    ),
                                  ),
                                );
                              },
                              child: Text("SAVE"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.indigo,
                              )),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ));
    });
  }

  getImage() async {
    List<Asset> resultList = <Asset>[];
    resultList =
        await MultiImagePicker.pickImages(maxImages: 10, enableCamera: true);

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
    resultList2 =
        await MultiImagePicker.pickImages(maxImages: 10, enableCamera: true);

    setState(() {
      Imagelist2 = resultList2;
    });
  }

  clearImage2() async {
    setState(() {
      Imagelist2!.clear();
    });
  }
}
