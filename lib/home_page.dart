// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:nk_global_ft/api/api_oceanLook.dart';
import 'package:nk_global_ft/asDetail2.dart';
import 'package:nk_global_ft/imageConfirm.dart';
import 'package:nk_global_ft/main.dart';
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
  DateTime? backpressbtntime;
  late UserManager member;
  late String reqNo;
  APIService apiService = new APIService();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late SharedPreferences _prefs;

  List<MainSchResponseModel> mainSchList = [];
  List<ImageResponseModel> imgVal = [];
  List<ImageResponseModel> imgVal2 = [];
  String storedPort = '';
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
  DateTime? etadate;
  String etaval = '';
  String etareslut = '';

  List etavalList = [];
  DateTime datetime = DateTime.now();
  String strDate = '';

  APIocean apiOcean = new APIocean();
  var oceanList;
  List vesselList = [];
  List properties = [];
  List imolist = [];
  List<int> mmsilist = [];
  List etalist = [];
  Map? map1;
  List eta1 = [];

  @override
  void initState() {
    oceanApi();
    member = widget.member;
    mainSchSearch();
    loadSelport();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loadSelport() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      storedPort = (_prefs.getString('selport') ?? '');
    });
  }

  imageSelect(String reqNo) async {
    List<String> sParam = [reqNo, member.user.userId];
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
    List<String> sParam = [reqNo, member.user.userId];
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

  oceanApi() async {
    await apiOcean.getOcean().then((value) {
      oceanList = value["features"];
      if (value["features"].isNotEmpty) {
        vesselList.clear();
        imolist.clear();
        etalist.clear();

        for (int i = 0; i < oceanList.length; i++) {
          imolist.add(oceanList[i]["properties"]["ec_imo"]);
          etalist.add(oceanList[i]["properties"]["ec_eta"]);
        }

        // for (int j = 0; j < vesselList.length; j++) {
        //   imolist.add(vesselList[j]["ec_imo"]);
        // }
        // for (int k = 0; k < imolist.length; k++) {
        //   etalist.add(vesselList[k]["ec_eta"]);
        // }
        map1 = Map.fromIterables(imolist, etalist);
      }
    });
  }

  mainSchSearch() async {
    List<String> sParam = [member.user.userId];
    await apiService.getSelect("MAIN_S1", sParam).then((value) {
      setState(() {
        if (value.mainSch.isNotEmpty) {
          mainSchList = value.mainSch;
          for (int i = 0; i < mainSchList.length; i++) {
            eta1.add(mainSchList.elementAt(i).imono);
          }
        } else {}
      });
    });
    await oceanApi();
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

  // showeta() {
  //   if (map1!.containsKey(eta1)) {
  //     for (int i = 0; i < map1!.length; i++) {
  //       if (imolist[i] == eta1) {
  //         etaval = etalist[i];

  //         return etaval;
  //       }
  //     }
  //   }
  // }

  // shoeta2() {
  //   for (int i = 0; i < mainSchList.length; i++) {
  //     for (int j = 0; j < map1!.length; j++) {
  //       if (map1!.containsKey(eta1[i])) {
  //         if (imolist[j] == eta1[i]) {
  //           // etaval = etalist[j];
  //           etavalList.add(etalist[j]);
  //           setState(() {
  //             // etaval = etavalList[i];
  //           });
  //         }
  //       }
  //     }
  //   }
  // }

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
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            maxFontSize: 13,
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
                                        split12: storedPort),
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ImageConfirm(
                                          reqNo: reqNo,
                                          member: member,
                                          split12: storedPort)));
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
  // Widget setConEta(String etaval) {
  //   return
  // }

  Widget schContainer(
    String reqNo,
    String vesselName,
    String startDate,
    String endDate,
    String mgtStatus,
    String imono,
    String reqport,
    String reqtype,
    String reqQuantity,
    String mmsino,
  ) {
    String statusName = "Wait on board";
    String oneport = '';

    Color sColor = Colors.green;
    late Function sFunc;
    // split = reqport.split('/');

    // if (reqport.contains('/') == true) {
    //   split = reqport.split('/');
    // } else {
    //   oneport = reqport;
    // }

    String etaValue = '';
    split.clear();

    if (mgtStatus == "20") {
      statusName = "Wait on board";
      sColor = Color.fromRGBO(8, 93, 216, 1.0);
    } else if (mgtStatus == "30") {
      statusName = "On board";
      sColor = Color.fromRGBO(63, 198, 68, 1.0);
    }

    for (int i = 0; i < imolist.length; i++) {
      if (imono == imolist[i]) {
        etaValue = etalist[i];
      }
    }

    for (int j = 0; j < mainSchList.length; j++) {
      split.add(mainSchList.elementAt(j).reqport);
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
                  etaValue == ''
                      ? Row(
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
                                "ETA : " + "Pull to refresh",
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
                        )
                      : Row(
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
                                "ETA : " +
                                    etaValue.substring(0, 2) +
                                    "/" +
                                    etaValue.substring(2, 4) +
                                    ",  " +
                                    etaValue.substring(4, 6) +
                                    ":" +
                                    etaValue.substring(6),
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
                          split = reqport.split('/');

                          if (mgtStatus == "20") {
                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.custom,
                                text: "Select Port",
                                confirmBtnText: "On Board",
                                confirmBtnColor: Colors.indigo,
                                barrierDismissible: true,
                                widget: DropDownMultiSelect(
                                    options: split,
                                    selectedValues: selected,
                                    onChanged: (List<String> x) {
                                      setState(() {
                                        selected = x;
                                        sellist = selected[0];
                                        _prefs.setString('selport', sellist);
                                      });
                                    },
                                    whenEmpty: 'select port'),
                                onConfirmBtnTap: () async {
                                  await masterUpdate(reqNo);
                                });
                          } else if (mgtStatus == "30") {
                            await mainSchPopup(reqNo, vesselName, startDate,
                                endDate, mgtStatus);
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

  Future<bool> _onwillPop() async {
    DateTime now = DateTime.now();
    if (backpressbtntime == null ||
        now.difference(backpressbtntime!) > Duration(seconds: 2)) {
      backpressbtntime = now;
      Fluttertoast.showToast(msg: 'One more tap to Exit app Alert');
      return Future.value(false);
    }
    return (await showDialog(
      context: context,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            height: 250,
            margin: EdgeInsets.only(
              left: 35,
              right: 35,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/nk_logo.jpg'),
                      fit: BoxFit.none,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(),
                  child: Text(
                    'Close the Application?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                          ),
                        ),
                        height: 50,
                        child: TextButton(
                          child: Text(
                            "No",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'NotoSansKR',
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(63, 81, 181, 1.0),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        height: 50,
                        child: TextButton(
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'NotoSansKR',
                            ),
                          ),
                          onPressed: () => SystemNavigator.pop(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
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
      body: WillPopScope(
        onWillPop: _onwillPop,
        child: SmartRefresher(
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
                      mainSchList.elementAt(i).imono,
                      mainSchList.elementAt(i).reqport,
                      mainSchList.elementAt(i).reqtype,
                      mainSchList.elementAt(i).reqQuantity,
                      mainSchList.elementAt(i).mmsino,
                      // etaval = etavalList[i],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
