// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:nk_global_ft/asDetail.dart';
import 'package:nk_global_ft/asDetail2.dart';
import 'package:nk_global_ft/model/schedule_model.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'common/common.dart';
import 'util.dart';

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

  late final PageController _pageController;
  late final ValueNotifier<List<Event>> _selectedEvents;
  late final ValueNotifier<List<Event>> _selectedMgtEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final ValueNotifier<DateTime> headDay = ValueNotifier(DateTime.now());

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<ScheduleResponseModel> scheduleValue = [];

  List<String> scheduleStarts = [];
  List<List<Event>> scheduleEventList = [];
  List<List<Event>> mgtStatusEventList = [];
  Map<DateTime, List<Event>> _events = {};
  Map<DateTime, List<Event>> _mgtEvents = {};

  late DateTime dateNow;
  int sDay = 0;

  String text1 = "";

  String text2 = "승선";
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
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _selectedMgtEvents.dispose();
    super.dispose();
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
    List<String> sParam = [
      reqNo,
      member.user.userId,
    ];
    await apiService.getUpdate("MASTER_U1", sParam).then((value) {
      setState(() {
        if (value.result.isNotEmpty) {
          if (value.result.elementAt(0).rsCode == "E") {
            Show(message: value.result.elementAt(0).rsMsg);
          } else {
            Show(message: "Success on the board.");
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      schSubject = "";
      schUserId = "";
      reqNo = "";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: NkAppBar(
        globalKey: scaffoldKey,
        member: member,
        menuName: '',
      ),
      drawer: NkDrawer(
        globalKey: scaffoldKey,
        member: member,
      ),
      body: Column(
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
                    dateNow = DateTime.parse(DateFormat('yyyy-MM-dd')
                            .format(DateTime.now().add(Duration(days: sDay))) +
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
                    dateNow = DateTime.parse(DateFormat('yyyy-MM-dd')
                            .format(DateTime.now().add(Duration(days: sDay))) +
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
                        if (int.parse(
                                _selectedMgtEvents.value[index].toString()) <
                            30) {
                          setState(() {
                            onBoardAlert(context, value, index);
                          });
                        } else {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ASmanagement2(
                                member: member,
                                reqNo: reqNo,
                              ),
                            ),
                          );
                        }
                      },
                      child: ListTile(
                        selected: value[index].isSelected,
                        title: Text(
                          "${value[index]}",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        trailing: (int.parse(_selectedMgtEvents.value[index]
                                    .toString()) <
                                30)
                            ? ElevatedButton(
                                onPressed: null,
                                child: Text("Onboard"),
                                style: ElevatedButton.styleFrom(
                                    onSurface: Colors.indigo),
                              )
                            : ElevatedButton(
                                onPressed: null,
                                child: Text("Proceeding"),
                                style: ElevatedButton.styleFrom(
                                    onSurface: Colors.green),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
