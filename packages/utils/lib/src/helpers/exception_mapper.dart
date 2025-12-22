import 'package:dart_mappable/dart_mappable.dart';
import 'package:dio/dio.dart';

class ExceptionMapper {
  static String map(Object? error) {
    if (error is DioException) {
      return _mapDioException(error);
    }
    if (error is MapperException) {
      return 'Data error: ${error.message}';
    }
    // Add other custom exceptions here (e.g., AuthException)

    // Default fallback
    return error?.toString() ?? 'An unexpected error occurred';
  }

  static String _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet connection.';
      case DioExceptionType.badResponse:
        return _mapBadResponse(error.response);
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Network error occurred. Please try again.';
    }
  }

  static String _mapBadResponse(Response<dynamic>? response) {
    if (response == null) return 'Server error occurred.';

    // Try to parse message from backend response if available
    // Assuming standard format: { "message": "error description" }
    try {
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('message')) {
          return data['message'].toString();
        }
      }
    } catch (_) {
      // ignore parse errors
    }

    // Fallback based on status code
    switch (response.statusCode) {
      case 400:
        return 'Invalid request.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Internal server error. Please try again later.';
      default:
        return 'Error: ${response.statusCode}';
    }
  }
}
