import 'package:treeview_tractian/data/data_sources/local/daos/asset_dao.dart';
import 'package:treeview_tractian/data/dtos/asset_dto.dart';

class AssetModel {
  final String id;
  final String name;
  final String companyId;
  final String? locationId;
  final String? parentId;
  final String? sensorType;
  final String? status;
  final String? gatewayId;
  final String? sensorId;

  AssetModel(
      {required this.id,
      required this.name,
      required this.companyId,
      this.sensorType,
      this.status,
      this.gatewayId,
      this.sensorId,
      this.locationId,
      this.parentId});

  factory AssetModel.parseFromDTO(AssetDTO dto, String companyId) => AssetModel(
      id: dto.id,
      name: dto.name,
      locationId: dto.locationId,
      parentId: dto.parentId,
      status: dto.status,
      sensorId: dto.sensorId,
      sensorType: dto.sensorType,
      companyId: companyId,
      gatewayId: dto.gatewayId);

  factory AssetModel.parseFromDatabase(Map<String, dynamic> map) => AssetModel(
      id: map[AssetDAO.tableFieldID],
      name: map[AssetDAO.tableFieldName],
      locationId: map[AssetDAO.tableFieldLocationId],
      parentId: map[AssetDAO.tableFieldParentId],
      gatewayId: map[AssetDAO.tableFieldGatewayId],
      sensorId: map[AssetDAO.tableFieldSensorId],
      sensorType: map[AssetDAO.tableFieldSensorType],
      companyId: map[AssetDAO.tableFieldCompanyId],
      status: map[AssetDAO.tableFieldStatus]);

  Map<String, dynamic> parseToDatabase() => {
        AssetDAO.tableFieldID: id,
        AssetDAO.tableFieldCompanyId: companyId,
        AssetDAO.tableFieldName: name,
        AssetDAO.tableFieldParentId: parentId,
        AssetDAO.tableFieldSensorType: sensorType,
        AssetDAO.tableFieldLocationId: locationId,
        AssetDAO.tableFieldGatewayId: gatewayId,
        AssetDAO.tableFieldSensorId: sensorId,
        AssetDAO.tableFieldStatus: status
      };
}
