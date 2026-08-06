
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/product_repository.dart';
import '../../domain/model/product.dart';
import 'product_list_state.dart';

@injectable
class ProductListCubit extends Cubit<ProductListState> {
  final ProductRepository productRepository;

  static const int _pageSize = 10;

  int _skip = 0;
  bool _isFetching = false;
  List<Product> _allItems = [];

  ProductListCubit(this.productRepository) : super(ProductListInitial());

  Future<void> fetchFirstPage() async {
    _skip = 0;
    _allItems = [];
    emit(ProductListLoadingFirstPage());

    try {
      _isFetching = true;
      final response = await productRepository.getProducts(
        limit: _pageSize,
        skip: _skip,
      );
      _allItems = response.products;
      _skip = response.skip + response.limit;
      final hasReachedMax = _skip >= response.total;

      emit(ProductListLoaded(items: _allItems, hasReachedMax: hasReachedMax));
    } catch (e) {
      emit(ProductListError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> loadMore() async {
    if (_isFetching) return;
    if (state is ProductListLoaded && (state as ProductListLoaded).hasReachedMax) {
      return;
    }

    _isFetching = true;
    emit(ProductListLoadingMore(_allItems));

    try {
      final response = await productRepository.getProducts(
        limit: _pageSize,
        skip: _skip,
      );
      _allItems = [..._allItems, ...response.products];
      _skip = response.skip + response.limit;
      final hasReachedMax = _skip >= response.total;

      emit(ProductListLoaded(items: _allItems, hasReachedMax: hasReachedMax));
    } catch (e) {
      emit(ProductListError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }
}