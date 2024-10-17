import 'dart:async';

import 'package:treeview_tractian/infra/services/isolates/process_data_download_isolate_service.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/models/asset_model.dart';
import 'package:treeview_tractian/domain/models/location_model.dart';
import 'package:treeview_tractian/domain/repositories/asset_repository.dart';
import 'package:treeview_tractian/domain/repositories/company_repository.dart';
import 'package:treeview_tractian/domain/repositories/location_repository.dart';

abstract interface class FetchAndSaveAllDataUseCase {
  Future<Resource<bool>> call();
}

class FetchAndSaveAllDataUseCaseImpl implements FetchAndSaveAllDataUseCase {
  final CompanyRepository companyRepository;
  final LocationRepository locationRepository;
  final AssetRepository assetRepository;

  FetchAndSaveAllDataUseCaseImpl(
      {required this.companyRepository,
      required this.locationRepository,
      required this.assetRepository});

  @override
  Future<Resource<bool>> call() async {
    try {

      await Future.delayed(const Duration(seconds: 2));

      final resource = await companyRepository.fetchCompanies();

      if (resource.isFailure()) {
        return Resource.failure(resource.error!);
      }

      if (resource.data != null && resource.data!.isNotEmpty) {
        List<Future<Resource<List<AssetModel>>>> futuresAssetsRequests = [];
        List<Future<Resource<List<LocationModel>>>> futuresLocationsRequests =
            [];

        for (var company in resource.data!) {
          futuresAssetsRequests
              .add(assetRepository.downloadAssetsFromCompany(company.id));
          futuresLocationsRequests
              .add(locationRepository.downloadLocationFromCompany(company.id));
        }

        List<AssetModel> assets = [];
        List<LocationModel> locations = [];

        await Future.wait(futuresLocationsRequests, eagerError: true)
            .then((resultLocations) async {
          for (var result in resultLocations) {
            if (result.data != null) {
              locations.addAll(result.data!);
            }
          }
        });
        await Future.wait(futuresAssetsRequests, eagerError: true)
            .then((resultAssets) async {
          for (var result in resultAssets) {
            if (result.data != null) {
              assets.addAll(result.data!);
            }
          }
        });

        final result = await ProcessDataDownloadIsolateService()
            .processDataInIsolate(resource.data!, assets, locations);

        if (result.isFailure()) {
          return Resource.failure(resource.error!);
        }
        return Resource.success();
      }
    } catch (error) {
      return Resource.failure(
          AppError('Erro no download de dados', exception: error));
    }

    return Resource.failure(AppError('Ocorreu algum erro'));
  }
}
