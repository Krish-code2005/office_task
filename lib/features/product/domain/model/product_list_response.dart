import 'package:equatable/equatable.dart';

import 'product.dart';

class ProductListResponse extends Equatable {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  const ProductListResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] as List;
    return ProductListResponse(
      products: productsJson.map((p) => Product.fromJson(p)).toList(),
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }

  @override
  List<Object?> get props => [products, total, skip, limit];
}