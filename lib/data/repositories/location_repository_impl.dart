import 'package:treeview_tractian/data/data_sources/local/location_local_data_source.dart';
import 'package:treeview_tractian/data/data_sources/remote/location_remotel_data_source.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/models/location_model.dart';
import 'package:treeview_tractian/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRemoteDataSource remoteDataSource;
  LocationLocalDataSource localDataSource;

  LocationRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Resource<List<LocationModel>>> downloadLocationFromCompany(
      String companyId) async {
    final Resource<List<LocationModel>> resourceLocal =
        await localDataSource.readAllFromCompanyID(companyId);

    if (resourceLocal.data != null && resourceLocal.data!.isNotEmpty) {
      return Resource.success(data: resourceLocal.data!);
    }

    final resource = await remoteDataSource.getLocationFromCompany(companyId);

    if (resource.isFailure()) {
      return Resource.failure(resource.error!);
    }

    if (resource.data != null) {
      try {
        return Resource.success(
            data: List.from(resource.data!)
                .map(
                    (element) => LocationModel.parseFromDTO(element, companyId))
                .toList());
      } catch (e) {
        return Resource.failure(AppError(
            'Error parse LocationModel.parseFromDTO, ${e.toString()}'));
      }
    } else {
      return Resource.success(data: []);
    }
  }

  @override
  Future<Resource<List<LocationModel>>>
      fetchLocationsFromCompanyFromStorage(String companyId) async {
    final resource = await localDataSource.readAllFromCompanyID(companyId);

    if (resource.isFailure()) {
      return Resource.failure(resource.error!);
    }

    return Resource.success(data: resource.data);
  }
}
