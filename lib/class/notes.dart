import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:notes_clone/class/database.dart';

class Note {
  Note({
    this.id,
    @required this.title,
    @required this.tag,
    @required this.person,
    @required this.note,
    @required this.dateTime,
  });

  int id;
  String title;
  String tag;
  String person;
  String note;
  DateTime dateTime;

  Map<String, dynamic> toMap(bool ifUpdate) {
    var data = {
      'title': utf8.encode(title),
      'tag': utf8.encode(tag),
      'person': utf8.encode(person),
      'content': utf8.encode(note),
      "dateTime": epochFromDate(dateTime),
    };
    if (ifUpdate) {
      data['id'] = this.id;
    }
    return data;
  }

  int epochFromDate(DateTime dt) {
    return dt.millisecondsSinceEpoch ~/ 1000;
  }
}

class NoteProvider with ChangeNotifier {
  List<Map<String, dynamic>> _allNotes = [];
  List<Map<String, dynamic>> _allSearchedNotes = [];

  var db = NotesDBHandler();

  List<Map<String, dynamic>> get allNotes {
    return _allNotes;
  }

  List<Map<String, dynamic>> get allSearchedNotes {
    return _allSearchedNotes;
  }

  Future<void> getAllNotes() async {
    // queries for all the notes from the database ordered by latest edited note. excludes archived notes.

    this._allNotes = await db.selectAllNotes();
    print("all notes: $_allNotes");
  }

  Future<void> getSearchedNotes(
      String person, int startDate, int endDate) async {
    // queries for all the notes from the database ordered by latest edited note. excludes archived notes.

    this._allSearchedNotes =
        await db.selectSearchedNotes(person, startDate, endDate);
    print("all Searched notes: $_allSearchedNotes");
    notifyListeners();
  }

  Future<void> clearSearched() async {
    this._allSearchedNotes = [];
    notifyListeners();
  }

  Future<void> createNote(Note _currNote) async {
    await db.insertNote(
      _currNote,
      true,
    );
    notifyListeners();
  }

  Future<void> editNote(Note _currNote) async {
    await db.insertNote(
      _currNote,
      false,
    );
    notifyListeners();
  }

  Future<void> deleteNote(Note _currNote) async {
    await db.deleteNote(_currNote);
    await getAllNotes();

    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
