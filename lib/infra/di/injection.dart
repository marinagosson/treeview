import 'package:get_it/get_it.dart';
import 'package:treeview_tractian/data/data_sources/local/asset_local_data_source.dart';
import 'package:treeview_tractian/data/data_sources/local/company_local_data_source.dart';
import 'package:treeview_tractian/data/data_sources/local/daos/asset_dao.dart';
import 'package:treeview_tractian/data/data_sources/local/daos/company_dao.dart';
import 'package:treeview_tractian/data/data_sources/local/daos/location_dao.dart';
import 'package:treeview_tractian/data/data_sources/local/location_local_data_source.dart';
import 'package:treeview_tractian/data/data_sources/remote/asset_remote_data_source.dart';
import 'package:treeview_tractian/data/data_sources/remote/company_remote_data_source.dart';
import 'package:treeview_tractian/data/data_sources/remote/location_remotel_data_source.dart';
import 'package:treeview_tractian/data/repositories/assets_repository_impl.dart';
import 'package:treeview_tractian/data/repositories/company_repository_impl.dart';
import 'package:treeview_tractian/data/repositories/location_repository_impl.dart';
import 'package:treeview_tractian/infra/services/remote_client/api_service.dart';
import 'package:treeview_tractian/infra/services/database/database_service.dart';
import 'package:treeview_tractian/domain/repositories/asset_repository.dart';
import 'package:treeview_tractian/domain/repositories/company_repository.dart';
import 'package:treeview_tractian/domain/repositories/location_repository.dart';
import 'package:treeview_tractian/domain/use_cases/fetch_all_data_use_case.dart';
import 'package:treeview_tractian/domain/use_cases/fetch_assets_from_company_use_case.dart';
import 'package:treeview_tractian/domain/use_cases/fetch_companies_use_case.dart';

class Injection {
  static final instance = GetIt.instance;

  void init() {
    instance.registerLazySingleton<ApiService>(() => ApiService());
    instance.registerLazySingleton<DatabaseService>(
        () => DatabaseService()..database);

    // remote data sources
    instance.registerFactory<CompanyRemoteDataSource>(
        () => CompanyRemoteDataSourceImpl(apiService: instance<ApiService>()));
    instance.registerFactory<AssetRemoteDataSource>(
        () => AssetRemoteDataSourceImpl(apiService: instance<ApiService>()));
    instance.registerFactory<LocationRemoteDataSource>(
        () => LocationRemoteDataSourceImpl(apiService: instance<ApiService>()));

    // local data source
    instance.registerFactory<CompanyLocalDataSource>(() =>
        CompanyLocalDataSourceImpl(
            companyDAO:
                CompanyDAO(databaseService: instance<DatabaseService>())));
    instance.registerFactory<AssetLocalDataSource>(() =>
        AssetLocalDataSourceImpl(
            assetDAO: AssetDAO(databaseService: instance<DatabaseService>())));
    instance.registerFactory<LocationLocalDataSource>(() =>
        LocationLocalDataSourceImpl(
            locationDAO:
                LocationDAO(databaseService: instance<DatabaseService>())));

    // repositories
    instance.registerFactory<CompanyRepository>(() => CompanyRepositoryImpl(
        remoteDataSource: instance<CompanyRemoteDataSource>(),
        localDataSource: instance<CompanyLocalDataSource>()));
    instance.registerFactory<AssetRepository>(() => AssetsRepositoryImpl(
        remoteDataSource: instance<AssetRemoteDataSource>(),
        localDataSource: instance<AssetLocalDataSource>()));
    instance.registerFactory<LocationRepository>(() => LocationRepositoryImpl(
        remoteDataSource: instance<LocationRemoteDataSource>(),
        localDataSource: instance<LocationLocalDataSource>()));

    // use cases
    instance.registerFactory<FetchAndSaveAllDataUseCase>(() =>
        FetchAndSaveAllDataUseCaseImpl(
            companyRepository: instance<CompanyRepository>(),
            locationRepository: instance<LocationRepository>(),
            assetRepository: instance<AssetRepository>()));
    instance
        .registerFactory<FetchCompaniesUseCase>(() => FetchCompaniesUseCaseImpl(
              companyRepository: instance<CompanyRepository>(),
            ));
    instance.registerFactory<FetchAssetsFromCompanyUseCase>(
        () => FetchAssetsFromCompanyUseCaseImpl(
              locationRepository: instance<LocationRepository>(),
              assetRepository: instance<AssetRepository>(),
            ));
  }
}
