import 'package:treeview_tractian/data/data_sources/local/daos/asset_dao.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/models/asset_model.dart';

abstract interface class AssetLocalDataSource {
  Future<Resource<List<AssetModel>>> readAllFromCompanyID(
      String companyId);
}

class AssetLocalDataSourceImpl implements AssetLocalDataSource {
  final AssetDAO assetDAO;

  AssetLocalDataSourceImpl({required this.assetDAO});

  @override
  Future<Resource<List<AssetModel>>> readAllFromCompanyID(
      String companyId) async {
    final Resource<List<Map<String, dynamic>>> resource =
        await assetDAO.readAllFromCompanyID(companyId);

    if (resource.isFailure()) {
      return Resource.failure(resource.error!);
    }

    try {
      final toReturn = List.from(resource.data ?? [])
          .map((element) => AssetModel.parseFromDatabase(element))
          .toList();
      return Resource.success(data: toReturn);
    } catch (error) {
      return Resource.failure(AppError(
          'Erro ao realizar o parse AssetModel.fromDatabase',
          exception: error));
    }
  }
}
