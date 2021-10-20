import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfApi2 {
  static Future<File> generateImage() async {
    final pdf = pw.Document();

    final ByteData bytes = await rootBundle.load('assets/cert.jpg');
    final Uint8List byteList = bytes.buffer.asUint8List();
    pdf.addPage(pw.Page(
        build: (context) => pw.Image(
            pw.MemoryImage(
              byteList,
            ),
            fit: pw.BoxFit.cover)));

    return saveDocument(name: 'my_example2.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
