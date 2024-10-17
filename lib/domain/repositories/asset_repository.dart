import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/models/asset_model.dart';

abstract interface class AssetRepository {
  Future<Resource<List<AssetModel>>> downloadAssetsFromCompany(
      String companyId);

  Future<Resource<List<AssetModel>>> fetchAssetsFromCompany(
      String companyId);
}
