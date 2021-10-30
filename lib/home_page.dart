// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:nk_global_ft/model/mainSchedule_model.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';

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
  APIService apiService = new APIService();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<MainSchResponseModel> mainSchList = [];

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

  mainSchSearch() async {
    List<String> sParam = [
      member.user.userId,
    ];
    await apiService.getSelect("MAIN_S1", sParam).then((value) {
      setState(() {
        if (value.mainSch.isNotEmpty) {
          mainSchList = value.mainSch;
        } else {}
      });
    });
  }

  masterUpdate(String reqNo) async {
    List<String> sParam = [
      reqNo,
      member.user.userId,
    ];
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
            showDialog(
              context: context,
              builder: (_) {
                return Show(message: "Success on the board.");
              },
            );
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
            showDialog(
              context: context,
              builder: (_) {
                return Show(message: "Cancellation complete");
              },
            );
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
                            color: Color.fromRGBO(247, 247, 247, 1.0),
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
                              color: Color.fromRGBO(111, 111, 111, 1.0),
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
                      child: Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(247, 247, 247, 1.0),
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
                            color: Color.fromRGBO(111, 111, 111, 1.0),
                          ),
                          minFontSize: 14,
                          maxLines: 1,
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
                            color: Color.fromRGBO(247, 247, 247, 1.0),
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
                              color: Color.fromRGBO(111, 111, 111, 1.0),
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

  Widget schContainer(String reqNo, String vesselName, String startDate,
      String endDate, String mgtStatus) {
    String statusName = "Wait on board";
    Color sColor = Colors.green;
    late Function sFunc;

    if (mgtStatus == "20") {
      statusName = "Wait on board";
      sColor = Color.fromRGBO(8, 93, 216, 1.0);
    } else if (mgtStatus == "30") {
      statusName = "On board";
      sColor = Color.fromRGBO(63, 198, 68, 1.0);
    }

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
              ),
            ],
          ),
          Container(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: sColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
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
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () async {
                    if (mgtStatus == "20") {
                      await masterUpdate(reqNo);
                    } else if (mgtStatus == "30") {
                      mainSchPopup(
                          reqNo, vesselName, startDate, endDate, mgtStatus);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(247, 247, 247, 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    constraints: BoxConstraints(
                      minHeight: 35,
                    ),
                    child: AutoSizeText(
                      "Progress",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(111, 111, 111, 1.0),
                      ),
                      minFontSize: 16,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
                      mainSchList.elementAt(i).mgtStatus),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
