import 'package:treeview_tractian/data/data_sources/local/asset_local_data_source.dart';
import 'package:treeview_tractian/data/data_sources/remote/asset_remote_data_source.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/models/asset_model.dart';
import 'package:treeview_tractian/domain/repositories/asset_repository.dart';

class AssetsRepositoryImpl implements AssetRepository {
  AssetRemoteDataSource remoteDataSource;
  AssetLocalDataSource localDataSource;

  AssetsRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Resource<List<AssetModel>>> downloadAssetsFromCompany(
      String companyId) async {
    final Resource<List<AssetModel>> resourceLocal =
        await localDataSource.readAllFromCompanyID(companyId);

    if (resourceLocal.data != null && resourceLocal.data!.isNotEmpty) {
      return Resource.success(data: resourceLocal.data!);
    }

    final resource = await remoteDataSource.getAssetsFromCompany(companyId);

    if (resource.isFailure()) {
      return Resource.failure(resource.error!);
    }

    if (resource.data != null) {
      try {
        return Resource.success(
            data: List.from(resource.data!)
                .map((element) => AssetModel.parseFromDTO(element, companyId))
                .toList());
      } catch (e) {
        return Resource.failure(
            AppError('Error parse AssetModel.parseFromDTO, ${e.toString()}'));
      }
    } else {
      return Resource.success(data: []);
    }
  }

  @override
  Future<Resource<List<AssetModel>>> fetchAssetsFromCompany(
      String companyId) async {
    final Resource<List<AssetModel>> resource =
        await localDataSource.readAllFromCompanyID(companyId);

    if (resource.isFailure()) {
      return Resource.failure(resource.error!);
    }

    return Resource.success(data: resource.data);
  }
}
