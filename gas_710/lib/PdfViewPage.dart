import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class PdfViewPage extends StatelessWidget {
  final String path;
  const PdfViewPage({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      path: path,
      appBar: AppBar(
        title: Text(
          'PDF File'
        ),
        backgroundColor: Colors.purple,
      )
    );
  }
}