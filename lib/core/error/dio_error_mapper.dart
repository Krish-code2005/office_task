import 'package:dio/dio.dart';

import 'failure.dart';

Failure mapDioExceptionToFailure(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure('No internet connection. Please try again.');

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final serverMessage = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : null;

      if (statusCode == 401) {
        return UnauthorizedFailure(serverMessage ?? 'Session expired. Please log in again.');
      }
      return ServerFailure(serverMessage ?? 'Something went wrong (code $statusCode).');

    default:
      return UnknownFailure(e.message ?? 'Unexpected error occurred.');
  }
}