import 'package:treeview_tractian/data/utils/parse_api_service.dart';

class CompanyDTO {
  final String id;
  final String name;

  CompanyDTO({required this.id, required this.name});

  factory CompanyDTO.fromJson(Map<String, dynamic> json) {
    const source = 'CompanyDTO';
    return CompanyDTO(
        id: parseString(
              json,
              'id',
              source,
            ) ??
            '',
        name: parseString(json, 'name', source) ?? '');
  }
}
