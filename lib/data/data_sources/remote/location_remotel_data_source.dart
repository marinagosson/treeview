import 'package:treeview_tractian/data/dtos/location_dto.dart';
import 'package:treeview_tractian/infra/services/remote_client/api_service.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';

abstract interface class LocationRemoteDataSource {
  Future getLocationFromCompany(String companyId);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final ApiService apiService;

  LocationRemoteDataSourceImpl({required this.apiService});

  @override
  Future getLocationFromCompany(String companyId) async {
    final response = await apiService.get('companies/$companyId/locations');
    if (response.isFailure()) return Resource.failure(response.error!);
    if (response.data != null) {
      try {
        return Resource.success(data: List.from(response.data!)
            .map((element) => LocationDTO.fromJson(element))
            .toList());
      } catch (e) {
        return Resource.failure(
            AppError('Error parse LocationDTO.fromJson, ${e.toString()}'));
      }
    } else {
      return Resource.success(data: []);
    }
  }

}