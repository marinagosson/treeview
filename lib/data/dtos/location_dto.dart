import 'package:treeview_tractian/data/utils/parse_api_service.dart';

class LocationDTO {
  final String id;
  final String name;
  final String? parentId;

  LocationDTO({required this.id, required this.name, this.parentId});

  factory LocationDTO.fromJson(Map<String, dynamic> json) {
    const source = 'LocationDTO';
    return LocationDTO(
      id: parseString(json, 'id', source) ?? '',
      name: parseString(json, 'name', source) ?? '',
      parentId: parseString(json, 'parentId', source)
    );
  }
}
