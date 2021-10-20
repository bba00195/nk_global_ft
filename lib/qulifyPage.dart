import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:sizer/sizer.dart';

import 'common/common.dart';

class qulifyManage extends StatefulWidget {
  final UserManager member;

  qulifyManage({required this.member});

  @override
  _qulifyManageState createState() => _qulifyManageState();
}

class _qulifyManageState extends State<qulifyManage> {
  late UserManager member;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    member = widget.member;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _borderlessTable() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Table(
        border: TableBorder(
            horizontalInside: BorderSide(
          width: 1,
          color: Colors.black,
          style: BorderStyle.solid,
        )),
        children: [
          TableRow(children: [
            Text('Date', style: TextStyle(fontSize: 18)),
            Text('Cert No.', style: TextStyle(fontSize: 18)),
            Center(child: Text('Status', style: TextStyle(fontSize: 18))),
            Center(child: Text('Expires', style: TextStyle(fontSize: 18))),
          ]),
          TableRow(children: [
            Text("12/01/2020"),
            Text("CFA20122015"),
            Center(child: Text("Active")),
            Center(child: Text("11/31/2021")),
          ])
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
            menuName: 'Qulify Management'),
        drawer: NkDrawer(
          globalKey: scaffoldKey,
          member: member,
        ),
        body: Column(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(14, 0, 16, 0),
                  height: 75.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Container(
                    height: 40,
                    width: 100.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 5),
                          height: 30,
                          child: Text(
                            "My Certification",
                            style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          width: 100.w,
                          height: 25,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(color: Colors.indigo),
                          child: Text("Information",
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                "Number",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              child: Text(
                                ": Number",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                "Fist Name",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              child: Text(
                                ": FirstName",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                "Last Name",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              child: Text(
                                ": LastName",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                "Email Address",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              child: Text(
                                ": Email",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          width: 100.w,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                          ),
                          child: Text(
                            "Certifications",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        _borderlessTable(),
                      ],
                    ),
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
                    style: ElevatedButton.styleFrom(primary: Colors.indigo),
                    onPressed: () {},
                    child: Text("Request")),
              ),
            )
          ],
        ),
      );
    });
  }
}
