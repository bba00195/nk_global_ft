import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nk_global_ft/home_page.dart';
import 'package:nk_global_ft/login.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ScreenUtilInit(
      designSize: Size(1960, 2440),
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: Login(),
    // );
  }
}
