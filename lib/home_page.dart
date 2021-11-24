// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:nk_global_ft/asDetail2.dart';
import 'package:nk_global_ft/imageConfirm.dart';
import 'package:nk_global_ft/model/image_model.dart';
import 'package:nk_global_ft/model/mainSchedule_model.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';
import 'package:multiselect/multiselect.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common/common.dart';

class HomePage extends StatefulWidget {
  final UserManager member;

  HomePage({
    required this.member,
  });
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserManager member;
  late String reqNo;
  APIService apiService = new APIService();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<MainSchResponseModel> mainSchList = [];
  List<ImageResponseModel> imgVal = [];
  List<ImageResponseModel> imgVal2 = [];

  String imgB = "";
  String imgF = "";
  List<String> BList = [];
  List<String> FList = [];

  List<String> portdrop = [];
  String selport = 'select port';
  String port1 = "";
  String sellist = "";
  List<String> split = [];
  List<String> selected = [];
  String split12 = '';
  DateFormat format2 = DateFormat("yyyy-MM-dd HH:mm:ss");

  DateTime datetime = DateTime.now();
  String strDate = '';

  @override
  void initState() {
    super.initState();
    member = widget.member;
    mainSchSearch();
  }

  @override
  void dispose() {
    super.dispose();
  }

  imageSelect(String reqNo) async {
    List<String> sParam = [reqNo];
    await apiService.getSelect("IMAGE_S1", sParam).then((value) {
      setState(() {
        if (value.image.isNotEmpty) {
          imgVal = value.image;
          for (int i = 0; i < imgVal.length; i++) {
            imgB = imgVal.elementAt(i).fileSrc;
            BList.add(imgB);
          }
        } else {}
      });
    });
  }

  imageSelect2() async {
    List<String> sParam = [reqNo];
    await apiService.getSelect("IMAGE_S2", sParam).then((value) {
      setState(() {
        if (value.image.isNotEmpty) {
          imgVal2 = value.image;
          for (int i = 0; i < imgVal.length; i++) {
            imgF = imgVal.elementAt(i).fileSrc;
            FList.add(imgF);
          }
        } else {}
      });
    });
  }

  mainSchSearch() async {
    List<String> sParam = [member.user.userId];
    await apiService.getSelect("MAIN_S1", sParam).then((value) {
      setState(() {
        if (value.mainSch.isNotEmpty) {
          mainSchList = value.mainSch;
        } else {}
      });
    });
  }

  masterUpdate(String reqNo) async {
    strDate = format2.format(datetime);
    List<String> sParam = [reqNo, member.user.userId, strDate];
    await apiService.getUpdate("MASTER_U1", sParam).then((value) {
      setState(() {
        if (value.result.isNotEmpty) {
          if (value.result.elementAt(0).rsCode == "E") {
            showDialog(
              context: context,
              builder: (_) {
                return Show(message: value.result.elementAt(0).rsMsg);
              },
            );
          } else {
            Navigator.pop(context);

            // CoolAlert.show(
            //     text: "Success on the board.",
            //     context: context,
            //     type: CoolAlertType.success,
            //     autoCloseDuration: Duration(seconds: 2),
            //     onConfirmBtnTap: () {
            //       Navigator.pushReplacement(
            //           context,
            //           CupertinoPageRoute(
            //               builder: (context) => HomePage(member: member)));
            //     });

            // showDialog(
            //   context: context,
            //   builder: (_) {
            //     return Show(message: "Success on the board.");
            //   },
            // );
          }
        } else {
          showDialog(
            context: context,
            builder: (_) {
              return Show(message: "Fail to on the board");
            },
          );
        }
      });
    });
    await mainSchSearch();
  }

  boardCancelUpdate(String reqNo) async {
    List<String> sParam = [
      reqNo,
      member.user.userId,
    ];
    await apiService.getUpdate("BOARD_U1", sParam).then((value) {
      setState(() {
        if (value.result.isNotEmpty) {
          if (value.result.elementAt(0).rsCode == "E") {
            showDialog(
              context: context,
              builder: (_) {
                Navigator.of(context).pop(true);
                return Show(message: value.result.elementAt(0).rsMsg);
              },
            );
          } else {
            Navigator.of(context).pop(true);
            CoolAlert.show(
                context: context,
                type: CoolAlertType.success,
                text: "Cancellation complete");
            // showDialog(
            //   context: context,
            //   builder: (_) {
            //     return Show(message: "Cancellation complete");
            //   },
            // );
          }
        } else {
          showDialog(
            context: context,
            builder: (_) {
              Navigator.of(context).pop(true);
              return Show(message: "Fail to cancellation");
            },
          );
        }
      });
    });
    await mainSchSearch();
  }

  mainSchPopup(String reqNo, String vesselName, String startDate,
      String endDate, String mgtStatus) {
    String statusName = "Wait on board";

    Color sColor = Colors.green;

    if (mgtStatus == "20") {
      statusName = "Wait on board";
      sColor = Color.fromRGBO(8, 93, 216, 1.0);
    } else if (mgtStatus == "30") {
      statusName = "On board";
      sColor = Color.fromRGBO(63, 198, 68, 1.0);
    }

    return showDialog(
      context: context,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(15),
            height: 175,
            margin: EdgeInsets.symmetric(horizontal: 35),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: AutoSizeText(
                        vesselName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        minFontSize: 14,
                        maxLines: 1,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: sColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: AutoSizeText(
                        statusName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        minFontSize: 18,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      "$startDate ~ $endDate",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(169, 169, 169, 1.0),
                      ),
                      minFontSize: 12,
                      maxLines: 1,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () async {
                          await boardCancelUpdate(reqNo);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          constraints: BoxConstraints(
                            minHeight: 35,
                          ),
                          child: AutoSizeText(
                            "Cancel the ride",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            minFontSize: 14,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () async {
                          await imageSelect(reqNo);

                          BList.isEmpty
                              ? Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => ASmanagement2(
                                        member: member,
                                        reqNo: reqNo,
                                        split12: sellist),
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ImageConfirm(
                                          reqNo: reqNo,
                                          member: member,
                                          split12: sellist)));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          constraints: BoxConstraints(
                            minHeight: 35,
                          ),
                          child: AutoSizeText(
                            "Work",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            minFontSize: 14,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          constraints: BoxConstraints(
                            minHeight: 35,
                          ),
                          child: AutoSizeText(
                            "Close",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            minFontSize: 14,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget schContainer(
      String reqNo,
      String vesselName,
      String startDate,
      String endDate,
      String mgtStatus,
      String reqport,
      String reqtype,
      String reqQuantity) {
    String statusName = "Wait on board";
    Color sColor = Colors.green;
    late Function sFunc;
    split = reqport.split('/');

    if (mgtStatus == "20") {
      statusName = "Wait on board";
      sColor = Color.fromRGBO(8, 93, 216, 1.0);
    } else if (mgtStatus == "30") {
      statusName = "On board";
      sColor = Color.fromRGBO(63, 198, 68, 1.0);
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: RoundedExpansionTile(
          leading: CircleAvatar(
            backgroundColor: sColor,
          ),
          title: Text(
            statusName,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            vesselName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          children: [
            Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(bottom: 15, left: 10, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: 120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Icon(
                          Icons.calendar_today,
                          size: 18,
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: AutoSizeText(
                          "ETA : " + startDate,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 18,
                          maxLines: 1,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(""),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: Text("")),
                      Expanded(
                        flex: 8,
                        child: AutoSizeText(
                          "ETD : " + endDate,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 18,
                          maxLines: 1,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(""),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Icon(Icons.anchor),
                      ),
                      Expanded(
                        flex: 8,
                        child: AutoSizeText(
                          reqport,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 18,
                          maxLines: 3,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(""),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Icon(Icons.work),
                      ),
                      Expanded(
                        flex: 8,
                        child: AutoSizeText(
                          reqtype,
                          style: TextStyle(
                            fontSize: 1,
                            fontWeight: FontWeight.bold,
                          ),
                          minFontSize: 13,
                          maxLines: 3,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: AutoSizeText(
                          reqQuantity,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo,
                        ),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: AutoSizeText(
                              "Progress",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              minFontSize: 18,
                              maxLines: 1,
                            )),
                        onPressed: () async {
                          // var split12 = reqport.split('/');

                          if (mgtStatus == "20") {
                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.custom,
                                text: "Select Port",
                                confirmBtnText: "On Board",
                                confirmBtnColor: Colors.indigo,
                                barrierDismissible: false,
                                widget: DropDownMultiSelect(
                                    options: split,
                                    selectedValues: selected,
                                    onChanged: (List<String> x) {
                                      setState(() {
                                        selected = x;
                                        sellist = selected[0];
                                      });
                                    },
                                    whenEmpty: 'select port'),
                                onConfirmBtnTap: () async {
                                  await masterUpdate(reqNo);
                                });
                          } else if (mgtStatus == "30") {
                            mainSchPopup(reqNo, vesselName, startDate, endDate,
                                mgtStatus);
                          }
                        },
                      ),
                      // InkWell(
                      //   onTap: () async {
                      //     if (mgtStatus == "20") {
                      //       await masterUpdate(reqNo);
                      //     } else if (mgtStatus == "30") {
                      //       mainSchPopup(reqNo, vesselName, startDate, endDate,
                      //           mgtStatus);
                      //     }
                      //   },
                      //   child: Container(
                      //     padding:
                      //         EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      //     decoration: BoxDecoration(
                      //       color: Color.fromRGBO(160, 160, 160, 1.0),
                      //       borderRadius: BorderRadius.all(
                      //         Radius.circular(15),
                      //       ),
                      //     ),
                      //     constraints: BoxConstraints(
                      //       minHeight: 35,
                      //     ),
                      //     child: AutoSizeText(
                      //       "Progress",
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //         fontSize: 20,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.white,
                      //       ),
                      //       minFontSize: 16,
                      //       maxLines: 1,
                      //     ),
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar:
          NkAppBar(globalKey: scaffoldKey, member: member, menuName: 'Main'),
      drawer: NkDrawer(globalKey: scaffoldKey, member: member),
      bottomNavigationBar: nkNaviBottomBar(
          globalKey: scaffoldKey, member: member, selectedIndex: 0),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: () {
          setState(() {
            mainSchSearch();
          });
          _refreshController.refreshCompleted();
        },
        onLoading: () {
          setState(() {
            mainSchSearch();
            _refreshController.loadComplete();
          });
          _refreshController.refreshCompleted();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            color: Color.fromRGBO(244, 244, 244, 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (int i = 0; i < mainSchList.length; i++)
                  schContainer(
                      mainSchList.elementAt(i).reqNo,
                      mainSchList.elementAt(i).vesselName,
                      mainSchList.elementAt(i).startDate,
                      mainSchList.elementAt(i).endDate,
                      mainSchList.elementAt(i).mgtStatus,
                      mainSchList.elementAt(i).reqport,
                      mainSchList.elementAt(i).reqtype,
                      mainSchList.elementAt(i).reqQuantity),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
