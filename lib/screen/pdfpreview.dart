import 'package:flutter/material.dart';
import 'package:notes_clone/class/notes.dart';
import 'package:notes_clone/class/pdfexport.dart';
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatefulWidget {
  // final List<Map<String, dynamic>> notes;
  List<Map<String, dynamic>> dataList;
  PdfPreviewPage({Key key, @required this.dataList}) : super(key: key);

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      body: PdfPreview(
        allowSharing: false,
        canDebug: false,
        build: (context) => makePdf(widget.dataList),
      ),
    );
  }
}
