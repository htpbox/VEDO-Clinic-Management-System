import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:medicore/core/constants/app_constants.dart';
import 'package:medicore/core/errors/app_exception.dart';
import 'package:medicore/core/storage/storage_service.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final _logger = Logger();

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl + AppConstants.apiVersion,
      connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.addAll([_authInterceptor(), _errorInterceptor()]);

  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await StorageService.instance.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    );
  }

  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        _logger.e('API Error: ${error.message}');
        if (error.response?.statusCode == 401) {
          await StorageService.instance.clearAll();
          final data = error.response?.data;
          final backendMessage = (data is Map<String, dynamic>)
              ? data['message'] as String?
              : null;
          throw UnauthorizedException(
            message: backendMessage ?? 'غير مصرح بالوصول',
          );
        }
        handler.next(error);
      },
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    try {
      return await _dio.get(path, queryParameters: params);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// For binary downloads (e.g. backup files) - returns raw bytes instead of
  /// going through the JSON envelope the other methods expect.
  Future<Response<List<int>>> download(String path) async {
    try {
      return await _dio.get<List<int>>(
        path,
        options: Options(responseType: ResponseType.bytes),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] as String? ?? 'حدث خطأ';
        if (statusCode == 401) return const UnauthorizedException();
        return ServerException(message: message, statusCode: statusCode);
      default:
        return const NetworkException();
    }
  }
}
