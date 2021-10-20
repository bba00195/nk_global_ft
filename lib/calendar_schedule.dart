import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:nk_global_ft/util.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import 'common/common.dart';

class Home extends StatefulWidget {
  final UserManager member;

  Home({required this.member});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late UserManager member;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  late final ValueNotifier<List<Event>> _selectedEvents;

  final ValueNotifier<DateTime> headDay = ValueNotifier(DateTime.now());

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    member = widget.member;
  }

  @override
  void dispose() {
    super.dispose();
  }

  claendatform() {
    return TableCalendar(
      locale: 'en-US',
      focusedDay: selectedDay,
      firstDay: DateTime(1950),
      lastDay: DateTime(2100),
      calendarFormat: format,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      daysOfWeekVisible: true,
      //Day Changed
      onDaySelected: (DateTime selectDay, DateTime focusDay) {
        setState(() {
          selectedDay = selectDay;
          focusedDay = focusDay;
        });
      },
      selectedDayPredicate: (DateTime date) {
        return isSameDay(selectedDay, date);
      },
      // style calendar
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        holidayTextStyle: TextStyle().copyWith(color: Colors.blue[800]),
        weekendTextStyle: TextStyle().copyWith(color: Colors.red),
        isTodayHighlighted: true,
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(color: Colors.white),
      ),

      headerStyle: HeaderStyle(
        titleTextStyle:
            const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  boxSchedulehaeder() {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 3.0,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text('A/S Schedule',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'NotoSansKR')),
            )
          ],
        ));
  }

  boxScheduleList() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 0, 0, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              height: 40,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Text("H1057 A/S",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            Container(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.indigo),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text("Are you sure you want to Onborad?"),
                            actions: [
                              CupertinoDialogAction(
                                child: Text("Allow"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoDialogAction(
                                child: Text("deny"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: Text(
                    "Onboard",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
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
            menuName: '',
          ),
          drawer: NkDrawer(
            globalKey: scaffoldKey,
            member: member,
          ),
          body: Column(
            children: [
              claendatform(),
              SizedBox(
                height: 20,
              ),
              boxSchedulehaeder(),
              boxScheduleList(),
            ],
          ));
    });
  }
}
