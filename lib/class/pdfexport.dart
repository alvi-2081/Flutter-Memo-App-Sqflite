import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> makePdf(List<Map<String, dynamic>> notes) async {
  final pdf = Document();
  List<Map<String, dynamic>> reversed_notes = new List.from(notes.reversed);

  pdf.addPage(
    Page(
      build: (context) {
        return Column(children: [
          Container(height: 50),
          Table(
            border: TableBorder.all(color: PdfColors.black),
            children: [
              TableRow(
                children: [
                  Padding(
                    child: Text(
                      'DATE',
                      style: Theme.of(context).header4,
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.all(20),
                  ),
                  Padding(
                    child: Text(
                      'TAG : DETAILS',
                      style: Theme.of(context).header4,
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.all(20),
                  ),
                ],
              ),
              for (var data in reversed_notes)
                TableRow(
                  children: [
                    Expanded(
                        child: PaddedText(
                            "${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(data['dateTime'] * 1000))}"),
                        flex: 1),
                    Expanded(
                        child: PaddedText(
                            "${utf8.decode(data['tag'])} : ${utf8.decode(data['content'])}"),
                        flex: 2),
                  ],
                )
            ],
          )
        ]);
      },
    ),
  );
  return pdf.save();
}

Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );
