import 'package:flutter/material.dart';
import 'package:notes_clone/class/notes.dart';
import 'package:notes_clone/screen/handling_note.dart';
import 'package:notes_clone/screen/home.dart';
import 'package:notes_clone/widgets/drawer.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoteProvider>(
      create: (context) => NoteProvider(),
      child: MaterialApp(
        title: "My Memo",
        theme: ThemeData(
          primaryColor: Colors.indigo,
          primarySwatch: Colors.indigo,
        ),
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  final Note _emptyNote =
      Note(title: "", tag: "", person: "", note: "", dateTime: null, id: -1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Consumer<NoteProvider>(
          builder: (_, noteProvider, __) =>
              MyDrawer(noteProvider: noteProvider)),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 50,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return HandleNote(currNote: _emptyNote);
              },
            ),
          );
        },
      ),
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HandleNote(currNote: _emptyNote);
                    },
                  ),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              )),
        ],
        title: Text(
          "My Memos",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        centerTitle: true,
      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, __) => HomeScreen(
          noteProvider: noteProvider,
        ),
      ),
    );
  }
}
