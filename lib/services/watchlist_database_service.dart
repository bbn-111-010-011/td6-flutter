import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../models/watchlist_item.dart';

class WatchlistDatabaseService {
  /// Chemin injectable :
  /// - null en production : base SQLite locale
  /// - inMemoryDatabasePath en test : base en mémoire
  final String? databasePath;

  Database? _db;

  WatchlistDatabaseService({this.databasePath});

  Future<Database> get _database async {
    _db ??= await _openDatabase();
    return _db!;
  }

  Future<Database> _openDatabase() async {
    final path = databasePath ?? '${await getDatabasesPath()}/watchlist.db';

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE watchlist (
            id INTEGER PRIMARY KEY,
            data TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<WatchlistItem>> getWatchlist() async {
    final db = await _database;
    final rows = await db.query('watchlist');

    return rows.map((row) {
      final data = jsonDecode(row['data'] as String) as Map<String, dynamic>;
      return WatchlistItem.fromJson(data);
    }).toList();
  }

  Future<void> saveWatchlist(List<WatchlistItem> items) async {
    final db = await _database;

    await db.transaction((txn) async {
      await txn.delete('watchlist');

      for (final item in items) {
        await txn.insert(
          'watchlist',
          {
            'id': item.serie.id,
            'data': jsonEncode(item.toJson()),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<void> clearWatchlist() async {
    final db = await _database;
    await db.delete('watchlist');
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
