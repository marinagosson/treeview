import 'package:treeview_tractian/data/data_sources/local/daos/location_dao.dart';
import 'package:treeview_tractian/data/dtos/location_dto.dart';

class LocationModel {
  final String id;
  final String name;
  final String companyId;
  final String? parentId;

  LocationModel(
      {required this.id,
      required this.name,
      required this.companyId,
      this.parentId});

  factory LocationModel.parseFromDTO(LocationDTO dto, String companyId) =>
      LocationModel(
          id: dto.id,
          name: dto.name,
          parentId: dto.parentId,
          companyId: companyId);

  Map<String, dynamic> parseToDatabase() => {
        LocationDAO.tableFieldID: id,
        LocationDAO.tableFieldParentId: parentId,
        LocationDAO.tableFieldName: name,
        LocationDAO.tableFieldCompanyId: companyId
      };

  factory LocationModel.parseFromDatabase(Map<String, dynamic> map) => LocationModel(
      id: map[LocationDAO.tableFieldID],
      name: map[LocationDAO.tableFieldName],
      parentId: map[LocationDAO.tableFieldParentId],
      companyId: map[LocationDAO.tableFieldCompanyId]);
}
