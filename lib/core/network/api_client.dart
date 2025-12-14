import 'package:dio/dio. dart';
import 'package: flutter/foundation.dart';
import '../constants/api_constants.dart';
import 'api_exception.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds:  30),
        queryParameters: {
          'appid': ApiConstants.apiKey,
          'units': ApiConstants.metricUnits,
        },
      ),
    );

    // Add interceptors for logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader:  true,
          responseHeader: false,
          error: true,
        ),
      );
    }

    // Add error handling interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) {
          final apiException = _handleError(error);
          handler.reject(
            DioException(
              requestOptions:  error.requestOptions,
              error: apiException,
            ),
          );
        },
      ),
    );
  }

  Dio get dio => _dio;

  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout.  Please check your internet connection.',
          statusCode: error.response?.statusCode,
        );

      case DioExceptionType. badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 'Something went wrong';
        
        if (statusCode == 404) {
          return ApiException(
            message: 'City not found. Please try another location.',
            statusCode: statusCode,
          );
        } else if (statusCode == 401) {
          return ApiException(
            message: 'API key is invalid or expired.',
            statusCode: statusCode,
          );
        }
        
        return ApiException(
          message: message,
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request was cancelled',
          statusCode: null,
        );

      case DioExceptionType.unknown:
        if (error.error. toString().contains('SocketException')) {
          return ApiException(
            message: 'No internet connection. Please check your network.',
            statusCode: null,
          );
        }
        return ApiException(
          message:  'Unexpected error occurred',
          statusCode: null,
        );

      default:
        return ApiException(
          message: 'Something went wrong',
          statusCode: null,
        );
    }
  }
}