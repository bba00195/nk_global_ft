import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:nk_global_ft/model/image_pdf_api.dart';
import 'package:nk_global_ft/widget/Url_widget.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'common/common.dart';

class certPage extends StatefulWidget {
  final UserManager member;

  certPage({required this.member});

  @override
  _certPageState createState() => _certPageState();
}

class _certPageState extends State<certPage> {
  late UserManager member;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var pdf = pw.Document();

  String engName = "";
  late String url = 'https://www.kuls.co.kr/NK/thema/print.php?name=$engName';

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

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
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
          body: Column(
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
                child: const PDF().cachedFromUrl(url),
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
          ));
    });
  }
}
