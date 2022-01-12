// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_group_button/flutter_group_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multiselect/multiselect.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:nk_global_ft/asDetail.dart';
import 'package:nk_global_ft/asDetail2.dart';
import 'package:nk_global_ft/imageConfirm.dart';
import 'package:nk_global_ft/model/schedule_model.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cool_alert/cool_alert.dart';
import 'common/common.dart';
import 'model/image_model.dart';
import 'util.dart';

class Schedule extends StatefulWidget {
  final UserManager member;

  Schedule({
    required this.member,
  });
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime? backpressbtntime;
  late UserManager member;
  APIService apiService = new APIService();
  late SharedPreferences _prefs;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  late final PageController _pageController;
  late final ValueNotifier<List<Event>> _selectedEvents;
  late final ValueNotifier<List<Event>> _selectedMgtEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final ValueNotifier<DateTime> headDay = ValueNotifier(DateTime.now());

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime datetime3 = DateTime.now();
  DateFormat df3 = DateFormat("yyyy-MM-dd HH:mm:ss");

  String strDate = '';
  String storedPort = '';

  List<ScheduleResponseModel> scheduleValue = [];

  List<ImageResponseModel> imgVal = [];
  List<ImageResponseModel> imgVal2 = [];

  String imgB = "";
  String imgF = "";
  List<String> BList = [];
  List<String> FList = [];

  List<String> split = [];
  List<String> selected = [];

  List<String> scheduleStarts = [];
  List<List<Event>> scheduleEventList = [];
  List<List<Event>> mgtStatusEventList = [];
  Map<DateTime, List<Event>> _events = {};
  Map<DateTime, List<Event>> _mgtEvents = {};

  late DateTime dateNow;
  int sDay = 0;

  String text1 = "";
  String text2 = "승선";

  String sellist = '';
  var changeColor = Colors.indigo;

  @override
  void initState() {
    super.initState();
    member = widget.member;
    dateNow = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(DateTime.now()) + ' 00:00:00.000Z');
    scheduleSearch();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _selectedMgtEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    loadSelport();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _selectedMgtEvents.dispose();
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

  scheduleSearch() async {
    scheduleStarts = [];
    scheduleEventList = [];
    mgtStatusEventList = [];
    _events = {};
    _mgtEvents = {};

    List<String> sParam = [
      member.user.userId,
      DateFormat('yyyy').format(dateNow),
      DateFormat('MM').format(dateNow)
    ];
    await apiService.getSelect("CALENDAR_S1", sParam).then((value) {
      setState(() {
        if (value.schedule.isNotEmpty) {
          scheduleValue = value.schedule;
          List<Event> scheduleEvent = [];
          List<Event> mgtStatusEvent = [];
          for (int i = 0; i < scheduleValue.length; i++) {
            if (i == (scheduleValue.length) - 1) {
              scheduleStarts.add(scheduleValue.elementAt(i).date);
              scheduleEvent.add(
                  Event(scheduleValue.elementAt(i).reqVesselName.toString()));
              mgtStatusEvent
                  .add(Event(scheduleValue.elementAt(i).mgtStatus.toString()));
              scheduleEventList.add(scheduleEvent);
              mgtStatusEventList.add(mgtStatusEvent);
              scheduleEvent = [];
              mgtStatusEvent = [];
            } else {
              if (scheduleValue.elementAt(i).date ==
                  scheduleValue.elementAt(i + 1).date) {
                scheduleEvent.add(
                    Event(scheduleValue.elementAt(i).reqVesselName.toString()));
                mgtStatusEvent.add(
                    Event(scheduleValue.elementAt(i).mgtStatus.toString()));
              } else {
                scheduleStarts.add(scheduleValue.elementAt(i).date);
                scheduleEvent.add(
                    Event(scheduleValue.elementAt(i).reqVesselName.toString()));
                mgtStatusEvent.add(
                    Event(scheduleValue.elementAt(i).mgtStatus.toString()));
                scheduleEventList.add(scheduleEvent);
                mgtStatusEventList.add(mgtStatusEvent);
                scheduleEvent = [];
                mgtStatusEvent = [];
              }
            }
          }
          for (int i = 0; i < scheduleStarts.length; i++) {
            _events.putIfAbsent(
                DateTime.parse((scheduleStarts[i] + ' 00:00:00.000Z')),
                () => scheduleEventList[i]);
            _mgtEvents.putIfAbsent(
                DateTime.parse((scheduleStarts[i] + ' 00:00:00.000Z')),
                () => mgtStatusEventList[i]);
          }
        } else {
          print('fail');
        }
        _onDaySelected(dateNow, dateNow);
      });
    });
  }

  masterUpdate(String reqNo) async {
    strDate = df3.format(datetime3);
    List<String> sParam = [reqNo, member.user.userId, strDate];
    await apiService.getUpdate("MASTER_U1", sParam).then((value) {
      setState(() {
        if (value.result.isNotEmpty) {
          if (value.result.elementAt(0).rsCode == "E") {
            Show(message: value.result.elementAt(0).rsMsg);
          } else {
            Navigator.pop(context);
          }
        } else {
          Show(message: "Fail to on the board");
        }
      });
    });
    await scheduleSearch();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return _events[day] ?? [];
  }

  List<Event> _getMgtEventsForDay(DateTime day) {
    return _mgtEvents[day] ?? [];
  }

  String schSubject = "";
  String schUserId = "";
  String mgtStatus = "";
  String reqNo = "";
  String reqport = "";

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      schSubject = "";
      schUserId = "";
      reqNo = "";
      reqport = "";
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });

    _selectedEvents.value = _getEventsForDay(selectedDay);
    _selectedMgtEvents.value = _getMgtEventsForDay(selectedDay);
    for (int i = 0; i < _selectedEvents.value.length; i++) {
      for (int j = 0; j < scheduleValue.length; j++) {
        if ((_selectedEvents.value[i].title ==
                scheduleValue.elementAt(j).reqVesselName.toString()) &&
            (DateFormat('yyyy-MM-dd').format(selectedDay) ==
                scheduleValue.elementAt(j).date.toString())) {
          schSubject = scheduleValue.elementAt(j).reqVesselName;
          schUserId = scheduleValue.elementAt(j).userId;
          mgtStatus = scheduleValue.elementAt(j).mgtStatus;
          reqNo = scheduleValue.elementAt(j).reqNo;
          reqport = scheduleValue.elementAt(j).reqport;
        }
      }
    }
  }

  onBoardAlert(BuildContext context, List<Event> value, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Would you like to register for boarding?"),
            actions: [
              CupertinoDialogAction(
                child: Text("Allow"),
                onPressed: () async {
                  value[index].isSelected = true;
                  await masterUpdate(reqNo);
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
                  value[index].isSelected = false;
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  buildEventsMarkerNum(DateTime date, List events) {
    if (date.month.toString() ==
        (DateFormat('MM').format(dateNow)).toString()) {
      return buildCalendarDayMarker('${events.length}', Colors.blue);
    } else {
      return buildCalendarDayMarker(
          '${events.length}', Color.fromRGBO(33, 150, 243, 0.6));
    }
  }

  buildCalendarDayMarker(String text, Color backColor) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: backColor,
        ),
        width: 59,
        height: 13);
  }

  boxScheculeCalendar() {
    return TableCalendar<Event>(
      headerVisible: false,
      // headerStyle: HeaderStyle(
      //   // headerMargin:
      //   //     EdgeInsets.only(left: 40, top: 10, right: 40, bottom: 10),
      //   titleCentered: true,
      //   formatButtonVisible: false,
      //   leftChevronIcon: Icon(Icons.arrow_left),
      //   rightChevronIcon: Icon(Icons.arrow_right),
      //   titleTextStyle: const TextStyle(fontSize: 17.0),
      // ),
      firstDay: DateTime.utc(1950, 01, 01),
      lastDay: DateTime.utc(2050, 01, 01),
      focusedDay: headDay.value,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, _events) {
          final children = <Widget>[];
          if (_events.isNotEmpty) {
            children.add(
              Positioned(
                bottom: 1,
                child: buildEventsMarkerNum(date, _events),
              ),
            );
          }
          for (int i = 0; i < children.length; i++) return children[i];
        },
        selectedBuilder: (context, date, _) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.pink[200],
                borderRadius: BorderRadius.circular(22),
              ),
              width: 40,
              height: 40,
              child: Center(
                child: Text(date.day.toString(),
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          );
        },
      ),
      headerStyle: HeaderStyle(
        titleTextStyle:
            const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarFormat: _calendarFormat,
      eventLoader: _getEventsForDay,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableCalendarFormats: const {
        CalendarFormat.month: '월간',
        // CalendarFormat.week: '주간',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        holidayTextStyle: TextStyle().copyWith(color: Colors.blue[800]),
        weekendTextStyle: TextStyle().copyWith(color: Colors.red),
      ),
      onCalendarCreated: (controller) => _pageController = controller,
      onDaySelected: _onDaySelected,
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        headDay.value = focusedDay;
        _focusedDay = focusedDay;
      },
    );
  }

  icnScheduleList(int mgtStatusVal) {
    IconData sIcon = Icons.directions_boat_filled_rounded;
    Color sColor = Colors.indigo;
    if (mgtStatusVal == 20) {
      sIcon = Icons.directions_boat_filled_rounded;
      sColor = Colors.indigo;
    } else if (mgtStatusVal == 30) {
      sIcon = Icons.build_rounded;
      sColor = Colors.green;
    } else {
      sIcon = Icons.construction;
      sColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.fromLTRB(10, 35, 0, 10),
      child: CircleAvatar(
        backgroundColor: sColor,
        child: Icon(sIcon, color: Colors.white),
      ),
    );
  }

  ctnScheduleList(int mgtStatusVal) {
    String sText = "        wait on board  ";
    Color sColor = Colors.indigo;
    if (mgtStatusVal == 20) {
      sText = "        wait on board  ";
      sColor = Colors.indigo;
    } else if (mgtStatusVal == 30) {
      sText = "        On boarding  ";
      sColor = Colors.green;
    } else {
      sText = "        Finish task  ";
      sColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.fromLTRB(10, 35, 0, 10),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: sColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        sText,
        style:
            TextStyle(color: sColor, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
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
    await scheduleSearch();
  }

  btnScheduleList(int mgtStatusVal, List<Event> value, int index,
      BuildContext context, String reqport) {
    String sText = "Onboard";
    Color sColor = Colors.indigo;
    if (mgtStatusVal == 20) {
      sText = "Onboard";
      sColor = Colors.indigo;
    } else if (mgtStatusVal == 30) {
      sText = "Proceeding";
      sColor = Colors.green;
    } else {
      sText = "Finish";
      sColor = Colors.grey;
    }

    return ElevatedButton(
      onPressed: () {
        split = reqport.split('/');
        if (sText == "Onboard") {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.custom,
              title: "Select Port",
              confirmBtnText: "On Board",
              confirmBtnColor: Colors.indigo,
              barrierDismissible: true,
              widget: RadioGroup(
                children: [
                  for (int i = 0; i < split.length; i++) Text(split[i]),
                ],
                groupItemsAlignment: GroupItemsAlignment.column,
                defaultSelectedItem: -1,
                mainAxisAlignment: MainAxisAlignment.center,
                textBeforeRadio: false,
                onSelectionChanged: (selection) {
                  setState(() {
                    storedPort = split[selection!];
                    print(storedPort);
                  });
                },
              ),
              onConfirmBtnTap: () async {
                _prefs.setString('selport', storedPort);
                await masterUpdate(reqNo);
              });
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return CupertinoAlertDialog(
          //         title: Text("Would you like to register for boarding?"),
          //         actions: [
          //           CupertinoDialogAction(
          //             child: Text("Allow"),
          //             onPressed: () async {
          //               value[index].isSelected = true;
          //               await masterUpdate(reqNo);
          //               Navigator.of(context).pop();
          //             },
          //           ),
          //           CupertinoDialogAction(
          //             child: Text("Deny"),
          //             onPressed: () {
          //               value[index].isSelected = false;
          //               Navigator.of(context).pop();
          //             },
          //           )
          //         ],
          //       );
          //     });
        } else if (sText == "Proceeding") {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.confirm,
              text: 'Route A/S Report Page or Cancel the On Board',
              confirmBtnText: "Report",
              cancelBtnText: "Cancellation",
              cancelBtnTextStyle: TextStyle(
                color: Colors.black,
              ),
              confirmBtnColor: Colors.indigo,
              onConfirmBtnTap: () async {
                await imageSelect(reqNo);
                BList.isEmpty
                    ? Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ASmanagement2(
                            member: member,
                            reqNo: reqNo,
                            split12: storedPort,
                          ),
                        ),
                      )
                    : Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ImageConfirm(
                                reqNo: reqNo, member: member, split12: '')));
              },
              onCancelBtnTap: () {
                boardCancelUpdate(reqNo);
              });
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return CupertinoAlertDialog(
          //         title: Text("Cancel the on board? Or A/S Report register"),
          //         actions: [
          //           CupertinoDialogAction(
          //             child: Text("Cancel onboard"),
          //             onPressed: () {
          //               boardCancelUpdate(reqNo);
          //             },
          //           ),
          //           CupertinoDialogAction(
          //             child: Text("Register"),
          //             onPressed: () {
          //               Navigator.push(
          //                   context,
          //                   CupertinoPageRoute(
          //                       builder: (context) => ASmanagement2(
          //                           member: member, reqNo: reqNo)));
          //             },
          //           )
          //         ],
          //       );
          //     });
          // Navigator.push(
          //     context,
          //     CupertinoPageRoute(
          //         builder: (context) => ASmanagement2(
          //               member: member,
          //               reqNo: reqNo,
          //             )));
        } else if (sText == "Finish") {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              text: 'Route A/S Report Page',
              onConfirmBtnTap: () {
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ImageConfirm(
                            reqNo: reqNo,
                            member: member,
                            split12: storedPort)));
              });
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return CupertinoAlertDialog(
          //         title: Text("Route A/S Result page"),
          //         actions: [
          //           CupertinoDialogAction(
          //             child: Text("yes"),
          //             onPressed: () {
          //               Navigator.pushReplacement(
          //                   context,
          //                   CupertinoPageRoute(
          //                       builder: (context) => ImageConfirm(
          //                           reqNo: reqNo, member: member)));
          //             },
          //           ),
          //           CupertinoDialogAction(
          //             child: Text("No"),
          //             onPressed: () {
          //               Navigator.pop(context);
          //             }, // 수정
          //           ),
          //         ],
          //       );
          //     });
        }
      },
      child: Text(sText),
      style: ElevatedButton.styleFrom(primary: sColor),
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
      appBar: NkAppBar(
        globalKey: scaffoldKey,
        member: member,
        menuName: 'Schedule',
      ),
      drawer: NkDrawer(
        globalKey: scaffoldKey,
        member: member,
      ),
      bottomNavigationBar: nkNaviBottomBar(
          globalKey: scaffoldKey, member: member, selectedIndex: 2),
      body: WillPopScope(
        child: Column(
          children: [
            ValueListenableBuilder<DateTime>(
              valueListenable: headDay,
              builder: (context, value, _) {
                return _CalendarHeader(
                  focusedDay: value,
                  onLeftArrowTap: () {
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                    setState(() {
                      sDay -= 30;
                      dateNow = DateTime.parse(DateFormat('yyyy-MM-dd').format(
                              DateTime.now().add(Duration(days: sDay))) +
                          ' 00:00:00.000Z');
                      scheduleSearch();
                      _onDaySelected(dateNow, dateNow);
                    });
                  },
                  onRightArrowTap: () {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                    setState(() {
                      sDay += 30;
                      dateNow = DateTime.parse(DateFormat('yyyy-MM-dd').format(
                              DateTime.now().add(Duration(days: sDay))) +
                          ' 00:00:00.000Z');
                      scheduleSearch();
                      _onDaySelected(dateNow, dateNow);
                    });
                  },
                );
              },
            ),
            boxScheculeCalendar(),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: Row(
                children: [
                  Text(
                    "A/S Schedule",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            // if (int.parse(
                            //         _selectedMgtEvents.value[index].toString()) <
                            //     30) {
                            //   setState(() {
                            //     onBoardAlert(context, value, index);
                            //   });
                            // } else {
                            //   Navigator.push(
                            //     context,
                            //     CupertinoPageRoute(
                            //       builder: (context) => ASmanagement2(
                            //         member: member,
                            //         reqNo: reqNo,
                            //       ),
                            //     ),
                            //   );
                            // }
                          },
                          child: Container(
                              width: 200,
                              height: 150,
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 4,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    )
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                      selected: value[index].isSelected,
                                      title: Text(
                                        "${value[index]}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      trailing: Text(
                                        "${_selectedDay.toString().substring(0, 10)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )
                                      // trailing: (int.parse(_selectedMgtEvents
                                      //             .value[index]
                                      //             .toString()) <
                                      //         30)
                                      //     ? ElevatedButton(
                                      //         onPressed: null,
                                      //         child: Text("Onboard"),
                                      //         style: ElevatedButton.styleFrom(
                                      //             onSurface: Colors.indigo),
                                      //       )
                                      //     : ElevatedButton(
                                      //         onPressed: null,
                                      //         child: Text("Proceeding"),
                                      //         style: ElevatedButton.styleFrom(
                                      //             onSurface: Colors.green),
                                      //       ),
                                      ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          icnScheduleList(
                                            int.parse(
                                              _selectedMgtEvents.value[index]
                                                  .toString(),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              ctnScheduleList(
                                                int.parse(
                                                  _selectedMgtEvents
                                                      .value[index]
                                                      .toString(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 20, right: 5),
                                        child: ButtonBar(
                                          children: [
                                            btnScheduleList(
                                                int.parse(
                                                  _selectedMgtEvents
                                                      .value[index]
                                                      .toString(),
                                                ),
                                                value,
                                                index,
                                                context,
                                                reqport),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )));
                    },
                  );
                },
              ),
            ),
          ],
        ),
        onWillPop: _onwillPop,
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: onLeftArrowTap,
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              width: 120.0,
              child: Text(
                headerText,
                style: TextStyle(fontSize: 26.0),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: onRightArrowTap,
            ),
          ),
        ],
      ),
    );
  }
}
