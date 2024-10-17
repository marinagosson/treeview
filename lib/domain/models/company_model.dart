import 'package:treeview_tractian/data/data_sources/local/daos/company_dao.dart';
import 'package:treeview_tractian/data/dtos/company_dto.dart';

class CompanyModel {
  final String id;
  final String name;

  CompanyModel({required this.id, required this.name});

  factory CompanyModel.parseFromDTO(CompanyDTO dto) =>
      CompanyModel(id: dto.id, name: dto.name);

  factory CompanyModel.parseFromDatabase(Map<String, dynamic> map) => CompanyModel(
      id: map[CompanyDAO.tableFieldID], name: map[CompanyDAO.tableFieldName]);

  Map<String, dynamic> parseToDatabase() {
    return {CompanyDAO.tableFieldID: id, CompanyDAO.tableFieldName: name};
  }
}
