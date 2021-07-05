import 'package:biodata/data/model/biodata.dart';
import 'package:sqflite/sqflite.dart';

class BiodataDatabaseHelper {
  static BiodataDatabaseHelper _databaseHelper;
  static Database _database;

  BiodataDatabaseHelper._createObject();

  factory BiodataDatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = BiodataDatabaseHelper._createObject();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }

  static const String _tblBiodata = 'biodata';

  Future<Database> _initializeDb() async {

    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/biodata.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblBiodata (
                 id INTEGER PRIMARY KEY AUTOINCREMENT,
                 name TEXT,
                 address TEXT,
                 birth_date TEXT,
                 height TEXT,
                 weight TEXT,
                 photo TEXT
               ) 
            ''');
      },
      version: 1,
    );
    return db;
  }
  // photo BLOB

  Future<void> insertBiodata(Biodata article) async {
    final db = await database;
    await db.insert(_tblBiodata, article.toJson());
  }

  Future<void> updateBiodata(Biodata article) async {
    final db = await database;
    await db.update(
      _tblBiodata,
      article.toJson(),
      where: 'id = ?',
      whereArgs: [article.id],);
  }

  Future<List<Biodata>> getBiodata() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(_tblBiodata);
    return results.map((res) => Biodata.fromJson(res)).toList();
  }

  Future<List<Biodata>> getFirstBiodata() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(_tblBiodata);
    return results.map((res) => Biodata.fromJson(res)).toList();
  }

  Future<List<Biodata>> getBiodataId(String id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tblBiodata,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.map((res) => Biodata.fromJson(res)).toList();
  }

  Future<Map> getBiodataById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.query(
      _tblBiodata,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeBiodata(String id) async {
    final db = await database;

    await db.delete(
      _tblBiodata,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}