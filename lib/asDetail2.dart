import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nk_global_ft/asReport.dart';
import 'package:nk_global_ft/home_page.dart';
import 'package:signature/signature.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:sizer/sizer.dart';

import 'common/common.dart';

class ASmanagement2 extends StatefulWidget {
  final UserManager member;
  final String reqNo;

  ASmanagement2({required this.member, required this.reqNo});
  @override
  _ASmanagementState2 createState() => _ASmanagementState2();
}

class _ASmanagementState2 extends State<ASmanagement2> {
  APIService apiService = new APIService();
  late UserManager member;
  late String reqNo;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  XFile? file;
  XFile? file2;

  late ImagePicker _picker = ImagePicker();
  late ImagePicker _picker2 = ImagePicker();
  SignatureController _controller = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.grey,
  );

  @override
  void initState() {
    super.initState();
    member = widget.member;
    reqNo = widget.reqNo;
    _controller.addListener(() {
      print('값 변경됨.');
    });
  }

  @override
  void dispose() {
    super.dispose();
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

  filePickerCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      file = XFile(pickedFile!.path);
    });
  }

  void filePickerGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = image;
    });
  }

  filePickerCamera2() async {
    final pickedFile2 = await _picker2.pickImage(source: ImageSource.camera);
    setState(() {
      file2 = XFile(pickedFile2!.path);
    });
  }

  void filePickerGallery2() async {
    final XFile? image = await _picker2.pickImage(source: ImageSource.gallery);
    setState(() {
      file2 = image;
    });
  }

  final IconTheme = ThemeData(
      colorScheme: ThemeData().colorScheme.copyWith(
            secondary: Colors.green,
          ));

  //Information
  final asTable = Padding(
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
                  Text("작성자",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  Text(
                    "홍길동",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("작성일자",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    Text("2021-08-08",
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
                  Text("선주",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  Text("MARAN",
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
                            color: Colors.black, fontWeight: FontWeight.bold)),
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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Container(
            child: Wrap(children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Gallery"),
                onTap: () {
                  filePickerGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    filePickerCamera();
                    Navigator.of(context).pop();
                  })
            ]),
          ));
        });
  }

  void _showPicker2(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Container(
            child: Wrap(children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Gallery"),
                onTap: () {
                  filePickerGallery2();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    filePickerCamera2();
                    Navigator.of(context).pop();
                  })
            ]),
          ));
        });
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
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  asTable, //infomation
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
                          title: Text("Photos",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _showPicker2(context);
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 1)),
                                    child: Center(
                                        child: Center(
                                      child: file2 == null
                                          ? Icon(
                                              CupertinoIcons.add,
                                              size: 50,
                                            )
                                          : Image.file(File(file2!.path)),
                                    )),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _showPicker(context);
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 1)),
                                    child: Center(
                                        child: file == null
                                            ? Icon(
                                                CupertinoIcons.add,
                                                size: 50,
                                              )
                                            : Image.file(File(file!.path))),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Before",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20)),
                                  Text("After",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20)),
                                ],
                              ),
                            )
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
                                Column(
                                  children: [
                                    Container(
                                      child: IconButton(
                                        icon: Icon(Icons.refresh),
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
                        height: 15,
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
                                    builder: (context) => HomePage(
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
}
