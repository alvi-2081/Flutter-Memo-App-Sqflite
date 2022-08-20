import 'dart:ffi';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'notes.dart';

class NotesDBHandler {
  final databaseName = "notes.db";
  final tableName = "notes";

  final fieldMap = {
    "id": "INTEGER PRIMARY KEY AUTOINCREMENT",
    "title": "BLOB",
    "tag": "BLOB",
    "person": "BLOB",
    "content": "BLOB",
    "dateTime": "INTEGER",
  };

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    var path = await getDatabasesPath();
    var dbPath = join(path, databaseName);
    // ignore: argument_type_not_assignable
    Database dbConnection = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(_buildCreateQuery());
    });

    await dbConnection.execute(_buildCreateQuery());

    return dbConnection;
  }

// build the create query dynamically using the column:field dictionary.
  String _buildCreateQuery() {
    String query = "CREATE TABLE IF NOT EXISTS ";
    query += tableName;
    query += "(";
    fieldMap.forEach((column, field) {
      query += "$column $field,";
    });

    query = query.substring(0, query.length - 1);
    query += " )";

    return query;
  }

  static Future<String> dbPath() async {
    String path = await getDatabasesPath();
    return path;
  }

  Future<void> insertNote(Note note, bool isNew) async {
    // Get a reference to the database
    final Database db = await database;

    // Insert the Notes into the correct table.
    await db.insert(
      tableName,
      isNew ? note.toMap(false) : note.toMap(true),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("id:${note.id}");
    return;
  }

  Future<void> updateNote(Note note) async {
    if (note.id != -1) {
      final Database db = await database;

      int idToUpdate = note.id;

      db.update(tableName, note.toMap(true),
          where: "id = ?", whereArgs: [idToUpdate]);
    }
  }

  Future<bool> deleteNote(Note note) async {
    if (note.id != -1) {
      final Database db = await database;
      try {
        await db.delete(tableName, where: "id = ?", whereArgs: [note.id]);
        return true;
      } catch (Error) {
        print("Error deleting ${note.id}: ${Error.toString()}");
        return false;
      }
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> selectAllNotes() async {
    final Database db = await database;
    // query all the notes sorted by last edited
    var data = await db.query(
      tableName, orderBy: "dateTime DESC",
      //  where: "is_archived = ?",
      // whereArgs: [0]
    );
    //print(data);
    return data;
  }

  Future<List<Map<String, dynamic>>> selectSearchedNotes(
      String person, int startDate, int endDate) async {
    final Database db = await database;
    var data;
    // query all the notes sorted by last edited
    if (startDate == endDate) {
      print(startDate);
      print("object");
      data = await db.query(tableName,
          orderBy: "dateTime",
          where: "person LIKE ? AND dateTime >= ? ",
          whereArgs: [
            "$person",
            startDate,
          ]);
    } else if (startDate <= endDate) {
      print(startDate);
      print(endDate);
      print("object");
      data = await db.query(tableName,
          orderBy: "dateTime",
          where: "person LIKE ? AND dateTime <= ? ",
          whereArgs: [
            "$person",
            endDate,
          ]);
    }
    return data;
    // print(data);
    // return data;
  }
}
