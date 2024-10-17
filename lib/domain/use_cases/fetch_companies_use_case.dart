import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/models/company_model.dart';
import 'package:treeview_tractian/domain/repositories/company_repository.dart';

abstract interface class FetchCompaniesUseCase {
  Future<Resource<List<CompanyModel>>> call();
}

class FetchCompaniesUseCaseImpl implements FetchCompaniesUseCase {

  final CompanyRepository companyRepository;

  FetchCompaniesUseCaseImpl({required this.companyRepository});

  @override
  Future<Resource<List<CompanyModel>>> call() {
    return companyRepository.fetchCompanies();
  }

}