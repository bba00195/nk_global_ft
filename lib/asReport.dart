import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nk_global_ft/home_page.dart';
import 'package:nk_global_ft/common/common.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:pdf/pdf.dart';

class ASreport extends StatefulWidget {
  final UserManager member;

  ASreport({required this.member});
  @override
  _ASreportState createState() => _ASreportState();
}

class _ASreportState extends State<ASreport> {
  late UserManager member;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final List<String> _valueList = ["작동(성능)불량", "기타", "부품교체", "엔진이상"];
  var _selectedValue = "작동(성능)불량";

  @override
  void initState() {
    super.initState();
    member = widget.member;
  }

  @override
  void dispose() {
    super.dispose();
  }

  final TextStyle blackst =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  final TextStyle greyst =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold);

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

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
          key: scaffoldKey,
          appBar: NkAppBar(
            globalKey: scaffoldKey,
            member: member,
            menuName: 'A/S REPORT',
          ),
          drawer: NkDrawer(
            globalKey: scaffoldKey,
            member: member,
          ),
          body: Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(color: Colors.grey, width: 2.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(3, 2, 0, 1),
                  height: 25,
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
                Container(
                  padding: EdgeInsets.fromLTRB(3, 2, 0, 1),
                  height: 25,
                  width: 100.w,
                  color: Colors.grey,
                  child: Text(
                    "Content",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  height: 7.h,
                  padding: EdgeInsets.fromLTRB(3, 2, 0, 1),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("요청유형",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            "작동 (성능)불량",
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(4),
                    width: 100.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("조치현황",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text(
                          "Fan Mortor 내 Circular Breaker 문제 발생으로 클레임 접수됨",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    )),

                SizedBox(
                  height: 30.w,
                ),
                Center(
                  child: Container(
                      width: 70.w,
                      child: ElevatedButton.icon(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.indigo),
                          onPressed: () {
                            // Navigator.pushReplacement(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (context) => HomePage(),
                            //   ),
                            // );
                          },
                          icon: Icon(Icons.print),
                          label: Text(
                            "PRINT",
                            style: TextStyle(color: Colors.white),
                          ))),
                ),
              ],
            ),
          ));
    });
  }
}
