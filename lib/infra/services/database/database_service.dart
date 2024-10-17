import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:treeview_tractian/data/data_sources/local/daos/asset_dao.dart';
import 'package:treeview_tractian/data/data_sources/local/daos/company_dao.dart';
import 'package:treeview_tractian/data/data_sources/local/daos/location_dao.dart';

class DatabaseService {
  Database? _database;

  static const databaseName = "myDatabase.db";
  static const databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), databaseName);
    return await openDatabase(path,
        version: databaseVersion, onCreate: _onCreate, onOpen: (_) {
    });
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(CompanyDAO.createTable);
    await db.execute(AssetDAO.createTable);
    await db.execute(LocationDAO.createTable);
  }
}
