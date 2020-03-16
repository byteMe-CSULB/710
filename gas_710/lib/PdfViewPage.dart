import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:flutter_share/flutter_share.dart';

class PdfViewPage extends StatelessWidget {
  final String path;
  const PdfViewPage({Key key, this.path}) : super(key: key);

  Future<void> shareFile() async {
    await FlutterShare.shareFile(
      title: 'Reciept PDF',
      text: 'Here is a receipt of the most recent trips we took together',
      filePath: path,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      path: path,
      appBar: AppBar(
        title: Text(
          'PDF Document'
        ),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              print('Sharing file'); 
              shareFile(); // this does NOT work on iPhone
            }
          )
        ],
      )
    );
  }
}