import 'package:flutter/material.dart';
import 'package:notes_clone/class/notes.dart';
import 'package:notes_clone/main.dart';
import 'package:notes_clone/screen/pdfpreview.dart';
import 'package:notes_clone/screen/search.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final NoteProvider noteProvider;

  const MyDrawer({this.noteProvider});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.48,
        height: MediaQuery.of(context).size.height * 1,
        child: Drawer(
          elevation: 10,
          child: Container(
            color: Colors.blueAccent[100],
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: ListTile(
                    tileColor: Colors.black87,
                    leading: Icon(
                      Icons.sticky_note_2,
                      color: Colors.white70,
                      size: 28,
                    ),
                    title: Center(
                        child: Text(
                      "Welcome to your Notes!",
                      style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )),
                  ),
                ),
                // drawerButton(context, Icons.grid_view, "Grid View", () {
                //   noteProvider.gridView();
                //   Navigator.of(context).pop();
                // }, 10, 18, 10, 8),
                // drawerButton(context, Icons.view_list, "List View", () {
                //   noteProvider.listView();
                //   Navigator.of(context).pop();
                // }, 10, 8, 10, 8),
                drawerButton(
                    context,
                    Icons.home_outlined,
                    "Home",
                    () => Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return Home();
                        })),
                    10,
                    8,
                    10,
                    8),
                drawerButton(
                    context,
                    Icons.search,
                    "Search",
                    () => Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return Search(
                            noteProvider: noteProvider,
                          );
                        })),
                    10,
                    8,
                    10,
                    8),
                drawerButton(
                    context,
                    Icons.picture_as_pdf,
                    "Export",
                    () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return PdfPreviewPage(noteProvider: noteProvider);
                        })),
                    10,
                    8,
                    10,
                    8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container drawerButton(BuildContext context, IconData icon, String text,
      Function func, double left, double top, double right, double bottom) {
    return Container(
      margin: EdgeInsets.fromLTRB(left, top, right, bottom),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        //   border: Border.all(color: Colors.white,width: 4),
        color: Color(0xff191970),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          text,
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
        ),
        onTap: func,
      ),
    );
  }
}
