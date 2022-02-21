import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

//로그인 불가능 할시 서명 이미지를 갤러리에 저장하는 페이지.
class SignPage extends StatefulWidget {
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  // final _sign = GlobalKey<SignatureState>();
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  GlobalKey _globalKey = new GlobalKey();
  late Uint8List imageInMemory;
  late File capturedFile;

  ByteData _img = ByteData(0);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleClearButton() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButton() async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    if (bytes != null) {
      final result =
          await ImageGallerySaver.saveImage(bytes.buffer.asUint8List());
      Fluttertoast.showToast(
        msg: "Saved to photo or gallery",
        backgroundColor: Colors.greenAccent,
      );
    }

    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Saved Signature"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.navigate_before,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Container(
            color: Colors.grey,
            child: Image.memory(bytes!.buffer.asUint8List()),
          ),
        ),
      );
    }));
  }

  showToast() {
    Widget Toast = Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12,
          ),
          Text("Saved to photo or gallery"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        body: GestureDetector(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Center(
                    child: Text(
                      "Signature Pad",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: SfSignaturePad(
                      key: signatureGlobalKey,
                      backgroundColor: Colors.white,
                      strokeColor: Colors.black,
                      maximumStrokeWidth: 4.0,
                      minimumStrokeWidth: 2.0,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 25,
                    child: Center(
                        child: IconButton(
                      icon: Icon(Icons.refresh, color: Colors.green),
                      onPressed: () {
                        _handleClearButton();
                      },
                    )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.indigo),
                            child: Text("Save"),
                            onPressed: () async {
                              _handleSaveButton();

                              // final result = await ImageGallerySaver.saveImage(
                              //     data!.buffer.asUint8List());

                              // final encoded =
                              //     base64.encode(data!.buffer.asUint8List());
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.indigo),
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )
                    ],
                  )
                ]),
          ),
        ));
  }
}
