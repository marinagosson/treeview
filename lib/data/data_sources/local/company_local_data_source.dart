import 'package:treeview_tractian/data/data_sources/local/daos/company_dao.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/models/company_model.dart';

abstract interface class CompanyLocalDataSource {
  Future<Resource<List<CompanyModel>>> readAll();
}

class CompanyLocalDataSourceImpl implements CompanyLocalDataSource {
  CompanyDAO companyDAO;

  CompanyLocalDataSourceImpl({required this.companyDAO});

  @override
  Future<Resource<List<CompanyModel>>> readAll() async {
    final Resource<List<Map<String, Object?>>> resource =
        await companyDAO.readAll();

    if (resource.isFailure()) {
      return Resource.failure(resource.error!);
    }

    try {
      final toReturn = List.from(resource.data ?? [])
          .map((element) => CompanyModel.parseFromDatabase(element))
          .toList();
      return Resource.success(data: toReturn);
    } catch (error) {
      return Resource.failure(AppError(
          'Erro ao realizar o parse CompanyModel.fromDatabase',
          exception: error));
    }
  }
}
