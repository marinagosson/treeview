import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/models/location_model.dart';

abstract interface class LocationRepository {
  Future<Resource<List<LocationModel>>> downloadLocationFromCompany(
      String company);

  Future<Resource<List<LocationModel>>>
      fetchLocationsFromCompanyFromStorage(String company);
}
