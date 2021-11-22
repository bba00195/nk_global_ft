import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:nk_global_ft/model/Local_auth_api.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:ui' as ui;
import 'home_page.dart';
import 'common/common.dart';

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
    }
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        body: Center(
          child: Container(
            color: Colors.grey,
            child: Image.memory(bytes!.buffer.asUint8List()),
          ),
        ),
      );
    }));
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
                      "Signature plz",
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
                      ElevatedButton(
                        child: Text("Save"),
                        onPressed: () async {
                          _handleSaveButton();

                          // final result = await ImageGallerySaver.saveImage(
                          //     data!.buffer.asUint8List());

                          // final encoded =
                          //     base64.encode(data!.buffer.asUint8List());
                        },
                      ),
                      ElevatedButton(
                        child: Text("Close"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                ]),
          ),
        ));
  }
}
