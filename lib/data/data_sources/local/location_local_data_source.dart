import 'package:flutter/foundation.dart';
import 'package:treeview_tractian/data/data_sources/local/daos/location_dao.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/models/location_model.dart';

abstract interface class LocationLocalDataSource {
  Future<Resource<List<LocationModel>>> readAllFromCompanyID(
      String companyId);
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  LocationDAO locationDAO;

  LocationLocalDataSourceImpl({required this.locationDAO});

  @override
  Future<Resource<List<LocationModel>>> readAllFromCompanyID(
      String companyId) async {
    final Resource<List<Map<String, Object?>>> resource =
        await locationDAO.readAllFromCompanyID(companyId);

    if (resource.isFailure()) {
      return Resource.failure(resource.error!);
    }

    try {
      final toReturn = List.from(resource.data ?? [])
          .map((element) => LocationModel.parseFromDatabase(element))
          .toList();
      return Resource.success(data: toReturn);
    } catch (error) {
      debugPrint(
          'LocationLocalDataSource.readAllFromCompanyID error parse LocationModel.fromDatabase: ${error.toString()}');
      return Resource.failure(AppError(
          'Erro ao realizar o parse LocationModel.fromDatabase',
          exception: error));
    }
  }
}
