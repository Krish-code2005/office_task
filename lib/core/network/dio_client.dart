import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@lazySingleton
class DioClient {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  static const String accessTokenKey = 'accessToken';

  DioClient(this.secureStorage)
      : dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com')) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
    )); //prints every request response for easier debugging


//runs before every outgoing request 
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await secureStorage.read(key: accessTokenKey);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options); //lets a request continue after an interceptor runs
      },
    ));
  }
}