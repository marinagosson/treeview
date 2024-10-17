import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/models/company_model.dart';

abstract interface class CompanyRepository {
  Future<Resource<List<CompanyModel>>> fetchCompanies();
}
