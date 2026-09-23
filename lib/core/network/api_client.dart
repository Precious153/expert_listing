import 'package:dio/dio.dart';
import 'api_exceptions.dart';
import '../storage/secure_storage.dart';
import '../di/injection_container.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({required String baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,

          ),
        ) {
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final storage = sl<SecureStorage>();
          final token = await storage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          String message = 'Something went wrong';
          Map<String, dynamic>? errors;
          
          if (e.response != null) {
            final data = e.response?.data;
            if (data is Map<String, dynamic>) {
              message = data['message'] ?? message;
              errors = data['errors'] as Map<String, dynamic>?;
            }
          }

          ApiException exception;
          switch (e.response?.statusCode) {
            case 401:
              exception = UnauthorizedException(message);
              break;
            case 422:
              exception = ValidationException(message, errors: errors);
              break;
            case 500:
              exception = ServerException(message);
              break;
            default:
              if (e.type == DioExceptionType.connectionTimeout ||
                  e.type == DioExceptionType.receiveTimeout) {
                exception = TimeoutException('Connection timed out');
              } else if (e.type == DioExceptionType.connectionError) {
                exception = NetworkException('No internet connection');
              } else {
                exception = ApiException(message, statusCode: e.response?.statusCode);
              }
          }
          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: exception,
              response: e.response,
              type: e.type,
            ),
          );
        },
      ),
    );
  }

  Dio get dio => _dio;
}
