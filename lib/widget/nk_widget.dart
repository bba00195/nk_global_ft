import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nk_global_ft/asModify.dart';
import 'package:nk_global_ft/asdetail.dart';
import 'package:nk_global_ft/history.dart';
import 'package:nk_global_ft/home_page.dart';
import 'package:nk_global_ft/certPage.dart';
import 'package:nk_global_ft/common/common.dart';
import 'package:nk_global_ft/login.dart';
import 'package:nk_global_ft/calendar_schedule.dart';
import 'package:nk_global_ft/qulifyPage.dart';
import 'package:nk_global_ft/schedule.dart';

class NkAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> globalKey;
  final UserManager member;
  final String menuName;

  NkAppBar({
    Key? key,
    required this.globalKey,
    required this.member,
    required this.menuName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AppBar(
      actions: [],
      backgroundColor: Colors.white,
      bottomOpacity: 0.0,
      elevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.grey,
          size: 34,
        ),
        onPressed: () => globalKey.currentState!.openDrawer(),
      ),
      title: Container(
        alignment: Alignment.centerLeft,
        height: 70,
        child: TextButton(
          onPressed: () {},
          child: Text(
            menuName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'NotosansKR',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      toolbarHeight: 100,
      iconTheme: IconThemeData(color: Colors.black),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class NkDrawer extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> globalKey;
  final UserManager member;

  NkDrawer({Key? key, required this.globalKey, required this.member})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    Widget menuRow(String sMenuName, IconData sIcons) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 10,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                sMenuName,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'NotosansKR',
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Icon(
                sIcons,
                size: 26,
              ),
            ),
          ),
        ],
      );
    }

    return new Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            height: 100,
            color: Color.fromRGBO(244, 242, 255, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15),
                  alignment: Alignment.centerLeft,
                  width: 50,
                  height: 35,
                  child: Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: Text(
                      member.user.userName,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(
                              id: member.user.userId,
                              password: member.user.password,
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.logout,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: screenHeight - 210,
            padding: EdgeInsets.all(45),
            child: ListView(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(member: member),
                      ),
                    );
                  },
                  child: menuRow('Main', Icons.chevron_right),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => certPage(member: member),
                      ),
                    );
                  },
                  child: menuRow('CERT Management', Icons.chevron_right),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                qulifyManage(member: member)));
                  },
                  child: menuRow('Qulify Management', Icons.chevron_right),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryPage(member: member),
                      ),
                    );
                  },
                  child: menuRow('History', Icons.chevron_right),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Schedule(member: member),
                      ),
                    );
                  },
                  child: menuRow('Schedule', Icons.chevron_right),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

// ignore: must_be_immutable
class nkNaviBottomBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> globalKey;
  final UserManager member;
  final int selectedIndex;

  nkNaviBottomBar({
    Key? key,
    required this.globalKey,
    required this.member,
    required this.selectedIndex,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = selectedIndex;
    return Container(
      decoration: BoxDecoration(),
      child:
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          Container(
        height: 90,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Color.fromRGBO(66, 91, 168, 1),
          unselectedItemColor: Color.fromRGBO(198, 198, 198, 1),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          currentIndex: _selectedIndex, //현재 선택된 Index
          onTap: (int index) {
            if (index == 0) {
              Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => HomePage(
                            member: member,
                          )));
            } else if (index == 1) {
              Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => HistoryPage(member: member)));
            } else if (index == 2) {
              Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => Schedule(member: member)));
            } else if (index == 3) {
              Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => certPage(member: member)));
            }

            // if (_selectedIndex != index && index == 0) {
            //   globalKey.currentState.openDrawer();
            // } else if (index == 1 && pageName != 'home') {
            //   Navigator.of(context)
            //     ..pushReplacement(
            //       CupertinoPageRoute(
            //         builder: (context) => HomePage(
            //           id: id,
            //           pass: pass,
            //           member: member,
            //         ),
            //       ),
            //     );
            //   _selectedIndex = index;
            // } else if (_selectedIndex != index && index == 2) {
            //   Navigator.of(context)
            //     ..pushReplacement(
            //       CupertinoPageRoute(
            //         builder: (context) => ProfilePage(
            //           id: id,
            //           pass: pass,
            //           member: member,
            //         ),
            //       ),
            //     );
            //   _selectedIndex = index;
            // }
          },
          items: [
            BottomNavigationBarItem(
              label: 'Main',
              icon: Icon(
                Icons.home_filled,
                size: 24,
              ),
            ),
            BottomNavigationBarItem(
              label: 'History',
              icon: Icon(
                Icons.history,
                size: 24,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Schedule',
              icon: Icon(
                Icons.calendar_today_outlined,
                size: 24,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Cert',
              icon: Icon(
                Icons.assignment_ind,
                size: 24,
              ),
            ),
          ],
        ),
      ),
      //   Container(
      //     alignment: Alignment.center,
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       border: Border(
      //         top: BorderSide(
      //           color: Color.fromRGBO(244, 244, 244, 1.0),
      //           width: 1.0,
      //         ),
      //       ),
      //     ),
      //     height: 50,
      //     child: Text(
      //       'Copyright ⓒ 2021 KULS All right reserved.',
      //       style: TextStyle(
      //         color: Color.fromARGB(255, 175, 175, 175),
      //         fontSize: 12,
      //       ),
      //     ),
      //   ),
      // ],
      // ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class Show extends StatefulWidget {
  late String message;

  Show({
    required this.message,
  });

  @override
  ShowState createState() => new ShowState();
}

class ShowState extends State<Show> {
  late String sMessage;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    sMessage = widget.message;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget alert(String sContent) {
      return new AlertDialog(
        // title: Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(sContent),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.2),
      body: alert(sMessage),
    );
  }
}
