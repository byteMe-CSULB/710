
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';

import 'contact.dart';
import 'global_contact.dart' as gc;

class DatabaseContact {
  DatabaseContact._privateInstance();
  static final DatabaseContact _instance = DatabaseContact._privateInstance();
  static Database _database;

  // Constructor
  factory DatabaseContact() => _instance;

  // Get Database, if doesn't exit open one.
  Future<Database> get database async {
    // If null initialize database otherwise return database.
    _database ??= await _openDatabase();
    return _database;
  }

  //////////////////
  // Open Database
  /////////////////

  // Getting Database
  // TODO: Create another function for setting/initializing values.
  Future<Database> _openDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    String path = join(await getDatabasesPath(), gc.dbName);

    // Open/create the database at a given path
    var contactdb = await openDatabase(path, version: 1, onCreate: _createDb);
    // TODO: Lines in here.
    return contactdb;
  }

  // Helper Function for initialize Database, Creates table.
  void _createDb(Database db, int newVersion) async {
    await db.execute('''
    CREATE TABLE ${gc.table} (
        ${gc.colID} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${gc.colFName} TEXT,
        ${gc.colLName} TEXT )
        ''');
  }


  ///////////////////////////
  // Getting Contact List
  ///////////////////////////

  // Get List of Contacts
  Future<List<Contact>> getContactList() async {
    var contactMapList = await _getContactMapList(); // Get 'Map List' from database

    List<Contact> contactList = List<Contact>();
    for (int i = 0; i < contactMapList.length; i++) {
      contactList.add(Contact.fromMap(contactMapList[i]));
    }

    return contactList;
  }

  // Helper function to get a list of maps for each Contact
  Future<List<Map<String, dynamic>>> _getContactMapList() async {
    Database db = await this.database;

    var result = await db.query(gc.table);
    return result;
  }

  ////////////////////////
  // Database functions
  ///////////////////////
  // Insert
  // TODO: Set up Primary Key
  Future<int> insertContact(Contact contact) async {
    Database db = await this.database;
    return await db.insert(gc.table, contact.toMap());
  }

  // Update
  Future<int> updateContact(Contact contact) async {
    var db = await this.database;
    return await db.update(gc.table, contact.toMap(), where: '${gc.colID} = ?', whereArgs: [contact.id]);
  }

  // Delete
  Future<int> deleteContact(int id) async {
    var db = await this.database;
    return await db.rawDelete('DELETE FROM ${gc.table} WHERE ${gc.colID} = $id');
  }

  // Count
  Future<int> getCount() async {
    Database db = await this.database;
    return Sqflite.firstIntValue( await db.rawQuery('SELECT COUNT (*) FROM ${gc.table}') );
  }


/********************
 * Testing
 ********************/

  void fill() async{
    Database db = await this.database;
    if( await getCount() < 0){
      insertContact(Contact('con', 'man'));
      insertContact(Contact('android', 'studio'));
      insertContact(Contact('ree','eee'));
    }
  }
}