import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/product_repository.dart';
import 'product_detail_state.dart';

@injectable
class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductRepository productRepository;

  ProductDetailCubit(this.productRepository) : super(ProductDetailInitial());

  Future<void> fetchProduct(int id) async {
    emit(ProductDetailLoading());
    try {
      final product = await productRepository.getProductById(id);
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }
}