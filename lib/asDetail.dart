import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nk_global_ft/asDetail2.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:sizer/sizer.dart';

import 'common/common.dart';

class ASmanagement extends StatefulWidget {
  final UserManager member;
  final String reqNo;

  ASmanagement({required this.member, required this.reqNo});
  @override
  _ASmanagementState createState() => _ASmanagementState();
}

class _ASmanagementState extends State<ASmanagement> {
  late UserManager member;
  late String reqNo;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final fixedEditContiroller = TextEditingController();
  final List<String> _valueList = ["작동(성능)불량", "기타", "부품교체", "엔진이상"];
  var _selectedValue = "작동(성능)불량";

  @override
  void initState() {
    super.initState();
    member = widget.member;
    reqNo = widget.reqNo;
  }

  @override
  void dispose() {
    super.dispose();
  }

  //information Table
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
    //
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
          resizeToAvoidBottomInset: false,
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
          body: GestureDetector(
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
                    padding: EdgeInsets.fromLTRB(3, 2, 0, 1),
                    height: 35.h,
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
                            SizedBox(
                              child: DropdownButton(
                                iconSize: 30.0,
                                value: _selectedValue,
                                items: _valueList.map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedValue = value as String;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 250,
                              padding: EdgeInsets.all(4.0),
                              child: TextField(
                                autocorrect: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '요청 사항'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      width: 70.w,
                      child: ElevatedButton(
                          onPressed: () {
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         ASmanagement2(member: member),
                            //   ),
                            // );
                          },
                          child: Text("SAVE"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.indigo,
                          )),
                    ),
                  )
                ],
              ),
            ),
          ));
    });
  }
}
