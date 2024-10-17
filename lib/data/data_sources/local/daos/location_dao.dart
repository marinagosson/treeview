import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:treeview_tractian/data/data_sources/local/daos/company_dao.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/infra/services/database/database_service.dart';
import 'package:treeview_tractian/domain/models/location_model.dart';

class LocationDAO {
  final DatabaseService databaseService;

  static String get tableName => 'locations';

  static String tableFieldID = 'id';
  static String tableFieldName = 'name';
  static String tableFieldCompanyId = 'company_id';
  static String tableFieldParentId = 'parent_id';

  LocationDAO({required this.databaseService});

  static String get createTable => '''
      CREATE TABLE $tableName (
        $tableFieldID TEXT PRIMARY KEY,
        $tableFieldName TEXT,
        $tableFieldCompanyId TEXT,
        $tableFieldParentId TEXT,
        FOREIGN KEY ($tableFieldCompanyId) REFERENCES ${CompanyDAO.tableName}(${CompanyDAO.tableFieldID})
      )
    ''';

  Future<Resource<List<Map<String, dynamic>>>> readAllFromCompanyID(
      String companyId) async {
    try {
      final db = await databaseService.database;
      final result = await db.query(tableName,
          where: '$tableFieldCompanyId = ?', whereArgs: [companyId]);
      return Resource.success(data: result);
    } catch (error) {
      debugPrint(error.toString());
      return Resource.failure(AppError(
          'Erro ao consultar todas as localizações da empresa de id = $companyId'));
    }
  }
}
