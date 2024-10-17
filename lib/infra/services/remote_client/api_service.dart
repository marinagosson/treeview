import 'package:dio/dio.dart';
import 'package:treeview_tractian/infra/services/remote_client/interceptors/logging_interceptor.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio();
    _dio.options.baseUrl = 'https://fake-api.tractian.com/';
    _dio.interceptors.add(LoggingInterceptor());
    _dio.options.connectTimeout = const Duration(milliseconds: 5000);
  }

  Future<Resource<dynamic>> get(String url) async {
    try {
      var response = await _dio.get(url);
      return Resource.success(
        data: response.data,
      );
    } on DioException catch (error) {
      switch (error.type) {
        case DioExceptionType.connectionError || DioExceptionType.connectionTimeout:
          return Resource.failure(AppError(
              'Ocorreu algum erro na conexão. Verifique sua conexão e tente novamente. Se o erro persistir, tente novamente mais tarde.'));
        default:
          return Resource.failure(AppError(
              'Op\'s, ocorreu um erro na comunicação tente novamente mais tarde.'));
      }
    }
  }
}
