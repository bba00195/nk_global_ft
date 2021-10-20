import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import 'common/common.dart';

class CertPdf extends StatefulWidget {
  final UserManager member;
  final Key key;

  CertPdf({required this.member, required this.key});

  @override
  _CertPdfState createState() => _CertPdfState();
}

class _CertPdfState extends State<CertPdf> {
  late UserManager member;
  String engName = '';
  late String url = 'https://www.kuls.co.kr/NK/thema/print.php?name=$engName';

  @override
  void initState() {
    super.initState();
    member = widget.member;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    engName = 'sezairi';
    return SafeArea(
        child: Scaffold(
            body: const PDF().cachedFromUrl(
      url,
    )));
  }
}
