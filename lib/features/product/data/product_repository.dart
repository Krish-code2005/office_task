import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/error/dio_error_mapper.dart';
import '../../../core/network/dio_client.dart';
import '../domain/model/product_list_response.dart';

@lazySingleton
class ProductRepository {
  final DioClient dioClient;

  ProductRepository(this.dioClient);

  Future<ProductListResponse> getProducts({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await dioClient.dio.get('/products', queryParameters: {
        'limit': limit,
        'skip': skip,
      });
      return ProductListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw mapDioExceptionToFailure(e);
    }
  }
}