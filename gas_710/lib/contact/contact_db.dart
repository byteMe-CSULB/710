
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

import 'contact.dart';
import 'global_contact.dart' as gc;

class DatabaseContact {
  DatabaseContact._privateInstance();
  static final DatabaseContact _instance = DatabaseContact._privateInstance();
  static Database _database;

  ////////////////
  // Constructor
  ////////////////
  // Constructor
  factory DatabaseContact() => _instance;

  // Get Database, if doesn't exit open one.
  Future<Database> get database async {
    // If null initialize database otherwise return database.
    _database ??= await _openDatabase();
    return _database;
  }

  ///////////////////////////////////
  // Open Database for constructor
  ///////////////////////////////////

  // Getting Database
  // Also sets the selected column to 0 or false.
  Future<Database> _openDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    String path = join(await getDatabasesPath(), gc.dbName);

    // Open/create the database at a given path
    var contactdb = await openDatabase(path, version: 1, onCreate: _createDb);

    // If there are any rows that have a 1 for colSelect then set it to 0 because
    // there are no trips when this is starting.
    await contactdb.rawUpdate('''
      UPDATE ${gc.table}
      SET ${gc.colSelect} = 0
      WHERE ${gc.colSelect} = 1
      ''');

    return contactdb;
  }

  // Helper Function for _openDatabase, it creates the table.
  void _createDb(Database db, int newVersion) async {
    await db.execute('''
    CREATE TABLE ${gc.table} (
        ${gc.colID} INTEGER PRIMARY KEY, 
        ${gc.colName} TEXT NOT NULL UNIQUE CHECK(length(${gc.colName}) > 0),
        ${gc.colPhone} TEXT UNIQUE CHECK(length(${gc.colPhone}) >= 9),
        ${gc.colEmail} TEXT UNIQUE CHECK(length(${gc.colEmail}) > 4),
        ${gc.colFraction} REAL CHECK(${gc.colFraction} >= 0 AND ${gc.colFraction} <= 1),
        ${gc.colSelect} BOOLEAN DEFAULT 0,
        CHECK (${gc.colPhone} IS NOT NULL OR ${gc.colEmail} IS NOT NULL)
        )
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

  ////////////////////////////////////
  // Get List of Available Contacts
  Future<List<Contact>> getAvailableContacts() async {
    var contactMapList = await _getAvailableContactMapList(); // Get 'Map List' from database

    List<Contact> contactList = List<Contact>();
    for (int i = 0; i < contactMapList.length; i++) {
      contactList.add(Contact.fromMap(contactMapList[i]));
    }

    return contactList;
  }

  // Helper function to get a list of maps for each Available Contact
  Future<List<Map<String, dynamic>>> _getAvailableContactMapList() async {
    Database db = await this.database;

    var result = await db.query(gc.table, where: '${gc.colSelect} = 0');
    return result;
  }

  //////////////
  // Reset
  //////////////
  // Resets the database for colSelect or contact on trip
  void reset() async{
    var contactdb = await this.database;
    await contactdb.rawUpdate('''
      UPDATE ${gc.table}
      SET ${gc.colSelect} = 0
      WHERE ${gc.colSelect} = 1
      ''');
  }

  ////////////////////////
  // Database functions
  ////////////////////////
  // Insert
  // This will throw exceptions if constraints are not met.
  Future<int> insertContact(Contact contact) async {
    Database db = await this.database;
    return await db.insert(gc.table, contact.toMap());
  }

  // Update
  // This will throw exceptions if constraints are not met.
  Future<int> updateContact(Contact contact) async {
    var db = await this.database;
    return await db.update(gc.table, contact.toMap(), where: '${gc.colID} = ?', whereArgs: [contact.id]);
  }

  // Delete
  Future<int> deleteContact(Contact contact) async {
    var db = await this.database;
    return await db.rawDelete('DELETE FROM ${gc.table} WHERE ${gc.colID} = ${contact.id}');
  }

  // Setting Boolean(int) for selecting Contact on trip
  Future<int> onTrip(Contact contact) async {
    var db = await this.database;
    return await db.rawUpdate('''
      UPDATE ${gc.table}
      SET ${gc.colSelect} = 1
      WHERE ${gc.colID} = ${contact.id}
      ''');
  }

  // Setting Boolean(int) to remove from contacts
    Future<int> removeTrip(Contact contact) async {
    var db = await this.database;
    return await db.rawUpdate('''
      UPDATE ${gc.table}
      SET ${gc.colSelect} = 0
      WHERE ${gc.colID} = ${contact.id}
      ''');
  }

  // Total amount of contact in database
  Future<int> getCount() async {
    Database db = await this.database;
    return Sqflite.firstIntValue( await db.rawQuery('SELECT COUNT (*) FROM ${gc.table}') );
  }
}