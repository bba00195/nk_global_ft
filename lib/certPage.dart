import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nk_global_ft/model/image_pdf_api.dart';
import 'package:nk_global_ft/widget/Url_widget.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:swipe_cards/swipe_cards.dart';
import 'common/common.dart';

class certPage extends StatefulWidget {
  final UserManager member;

  certPage({required this.member});

  @override
  _certPageState createState() => _certPageState();
}

class _certPageState extends State<certPage> {
  DateTime? backpressbtntime;
  late UserManager member;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var pdf = pw.Document();

  String engName = "";
  late String url = 'http://gss.thesafety.com/thema/print.php?name=$engName';

  @override
  void initState() {
    super.initState();
    member = widget.member;
    engName = member.user.userName;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<pw.Document> createPdf() async {
    var assetImage = pw.MemoryImage(
      (await rootBundle.load('assets/cert.jpg')).buffer.asUint8List(),
    );

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          var width = MediaQuery.of(this.context).size.width;
          var height = MediaQuery.of(this.context).size.height;
          return pw.ListView(children: [
            pw.Container(height: height * 0.25, child: pw.Image(assetImage)),
          ]);
        }));
    return pdf;
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
                            "취소",
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
                            "확인",
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
    return Sizer(builder: (context, orientation, deviceType) {
      return WillPopScope(
        onWillPop: _onwillPop,
        child: Scaffold(
            key: scaffoldKey,
            appBar: NkAppBar(
              globalKey: scaffoldKey,
              member: member,
              menuName: 'CERT Management',
            ),
            drawer: NkDrawer(
              globalKey: scaffoldKey,
              member: member,
            ),
            bottomNavigationBar: nkNaviBottomBar(
              selectedIndex: 3,
              globalKey: scaffoldKey,
              member: member,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    height: 65.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: const PDF(
                      enableSwipe: true,
                      swipeHorizontal: true,
                      autoSpacing: true,
                    ).cachedFromUrl(url),
                  ),
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  //   height: 40,
                  //   decoration: BoxDecoration(
                  //     border: Border(
                  //       bottom: BorderSide(color: Colors.black, width: 1),
                  //       left: BorderSide(color: Colors.black, width: 1),
                  //       right: BorderSide(color: Colors.black, width: 1),
                  //     ),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       IconButton(
                  //         icon: Icon(CupertinoIcons.chevron_left_2),
                  //         onPressed: () {},
                  //       ), //onpress , ontap 구현해야함
                  //       IconButton(
                  //         icon: Icon(CupertinoIcons.chevron_left),
                  //         onPressed: () {},
                  //       ),
                  //       IconButton(
                  //         icon: Icon(CupertinoIcons.chevron_right),
                  //         onPressed: () {},
                  //       ),
                  //       IconButton(
                  //         icon: Icon(CupertinoIcons.chevron_right_2),
                  //         onPressed: () {},
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      width: 70.w,
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.indigo,
                          ),
                          onPressed: () {
                            UrlLauncher().launchURL(url);
                          },
                          icon: Icon(Icons.print),
                          label: Text(
                            "PRINT",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  )
                ],
              ),
            )),
      );
    });
  }
}
