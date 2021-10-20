import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class tbrows {
  final String ro;
  final String rum;

  tbrows({required this.ro, required this.rum});
}

class PdfApi {
  static Future<File> generateTable() async {
    final pdf = Document();
    final headers = ['For CMS Confirmatory Survey'];
    final tbrow = [
      tbrows(ro: 'reg', rum: 'date'),
      tbrows(ro: 'owner', rum: 'name'),
      tbrows(ro: 'shipname', rum: 'ship No.'),
      tbrows(ro: 'class NO', rum: 'port'),
    ];
    final data = tbrow.map((tbrows) => [tbrows.ro, tbrows.rum]).toList();
    pdf.addPage(Page(
        build: (context) => Table.fromTextArray(headers: headers, data: [])));

    pdf.addPage(Page(
        build: (context) => Table.fromTextArray(
              headers: [],
              data: data,
              cellAlignment: Alignment.centerLeft,
            )));

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
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
