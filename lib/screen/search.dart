import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_clone/class/notes.dart';
import 'package:notes_clone/screen/handling_note.dart';
import 'package:notes_clone/widgets/drawer.dart';
import 'package:notes_clone/widgets/notes_list.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  final NoteProvider noteProvider;
  Search({@required this.noteProvider});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchQueryController = TextEditingController();

  bool _searched = false;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  search_icon() {
    return _searched
        ? InkWell(
            onTap: () {
              setState(() {
                _searched = !_searched;
              });
              _searchQueryController.clear();
            },
            child: Icon(
              Icons.cancel_outlined,
              color: Colors.indigo,
            ))
        : InkWell(
            onTap: () {
              if (_searchQueryController.text.isNotEmpty) {
                setState(() {
                  _searched = !_searched;
                  handlesearch(startDate.millisecondsSinceEpoch ~/ 1000,
                      endDate.millisecondsSinceEpoch ~/ 1000);
                  // widget.noteProvider
                  //     .getSearchedNotes(_searchQueryController.text.toString(),);

                  print(_searchQueryController.text.toString());
                });
              }
            },
            child: Icon(
              Icons.search,
              color: Colors.indigo,
            ));
  }

  handlesearch(int start, int end) {
    if (start <= end) {
      print("if after ${start <= end}");
      print("${start == end}");

      widget.noteProvider
          .getSearchedNotes(_searchQueryController.text.toString(), start, end);
    } else {
      print("invalid dates supplied");
    }
  }

  List<Map<String, dynamic>> _notes = [];
  @override
  Widget build(BuildContext context) {
    _notes = widget.noteProvider.allSearchedNotes;
    return Scaffold(
        drawer: Consumer<NoteProvider>(
            builder: (_, noteProvider, __) =>
                MyDrawer(noteProvider: noteProvider)),
        appBar: AppBar(
          title: Text(
            "Search Memo",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width * 1, 110),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 3),
                    child: TextField(
                      controller: _searchQueryController,
                      // autofocus: true,
                      decoration: InputDecoration(
                        suffixIcon: search_icon(),
                        hintText: "Search Person",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.indigo),
                      ),
                      style: TextStyle(color: Colors.indigo, fontSize: 16.0),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          dense: true,
                          onTap: () {
                            _startDate(context);
                          },
                          title: const Text(
                            'Start Date:',
                            style: TextStyle(
                                // fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 118, 118, 118)),
                          ),
                          subtitle: Text(
                            "${DateFormat.yMMMd().format(startDate)}",
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _startDate(context);
                              },
                              icon: Icon(
                                Icons.date_range,
                                color: Color.fromARGB(255, 118, 118, 118),
                              )),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          onTap: () {
                            _endDate(context);
                          },
                          title: const Text(
                            'End Date:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 118, 118, 118)),
                          ),
                          subtitle: Text(
                            "${DateFormat.yMMMd().format(endDate)}",
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                _endDate(context);
                              },
                              icon: Icon(
                                Icons.date_range,
                                color: Color.fromARGB(255, 118, 118, 118),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Consumer<NoteProvider>(
            builder: (context, noteProvider, __) => _searched
                ? Container(
                    child: _notes.isEmpty
                        ? Center(
                            child: Text(
                              "No Mamos found, search again.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(12),
                            itemBuilder: (BuildContext ctx, index) {
                              return Stack(children: [
                                Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.indigo),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8),
                                          topLeft: Radius.circular(8),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 6),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.indigo,
                                                  ),
                                                  child: Text(
                                                    utf8.decode(_notes[
                                                        _notes.length -
                                                            index -
                                                            1]['title']),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 3),
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 6),
                                            child: Text(
                                              utf8.decode(_notes[_notes.length -
                                                  index -
                                                  1]['content']),
                                              maxLines: 25,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "Date: ",
                                                      style: TextStyle(
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(_notes[_notes.length - index - 1]['dateTime'] * 1000))}",
                                                      style: TextStyle(
                                                        color: Colors.indigo,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    )
                                                  ],
                                                )),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 8, right: 8, bottom: 15),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.indigo),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Row(
                                            children: [
                                              Text(
                                                "Tag: ",
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                utf8.decode(_notes[
                                                    _notes.length -
                                                        index -
                                                        1]['tag']),
                                                style: TextStyle(
                                                  color: Colors.indigo,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              )
                                            ],
                                          )),
                                          Expanded(
                                              child: Row(
                                            children: [
                                              Text(
                                                "Person: ",
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                utf8.decode(_notes[
                                                    _notes.length -
                                                        index -
                                                        1]['person']),
                                                style: TextStyle(
                                                  color: Colors.indigo,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              )
                                            ],
                                          ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return HandleNote(
                                            currNote: Note(
                                              id: _notes[_notes.length -
                                                  index -
                                                  1]['id'],
                                              title: utf8.decode(_notes[
                                                      _notes.length - index - 1]
                                                  ['title']),
                                              tag: utf8.decode(_notes[
                                                      _notes.length - index - 1]
                                                  ['tag']),
                                              person: utf8.decode(_notes[
                                                      _notes.length - index - 1]
                                                  ['person']),
                                              note: utf8.decode(_notes[
                                                      _notes.length - index - 1]
                                                  ['content']),
                                              dateTime: DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      _notes[_notes.length -
                                                              index -
                                                              1]['dateTime'] *
                                                          1000),
                                            ),
                                          );
                                        }),
                                      );
                                      print(_notes);
                                    },
                                    child: new Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.indigo,
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ]);
                            },
                            itemCount: _notes.length,
                          ))
                : Center(
                    child: Text(
                    "Add person and dates to search.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ))));
  }

  _startDate(BuildContext context) async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  Color.fromRGBO(57, 73, 171, 1), // header background color
              // onPrimary: Colors.black, // header text color
              onSurface: Color.fromRGBO(57, 73, 171, 1), // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Color.fromRGBO(57, 73, 171, 1), // button text color
              ),
            ),
          ),
          child: child,
        );
      },
    );

    if (selected != null && selected != startDate) {
      setState(() {
        startDate = selected;
      });
    }
  }

  _endDate(BuildContext context) async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  Color.fromRGBO(57, 73, 171, 1), // header background color
              // onPrimary: Colors.black, // header text color
              onSurface: Color.fromRGBO(57, 73, 171, 1), // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Color.fromRGBO(57, 73, 171, 1), // button text color
              ),
            ),
          ),
          child: child,
        );
      },
    );

    if (selected != null && selected != endDate) {
      setState(() {
        endDate = selected;
      });
    }
  }
}
