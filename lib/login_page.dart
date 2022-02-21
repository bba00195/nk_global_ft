import 'dart:convert';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nk_global_ft/api/api_Service.dart';
import 'package:nk_global_ft/api/api_oceanLook.dart';
import 'package:nk_global_ft/signToGallery.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nk_global_ft/widget/nk_widget.dart';
import 'package:nk_global_ft/model/Local_auth_api.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'dart:ui' as ui;
import 'signToGallery.dart';
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
  DateTime? backpressbtntime;
  String networkStatus = '';
  List vesselList = [];
  List properties = [];
  List imolist = [];
  List<int> mmsilist = [];
  List etalist = [];
  var map1;
  String networkstatus = 'null';

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
    startconnchk();
    auth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    super.initState();
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
          context: context,
          type: CoolAlertType.error,
          text: "Please enter your ID.");
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
          context: context,
          type: CoolAlertType.error,
          text: "Please enter your Password.");
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
              text: "The password is wrong.");
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
      }
    });
  }

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
    //txtUserId 를 자식으로 하는 ID 위젯함수
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
    //txtPassword 를 자식으로 하는 pw위젯 함수
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
          onPressed: () async {
            initConnect();
            // login(context, idTextEditController.text,
            //     passwordTextEditController.text);
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

//Local auth 생체인식 부분.
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

//연결상태 체크 (연결상태가 none일시 설정창으로 갈수있는 다이얼로그 생성)
  initConnect() async {
    ConnectivityResult connectivityResult;
    connectivityResult = await Connectivity().checkConnectivity();
    updateStatus(connectivityResult);
  }

  updateStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          text:
              "No internet connection,                                        Check Wi-Fi and Cellular Data",
          barrierDismissible: true,
          confirmBtnText: "Settings",
          cancelBtnText: "Cancel",
          onCancelBtnTap: () {
            Navigator.pop(context);
          },
          onConfirmBtnTap: () {
            AppSettings.openDeviceSettings(); // 기기 설정메뉴로 이동
          });
    } else if (result == ConnectivityResult.mobile) {
      setState(() {
        login(context, idTextEditController.text,
            passwordTextEditController.text);
      });
      //

    } else if (result == ConnectivityResult.wifi) {
      setState(() {
        login(context, idTextEditController.text,
            passwordTextEditController.text);
      });
      //
    }
  }

  startconnchk() async {
    ConnectivityResult connResult;
    connResult = await Connectivity().checkConnectivity();
    updateStatus2(connResult);
  }

  updateStatus2(ConnectivityResult result2) async {
    if (result2 == ConnectivityResult.none) {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: 'No internet connection',
        barrierDismissible: true,
      );
    }
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
    return WillPopScope(
      child: Sizer(builder: (context, orientation, deviceType) {
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
                  // oceanApi(),
                ],
              ),
            ),
            onTap: () {
              idFocusNode.unfocus();
              pwFocusNode.unfocus();
            },
          ),
        );
      }),
      onWillPop: _onwillPop,
    );
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
