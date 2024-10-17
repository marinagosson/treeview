import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:treeview_tractian/data/data_sources/local/daos/company_dao.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/infra/services/database/database_service.dart';
import 'package:treeview_tractian/domain/models/asset_model.dart';

class AssetDAO {
  static String get tableName => 'assets';

  static String tableFieldID = 'id';
  static String tableFieldName = 'name';
  static String tableFieldCompanyId = 'company_id';
  static String tableFieldLocationId = 'location_id';
  static String tableFieldParentId = 'parent_id';
  static String tableFieldGatewayId = 'gateway_id';
  static String tableFieldSensorType = 'sensor_type';
  static String tableFieldSensorId = 'sensor_id';
  static String tableFieldStatus = 'status';

  DatabaseService databaseService;

  AssetDAO({required this.databaseService});

  static String get createTable => '''
      CREATE TABLE $tableName (
        $tableFieldID TEXT PRIMARY KEY,
        $tableFieldName TEXT,
        $tableFieldCompanyId TEXT,
        $tableFieldParentId TEXT,
        $tableFieldGatewayId TEXT,
        $tableFieldSensorType TEXT,
        $tableFieldLocationId TEXT,
        $tableFieldSensorId TEXT,
        $tableFieldStatus TEXT,
        FOREIGN KEY ($tableFieldCompanyId) REFERENCES ${CompanyDAO.tableName}(${CompanyDAO.tableFieldID})
      )
    ''';

  Future<Resource<List<Map<String, dynamic>>>> readAllFromCompanyID(
      String companyId) async {
    try {
      final db = await databaseService.database;
      final result = await db.rawQuery(
          '''SELECT * FROM $tableName WHERE $tableFieldCompanyId LIKE "$companyId"''');
      return Resource.success(data: result);
    } catch (error) {
      debugPrint(error.toString());
      return Resource.failure(AppError(
          'Erro ao consultar todos os assets a partir da empresa de id = $companyId',
          exception: error));
    }
  }
}
