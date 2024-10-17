import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/infra/services/database/database_service.dart';

class CompanyDAO {
  static String get tableName => 'companies';

  static String tableFieldID = 'id';
  static String tableFieldName = 'name';

  DatabaseService databaseService;

  CompanyDAO({required this.databaseService});

  static String get createTable => '''
      CREATE TABLE $tableName (
        $tableFieldID TEXT PRIMARY KEY,
        $tableFieldName TEXT,
        UNIQUE($tableFieldID)
      )
    ''';

  Future<Resource<List<Map<String, Object?>>>> readAll() async {
    try {
      final db = await databaseService.database;
      final result = await db.query(tableName);
      return Resource.success(data: result);
    } catch (error) {
      return Resource.failure(AppError(
          'Erro ao consultar as empresas no banco de dados',
          exception: error));
    }
  }
}
