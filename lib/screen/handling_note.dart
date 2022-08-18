import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:notes_clone/class/notes.dart';
import 'package:notes_clone/class/database.dart';
import 'package:notes_clone/main.dart';
import 'package:provider/provider.dart';

class HandleNote extends StatefulWidget {
  static const routeName = '/addNote';

  HandleNote({@required this.currNote});

  final Note currNote;

  @override
  _HandleNoteState createState() => _HandleNoteState();
}

class _HandleNoteState extends State<HandleNote> {
  NoteProvider noteProvider;
  TextEditingController _title = TextEditingController();
  TextEditingController _tag = TextEditingController();
  TextEditingController _person = TextEditingController();
  TextEditingController _note = TextEditingController();
  FocusNode _titleNode = FocusNode();
  FocusNode _tagNode = FocusNode();
  FocusNode _personNode = FocusNode();
  FocusNode _notesNode = FocusNode();
  DateTime selectedDate = DateTime.now();
  var db = NotesDBHandler();
  Note _currNote;

  _changeTitleFocus() {
    FocusScope.of(context).requestFocus(_tagNode);
  }

  _changeTagFocus() {
    FocusScope.of(context).requestFocus(_personNode);
  }

  _changePersonFocus() {
    FocusScope.of(context).requestFocus(_notesNode);
  }

  void createProvider(BuildContext context) {
    noteProvider = Provider.of<NoteProvider>(context);
  }

  @override
  void initState() {
    super.initState();
    _currNote = widget.currNote;
    if (_currNote.id != -1) {
      _title.text = _currNote.title;
      _tag.text = _currNote.tag;
      _person.text = _currNote.person;
      _note.text = _currNote.note;
      // _dateObject = DateFormat.yMMMd().format(_currNote.dateTime);
      selectedDate = _currNote.dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    createProvider(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          _currNote.id == -1 ? await _createNote() : await _editNote();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return Home();
          }));
        },
      ),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            noteProvider.notify();
            Navigator.of(context).pop();
          },
          color: Colors.indigo,
        ),
        leadingWidth: 45,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    await _deleteNote(context);
                    noteProvider.notify();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return Home();
                      // : ArchivedNotes(
                      //     noteProvider: noteProvider,
                      //   );
                    }));
                  },
                  child: Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.white24,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: Colors.white24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFields(
                  _title, "Title", _titleNode, _changeTitleFocus(), 28.0),
              SizedBox(
                height: 10,
              ),
              TextFields(_tag, "Tag", _tagNode, _changeTagFocus(), 20.0),
              SizedBox(
                height: 10,
              ),
              TextFields(
                  _person, "Person", _personNode, _changePersonFocus(), 20.0),
              SizedBox(
                height: 20,
              ),
              TextField(
                textAlign: TextAlign.justify,
                controller: _note,
                focusNode: _notesNode,
                decoration: InputDecoration(
                    hintText: "Write a Note Here!",
                    hintStyle: TextStyle(fontSize: 18)),
                maxLines: 15,
                style: TextStyle(fontSize: 18),
                // onEditingComplete: _createNote,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: ListTile(
                  onTap: () {
                    _selectDate(context);
                  },
                  title: const Text(
                    'Select a Date:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 118, 118, 118)),
                  ),
                  subtitle: Text(
                    "${DateFormat.yMMMd().format(selectedDate)}",
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        _selectDate(context);
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
      ),
    );
  }

  Future<void> _createNote() async {
    DateTime now = selectedDate;
    await noteProvider.createNote(
      Note(
        title: _title.text,
        tag: _tag.text,
        person: _person.text,
        note: _note.text,
        dateTime: now,
      ),
    );
  }

  Future<void> _editNote() async {
    DateTime now = selectedDate;
    await noteProvider.editNote(
      Note(
        id: _currNote.id,
        title: _title.text,
        tag: _tag.text,
        person: _person.text,
        note: _note.text,
        dateTime: now,
      ),
    );
  }

  Future<void> _deleteNote(BuildContext context) async {
    await noteProvider.deleteNote(_currNote);
  }

  // Future<void> _archiveNote() async {
  //   setState(() {
  //     _currNote.archived = 1;
  //   });
  //   await noteProvider.archiveNote(_currNote);
  // }

  // Future<void> _unarchiveNote() async {
  //   setState(() {
  //     _currNote.archived = 0;
  //   });
  //   await noteProvider.unarchiveNote(_currNote);
  // }

  _selectDate(BuildContext context) async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
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

    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }
}

Widget TextFields(controller, title, node, action, size) {
  return TextField(
    textAlign: TextAlign.justify,
    controller: controller,
    decoration: InputDecoration(
      hintText: title,
      hintStyle: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    ),
    maxLines: null,
    autocorrect: true,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
    textInputAction: TextInputAction.next,
    focusNode: node,
    onEditingComplete: action,
  );
}
