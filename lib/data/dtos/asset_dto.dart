import 'package:treeview_tractian/data/utils/parse_api_service.dart';

class AssetDTO {
  final String id; //
  final String name;
  final String? locationId;
  final String? parentId;
  final String? sensorType;
  final String? status;
  final String? gatewayId;
  final String? sensorId;

  AssetDTO(
      {required this.id,
      required this.name,
      this.locationId,
      this.parentId,
      this.status,
      this.sensorId,
      this.gatewayId,
      this.sensorType});

  factory AssetDTO.fromJson(Map<String, dynamic> json) {
    const source = 'AssetDTO';
    return AssetDTO(
      id: parseString(json, 'id', source) ?? '',
      name: parseString(json, 'name', source) ?? '',
      locationId: parseString(json, 'locationId', source),
      gatewayId: parseString(json, 'gatewayId', source),
      parentId: parseString(json, 'parentId', source),
      sensorType: parseString(json, 'sensorType', source),
      status: parseString(json, 'status', source),
      sensorId: parseString(json, 'sensorId', source),
    );
  }
}
