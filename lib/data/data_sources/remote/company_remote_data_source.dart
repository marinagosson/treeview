import 'package:treeview_tractian/data/dtos/company_dto.dart';
import 'package:treeview_tractian/infra/services/remote_client/api_service.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';

abstract interface class CompanyRemoteDataSource {
  Future saveCompany();

  Future<Resource<List<CompanyDTO>>> getCompanies();
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final ApiService apiService;

  CompanyRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Resource<List<CompanyDTO>>> getCompanies() async {
    final response =
        await apiService.get('companies');
    if (response.isFailure()) return Resource.failure(response.error!);
    if (response.data != null) {
      try {
        return Resource.success(data: List.from(response.data!)
            .map((element) => CompanyDTO.fromJson(element))
            .toList());
      } catch (e) {
        return Resource.failure(
            AppError('Error parse CompanyDTO.fromJson, ${e.toString()}'));
      }
    } else {
      return Resource.success(data: []);
    }
  }

  @override
  Future saveCompany() async {
    throw UnimplementedError();
  }
}
