import 'package:equatable/equatable.dart';

import '../../domain/model/product.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoadingFirstPage extends ProductListState {}

class ProductListLoadingMore extends ProductListState {
  final List<Product> currentItems;
  const ProductListLoadingMore(this.currentItems);

  @override
  List<Object?> get props => [currentItems];
}

class ProductListLoaded extends ProductListState {
  final List<Product> items;
  final bool hasReachedMax;

  const ProductListLoaded({
    required this.items,
    required this.hasReachedMax,
  });

  @override
  List<Object?> get props => [items, hasReachedMax];
}

class ProductListError extends ProductListState {
  final String message;
  const ProductListError(this.message);

  @override
  List<Object?> get props => [message];
}