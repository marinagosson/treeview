import 'package:treeview_tractian/data/dtos/asset_dto.dart';
import 'package:treeview_tractian/infra/services/remote_client/api_service.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';

abstract interface class AssetRemoteDataSource {
  Future getAssetsFromCompany(String companyId);
}

class AssetRemoteDataSourceImpl implements AssetRemoteDataSource {
  final ApiService apiService;

  AssetRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Resource<List<AssetDTO>>> getAssetsFromCompany(
      String companyId) async {
    final response = await apiService.get('companies/$companyId/assets');
    if (response.isFailure()) return Resource.failure(response.error!);
    if (response.data != null) {
      try {
        final data = List.from(response.data!)
            .map((element) => AssetDTO.fromJson(element))
            .toList();
        return Resource.success(data: data);
      } catch (e) {
        return Resource.failure(
            AppError('Error parse AssetDTO.fromJson, ${e.toString()}'));
      }
    } else {
      return Resource.success(data: []);
    }
  }
}
