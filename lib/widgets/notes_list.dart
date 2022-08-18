// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:notes_clone/class/Note.dart';
// import 'package:notes_clone/screen/pdfpreview.dart';
// import '../screen/handling_note.dart';

// class ListWidget extends StatefulWidget {
//   ListWidget({@required this.notes});

//   final List<Map<String, dynamic>> notes;

//   @override
//   _ListWidgetState createState() => _ListWidgetState();
// }

// class _ListWidgetState extends State<ListWidget> {
//   List<Map<String, dynamic>> get _notes {
//     return widget.notes;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _notes.isEmpty
//         ? Center(
//             child: Text(
//             "No notes found here, Click on +",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//           ))
//         : ListView.builder(
//             padding: EdgeInsets.all(12),
//             itemBuilder: (BuildContext ctx, index) {
//               return Stack(children: [
//                 Column(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.indigo),
//                         borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(8),
//                           topLeft: Radius.circular(8),
//                         ),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   padding: EdgeInsets.all(10),
//                                   margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     color: Colors.indigo,
//                                   ),
//                                   child: Text(
//                                     utf8.decode(
//                                         _notes[_notes.length - index - 1]
//                                             ['title']),
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 8, horizontal: 3),
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
//                             child: Text(
//                               utf8.decode(
//                                   _notes[_notes.length - index - 1]['content']),
//                               maxLines: 25,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                   color: Colors.black54, fontSize: 15),
//                             ),
//                           ),
//                           Container(
//                             margin: EdgeInsets.symmetric(vertical: 5),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                     child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       "Time: ",
//                                       style: TextStyle(
//                                         color: Colors.black54,
//                                       ),
//                                     ),
//                                     Text(
//                                       "${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(_notes[_notes.length - index - 1]['dateTime'] * 1000))}",
//                                       style: TextStyle(
//                                         color: Colors.indigo,
//                                         decoration: TextDecoration.underline,
//                                       ),
//                                     )
//                                   ],
//                                 )),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(left: 8, right: 8, bottom: 15),
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.indigo),
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(8),
//                           bottomRight: Radius.circular(8),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                               child: Row(
//                             children: [
//                               Text(
//                                 "Tag: ",
//                                 style: TextStyle(
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                               Text(
//                                 utf8.decode(
//                                     _notes[_notes.length - index - 1]['tag']),
//                                 style: TextStyle(
//                                   color: Colors.indigo,
//                                   decoration: TextDecoration.underline,
//                                 ),
//                               )
//                             ],
//                           )),
//                           Expanded(
//                               child: Row(
//                             children: [
//                               Text(
//                                 "Person: ",
//                                 style: TextStyle(
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                               Text(
//                                 utf8.decode(_notes[_notes.length - index - 1]
//                                     ['person']),
//                                 style: TextStyle(
//                                   color: Colors.indigo,
//                                   decoration: TextDecoration.underline,
//                                 ),
//                               )
//                             ],
//                           ))
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//                 Positioned(
//                   right: 0,
//                   bottom: 0,
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) {
//                           return HandleNote(
//                             currNote: Note(
//                               id: _notes[_notes.length - index - 1]['id'],
//                               title: utf8.decode(
//                                   _notes[_notes.length - index - 1]['title']),
//                               tag: utf8.decode(
//                                   _notes[_notes.length - index - 1]['tag']),
//                               person: utf8.decode(
//                                   _notes[_notes.length - index - 1]['person']),
//                               note: utf8.decode(
//                                   _notes[_notes.length - index - 1]['content']),
//                               dateTime: DateTime.fromMillisecondsSinceEpoch(
//                                   _notes[_notes.length - index - 1]
//                                           ['dateTime'] *
//                                       1000),
//                             ),
//                           );
//                         }),
//                       );
//                       print(_notes);
//                     },
//                     child: new Container(
//                       padding: const EdgeInsets.all(10.0),
//                       decoration: new BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.indigo,
//                       ),
//                       child: Icon(
//                         Icons.edit,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ]);
//             },
//             itemCount: _notes.length,
//           );
//   }
// }
