import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static Future<void> initalDB() async {
    String storagePath = await getDatabasesPath();
    String path = join(storagePath, 'images.db');
    Database db = await openDatabase(path,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    _db = db;
  }

  static void _onCreate(Database db, int version) async {
    Batch batch = db.batch();

    batch.execute(''' create table folders (
      id integer primary key not null,
      folderName text not null
     );''');

    batch.execute(''' create table images (
    id integer primary key not null,
    imageName text null,
    image text not null,
    folderId integer not null,
    foreign key (id) references folders(id)
     );''');

    batch.execute(''' create table password (
      password text not null
     );''');

    await batch.commit();

    print(
        'CAaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaalleedddd baby ============');
  }

  static void _onUpgrade(Database db, int newVersion, int pervVersion) async {}

  static Future<int> insert(String sql, List<Object?>? args) async {
    return await _db!.rawInsert(sql, args);
  }

  static Future<List<Map<String, dynamic>>> select(String sql,
      [List<Object?>? args]) async {
    return await _db!.rawQuery(sql, args);
  }

  static Future<bool> update(String sql, List<Object?>? args) async {
    int res = await _db!.rawInsert(sql, args);
    return res > 0;
  }

  static Future<bool> delete(String sql, List<Object?>? args) async {
    int res = await _db!.rawInsert(sql, args);
    return res > 0;
  }
}
