import 'dart:async';

import 'package:livingdex_tracker/data/models/pokemon.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Source : https://www.tutorialkart.com/flutter/flutter-sqlite-tutorial/
class DatabaseHelper {

  static const _databaseName = "livingdex.db";
  static const _databaseVersion = 3;

  static const _table = "pokemon";

  static const _tableCreation = '''
                CREATE TABLE $_table(
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  pokemon_id INTEGER NOT NULL,
                  name STRING NOT NULL,
                  api_url STRING NOT NULL,
                  caught INTEGER NOT NULL,
                  shiny INTEGER NOT NULL,
                  generation INTEGER NOT NULL
                );
              ''';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<dynamic> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: (db, version) {
          return db.execute(
              _tableCreation
          );
        },
        onUpgrade: (db, oldVersion, newVersion) {
          if (oldVersion < newVersion) {
            return db.execute(
                '''
                DROP TABLE IF EXISTS $_table;
                $_tableCreation
                '''
            );
          }
        }
    );
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int?> insert(PokemonModel pokemon) async {
    Database? db = await instance.database;
    return await db?.insert(_table,
        {
          'pokemon_id': pokemon.id,
          'name': pokemon.name,
          'api_url': pokemon.apiUrl,
          'caught': pokemon.caught,
          'shiny': pokemon.shiny,
          'generation': pokemon.generation
        }
    );
  }

  Future<Object?> insertBatch(List<PokemonModel> pokemons) async {
    Database? db = await instance.database;
    Batch batch = db!.batch();
    for (var pokemon in pokemons) {
      print("Inserting $pokemon");
      batch.insert(_table,
          {
            'pokemon_id': pokemon.pokemonId,
            'name': pokemon.name,
            'api_url': pokemon.apiUrl,
            'caught': pokemon.caught,
            'shiny': pokemon.shiny,
            'generation': pokemon.generation
          }
      );
    }
    return await batch.commit();
  }

  Future<List<Map<String, dynamic>>?> queryGeneration(int generation) async {
    Database? db = await instance.database;
    return await db?.query(_table, where: 'generation = ?', whereArgs: [generation]);
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int?> update(PokemonModel pokemon) async {
    Database? db = await instance.database;
    int pokemonId = pokemon.toMap()['pokemon_id'];
    return await db?.update(_table, pokemon.toMap(), where: 'pokemon_id = ?', whereArgs: [pokemonId]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int?> delete(int id) async {
    Database? db = await instance.database;
    return await db?.delete(_table, where: 'id = ?', whereArgs: [id]);
  }
}