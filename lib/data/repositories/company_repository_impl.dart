import 'package:flutter/foundation.dart';
import 'package:treeview_tractian/data/data_sources/local/company_local_data_source.dart';
import 'package:treeview_tractian/data/data_sources/remote/company_remote_data_source.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/models/company_model.dart';
import 'package:treeview_tractian/domain/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  CompanyRemoteDataSource remoteDataSource;
  CompanyLocalDataSource localDataSource;

  CompanyRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Resource<List<CompanyModel>>> fetchCompanies() async {
    final Resource<List<CompanyModel>> resourceLocal =
        await localDataSource.readAll();

    if (resourceLocal.data != null && resourceLocal.data!.isNotEmpty) {
      return Resource.success(data: resourceLocal.data!);
    }

    final resourceRemote = await remoteDataSource.getCompanies();

    if (resourceRemote.isFailure()) {
      return Resource.failure(resourceRemote.error!);
    }

    if (resourceRemote.data != null) {
      try {
        return Resource.success(
            data: resourceRemote.data!
                .map((element) => CompanyModel.parseFromDTO(element))
                .toList());
      } catch (error) {
        return Resource.failure(AppError(
            'Error parse CompanyModel.parseFromDTO',
            exception: error));
      }
    } else {
      return Resource.success(data: []);
    }
  }
}
