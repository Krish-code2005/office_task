import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:office_task/core/services/local_notification_service.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../cubit/product_detail_cubit.dart';
import '../cubit/product_detail_state.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductDetailCubit>()..fetchProduct(productId),
      child: Scaffold(
        backgroundColor: Color(0xFF1B1B1B),
        appBar: AppBar(title: const Text('Product Details', style: TextStyle(color: Colors.white),), backgroundColor:  Color(0xFF1B1B1B),iconTheme: const IconThemeData(color: Colors.white),),
        body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoading) {
              return const AppLoadingIndicator();
            }
            if (state is ProductDetailError) {
              return AppErrorView(
                message: state.message,
                onRetry: () => context.read<ProductDetailCubit>().fetchProduct(productId),
              );
            }
            if (state is ProductDetailLoaded) {
              final product = state.product;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                                    Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.white,
                  child: Image.network(
                    product.thumbnail,
                    fit: BoxFit.contain,
                  ),
                ),
                    const SizedBox(height: 16),
                    Text(product.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    Text('Rs ${product.price}', style: const TextStyle(fontSize: 18, color: Color(0xFFFF4400), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text(product.description, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white)),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.notifications_outlined),
                        label: const Text('Remind me'),
                        onPressed: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reminder set for 10 seconds from now'), backgroundColor: Color(0xFFFF4400),),
                          );
                          await getIt<LocalNotificationService>().scheduleReminder(
                            title: product.title,
                            body: 'Rs ${product.price} — check it out!',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}