import 'dart:async';

import 'package:sqflite/sqflite.dart' as sql;

class DbConn {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
      ""
      "CREATE TABLE mlist(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, director TEXT)"
      "",
    );
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'movies.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String name, String director) async {
    final db = await DbConn.db();

    final data = {'name': name, 'director': director};
    final id = await db.insert('mlist', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DbConn.db();
    return db.query('mlist', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DbConn.db();
    return db.query('mlist', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(int id, String name, String director) async {
    final db = await DbConn.db();

    final data = {'name': name, 'director': director};

    final result =
        await db.update('mlist', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await DbConn.db();
    try {
      await db.delete("mlist", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      print("Something went wrong when deleting an item: $err");
    }
  }
}
