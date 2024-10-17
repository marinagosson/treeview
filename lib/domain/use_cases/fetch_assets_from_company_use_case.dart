import 'dart:async';

import 'package:treeview_tractian/infra/services/isolates/process_data_from_database_to_tree_view_isolate_service.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/repositories/asset_repository.dart';
import 'package:treeview_tractian/domain/repositories/location_repository.dart';
import 'package:treeview_tractian/presenter/view_model/tree_node_model.dart';

abstract interface class FetchAssetsFromCompanyUseCase {
  Future<Resource<List<TreeNode>>> call(String companyId);
}

class FetchAssetsFromCompanyUseCaseImpl
    implements FetchAssetsFromCompanyUseCase {
  final AssetRepository assetRepository;
  final LocationRepository locationRepository;

  FetchAssetsFromCompanyUseCaseImpl(
      {required this.assetRepository, required this.locationRepository});

  @override
  Future<Resource<List<TreeNode>>> call(String companyId) async {
    Completer<Resource<List<TreeNode>>> completer = Completer();

    final assets = await assetRepository.fetchAssetsFromCompany(companyId);
    final locations = await locationRepository
        .fetchLocationsFromCompanyFromStorage(companyId);

    if (assets.data != null && locations.data != null) {
      ProcessDataFromDatabaseToTreeViewIsolateService()
          .process(assets.data!, locations.data!, completer);
    } else {
      completer.complete(Resource.success(data: []));
    }

    return completer.future;
  }
}
