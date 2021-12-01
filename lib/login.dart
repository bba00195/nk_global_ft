import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:nk_global_ft/api/api_oceanLook.dart';
import 'package:nk_global_ft/noNetWorkSign.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:nk_global_ft/model/Local_auth_api.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'dart:ui' as ui;
import 'noNetWorkSign.dart';
import 'home_page.dart';
import 'common/common.dart';

class Login extends StatefulWidget {
  final String? id;
  final String? password;

  Login({this.id, this.password});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool hidePW = true;

  APIocean apiOcean = new APIocean();
  var oceanList;
  List vesselList = [];
  List properties = [];

  List<int> mmsilist = [];
  oceanApi() {
    return Container(
      child: TextButton(
        child: Text("ocean Api"),
        onPressed: () {
          apiOcean.getOcean().then((value) {
            oceanList = value["features"];
            if (value["features"].isNotEmpty) {
              vesselList.clear();
              //print(oceanList[0]["properties"]);
              for (int i = 0; i < oceanList.length; i++) {
                vesselList.add(oceanList[i]["properties"]);
              }
            }
          });
        },
      ),
    );
  }

  GlobalKey<FormState> idFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> pwFormKey = GlobalKey<FormState>();
  final _sign = GlobalKey<SignatureState>();

  final idTextEditController = TextEditingController();
  final passwordTextEditController = TextEditingController();

  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiomatrics;
  String _authorized = '인증 되지 않음';
  bool _isAuthenticating = false;
  ByteData _img = ByteData(0);

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  @override
  void dispose() {
    idTextEditController.dispose();
    passwordTextEditController.dispose();
    super.dispose();
  }

  login(BuildContext context, String sUserId, String sPassword) async {
    if (sUserId == '') {
      // showDialog(
      //   context: context,
      //   builder: (_) {
      //     return Show(message: "아이디를 입력해주세요.");
      //   },
      // );
      CoolAlert.show(
          context: context, type: CoolAlertType.error, text: "아이디를 입력해주세요.");
      return;
    }
    if (sPassword == '') {
      // showDialog(
      //   context: context,
      //   builder: (_) {
      //     return Show(message: "비밀번호를 입력해주세요.");
      //   },
      // );
      CoolAlert.show(
          context: context, type: CoolAlertType.error, text: "비밀번호를 입력해주세요.");
      return;
    }
    List<String> sParam = [sUserId];

    APIService apiService = new APIService();
    apiService.getSelect("LOGIN_S1", sParam).then((value) {
      if (value.user.isNotEmpty) {
        if (passwordTextEditController.text !=
            value.user.elementAt(0).password) {
          // showDialog(
          //   context: context,
          //   builder: (_) {
          //     return Show(message: "비밀번호가 일치하지 않습니다."); // 비밀번호 불일치
          //   },
          // );
          CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: "비밀번호가 일치하지 않습니다..");
        } else {
          // tokenUpdate(sUserId, token);
          var member = UserManager();
          member.user = User(
              userId: value.user.elementAt(0).userId,
              userName: value.user.elementAt(0).userName,
              password: value.user.elementAt(0).password,
              custCode: value.user.elementAt(0).custCode,
              custName: value.user.elementAt(0).custName,
              userCode: value.user.elementAt(0).userCode,
              userType: value.user.elementAt(0).userType,
              eMail: value.user.elementAt(0).eMail,
              phone: value.user.elementAt(0).phone,
              useFlag: value.user.elementAt(0).useFlag
              // token: value.user.elementAt(0).token,
              );

          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => HomePage(
                member: member,
              ),
            ),
          );
        }
      } else {
        CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: "등록되지 않은 아이디 입니다.");
        // showDialog(
        //   context: context,
        //   builder: (_) {
        //     return Show(message: "등록되지 않는 아이디입니다."); // 비밀번호 불일치
        //   },
        // );
      }
    });
  }

  // Future<void> _getAvailableBiometrics() async {
  //   late List<BiometricType> ListofBiometrics;
  //   try {
  //     ListofBiometrics = await auth.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  //   if (!mounted) return;

  //   setState(() {
  //     _availableBiomatrics = ListofBiometrics;
  //   });
  // }

  // Future<void> _checkBiometrics() async {
  //   //생체인증수단 체크
  //   late bool canCheckBiometrics;
  //   try {
  //     canCheckBiometrics = await auth.canCheckBiometrics;
  //   } on PlatformException catch (e) {
  //     canCheckBiometrics = false;
  //     print(e);
  //   }
  //   if (!mounted) return;

  //   setState(() {
  //     _canCheckBiometrics = canCheckBiometrics;
  //   });
  // }

  // Future<void> _authenticate() async {
  //   bool authenicated = false;
  //   try {
  //     setState(() {
  //       _isAuthenticating = true;
  //       _authorized = '인증중';
  //     });
  //     authenicated = await auth.authenticate(
  //         localizedReason: 'os determine authentication method',
  //         useErrorDialogs: true,
  //         stickyAuth: true);
  //     setState(() {
  //       _isAuthenticating = false;
  //     });
  //   } on PlatformException catch (e) {
  //     print(e);
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = "error - ${e.message}";
  //     });
  //     return;
  //   }
  //   if (!mounted) return;

  //   setState(
  //       () => _authorized = authenicated ? 'Authorized' : 'Not Authorized');
  // }

  // Future<void> _authenticateWithBiometrics() async {
  //   bool authenticated = false;
  //   try {
  //     setState(() {
  //       _isAuthenticating = true;
  //       _authorized = '인증중';
  //     });
  //     authenticated = await auth.authenticate(
  //         localizedReason: "Scan your fingerprint (or face or whatever)",
  //         useErrorDialogs: true,
  //         biometricOnly: true);
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = 'Authenticating';
  //     });
  //   } on PlatformException catch (e) {
  //     print(e);
  //     setState(() {
  //       _isAuthenticating = false;
  //       _authorized = "Error - ${e.message}";
  //     });
  //     return;
  //   }
  // }

  // void _cancelAuthentication() async {
  //   await auth.stopAuthentication();
  //   setState(() => _isAuthenticating = false);
  // }

  FocusNode idFocusNode = FocusNode();
  FocusNode pwFocusNode = FocusNode();

  logo() {
    return Container(
      alignment: Alignment.bottomLeft,
      height: 100,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage('assets/nk_logo.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  logo2() {
    return Container(
      alignment: Alignment.bottomRight,
      height: 50,
      width: 100,
      decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage('assets/global.jpg'),
            fit: BoxFit.contain,
          )),
    );
  }

  txtUserId() {
    return Material(
      borderRadius: BorderRadius.circular(5.0),
      child: Form(
        key: idFormKey,
        child: TextField(
          autofocus: false,
          controller: idTextEditController,
          focusNode: idFocusNode,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {
                  idTextEditController.clear();
                },
                icon: Icon(Icons.cancel)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            hintText: 'Input ID',
          ),
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'NotoSansKR',
          ),
        ),
      ),
    );
  }

  txtPassword() {
    return Material(
      borderRadius: BorderRadius.circular(5.0),
      child: Form(
        key: pwFormKey,
        child: TextField(
          autofocus: false,
          controller: passwordTextEditController,
          focusNode: pwFocusNode,
          decoration: InputDecoration(
            suffix: Container(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        hidePW = !hidePW;
                      });
                    },
                    color: Theme.of(context).accentColor.withOpacity(0.4),
                    icon:
                        Icon(hidePW ? Icons.visibility_off : Icons.visibility),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey[400],
                    ),
                    onPressed: () {
                      passwordTextEditController.clear();
                    },
                  ),
                ],
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            hintText: 'Input Password',
          ),
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'NotoSansKR',
          ),
          obscureText: hidePW,
        ),
      ),
    );
  }

  pnlUserName() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
      height: 65,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          txtUserId(),
        ],
      ),
    );
  }

  pnlPassword() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
      height: 65,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          txtPassword(),
        ],
      ),
    );
  }

  loginButton() {
    return Center(
      child: Container(
        height: 50,
        width: 70.w,
        // padding: EdgeInsets.only(left: 35.0, right: 35.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            // shape: new RoundedRectangleBorder(
            //   borderRadius: new BorderRadius.circular(5),
            // ),
            primary: Color.fromRGBO(66, 91, 168, 1.0),
          ),
          onPressed: () {
            login(context, idTextEditController.text,
                passwordTextEditController.text);
            // Navigator.push(context,
            //     CupertinoPageRoute(builder: (context) => HomePage()));
          },
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  faceIdOrLoginTxt() {
    return Container(
      height: 40,
      child: Center(
        child: TextButton(
          onPressed: () async {
            final isAuthenticated = await LocalAuthApi.authenticate();

            if (isAuthenticated) {
              login(context, idTextEditController.text,
                  passwordTextEditController.text);
            }
          },
          child: Text(
            'Face ID or Login',
            style:
                TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  signdialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("signature Pad"),
            content: Column(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  color: Colors.grey[400],
                  child: Signature(
                    color: Colors.black,
                    key: _sign,
                    onSign: () {
                      final sign = _sign.currentState;
                    },
                    strokeWidth: 3,
                  ),
                ),
                // _img.buffer.lengthInBytes == 0
                //     ? Container()
                //     : LimitedBox(
                //         maxHeight: 150,
                //         child: Image.memory(_img.buffer.asUint8List()),
                //       )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    final sign = _sign.currentState;
                    final image = await sign!.getData();
                    var data =
                        await image.toByteData(format: ui.ImageByteFormat.png);
                    sign.clear();
                    final encoded = base64.encode(data!.buffer.asUint8List());
                    setState(() {
                      _img = data;
                    });
                  },
                  child: Text("save")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("close"))
            ],
          );
        });
  }

  noNetworkSign() {
    return Container(
      height: 50,
      width: 70.w,
      child: TextButton(
        child: Text("signature capture"),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => SignPage(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        body: GestureDetector(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    Positioned(
                      child: logo(),
                    ),
                    Positioned(
                      child: logo2(),
                      left: 200,
                      bottom: 0,
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                pnlUserName(),
                SizedBox(
                  height: 5,
                ),
                pnlPassword(),
                SizedBox(
                  height: 30,
                ),
                loginButton(),
                SizedBox(
                  height: 10,
                ),
                faceIdOrLoginTxt(),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: noNetworkSign(),
                ),
                SizedBox(
                  height: 10,
                ),
                oceanApi(),
              ],
            ),
          ),
          onTap: () {
            idFocusNode.unfocus();
            pwFocusNode.unfocus();
          },
        ),
      );
    });
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
