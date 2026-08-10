import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:office_task/features/product/domain/model/product.dart';
import 'package:office_task/features/product/presentation/cubit/product_list_cubit.dart';
import 'package:office_task/features/product/presentation/cubit/product_list_state.dart';
import 'package:office_task/features/product/presentation/screen/product_detail.dart';
import 'package:office_task/widget/bottom_navigation.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()),
        BlocProvider(
          create: (context) => getIt<ProductListCubit>()..fetchFirstPage(),
        ),
      ],
      child: const _HomeScreenBody(),
    );
  }
}

class _HomeScreenBody extends StatefulWidget {
  const _HomeScreenBody();

  @override
  State<_HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<_HomeScreenBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductListCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1B1B1B),
      bottomNavigationBar: CustomBottomNavigation(),
      appBar: AppBar(
  backgroundColor: const Color(0xFF1B1B1B),
  elevation: 0,
  scrolledUnderElevation: 0,
  title: Container(
    height: 40,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color(0xFFFF4400),
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        const Icon(Icons.search, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Text(
          'Search products...',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    ),
  ),
   actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthCubit>().logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              }
            },
          ),
        ],
      ),
      

      body: Column(
        children: [
        
         SizedBox(height: 10,),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, size: 20,color: (Color(0xFFFF4400)),),
                SizedBox(width: 5,),
                Text('For You', style: TextStyle(color: (Color(0xFFFF4400)), fontWeight: FontWeight.bold),)
              ],
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: BlocBuilder<ProductListCubit, ProductListState>(
              builder: (context, state) {
                if (state is ProductListLoadingFirstPage) {
                  return const AppLoadingIndicator();
                }
            
                if (state is ProductListError) {
                  return AppErrorView(
                    message: state.message,
                    onRetry: () => context.read<ProductListCubit>().fetchFirstPage(),
                  );
                }
            
                List<Product> items = [];
                bool isLoadingMore = false;
            
                if (state is ProductListLoaded) {
                  items = state.items;
                } else if (state is ProductListLoadingMore) {
                  items = state.currentItems;
                  isLoadingMore = true;
                }
            
                return RefreshIndicator(
                  onRefresh: () => context.read<ProductListCubit>().fetchFirstPage(),
                  child: GridView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,           // exactly 2 columns
                crossAxisSpacing: 12,        // horizontal gap between cards
                mainAxisSpacing: 12,         // vertical gap between rows
                childAspectRatio: 0.68,      // width-to-height ratio of each card
              ),
              itemCount: items.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= items.length) {
            return const Center(child: CircularProgressIndicator());
                }
            
                final product = items[index];
                return InkWell(
                          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(productId: product.id),
              ),
            );
          },
                  child: Card(
                              color: Color(0xFF1B1B1B),
                              clipBehavior: Clip.antiAlias,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 Expanded(
                                child: Container(
                  color: Colors.white,
                  child: Image.network(
                              product.thumbnail,
                              width: double.infinity,
                              fit: BoxFit.cover,
                  ),
                                ),
                              ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rs ${product.price}',
                          style: const TextStyle(color: (Color(0xFFFF4400)), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                                ],
                              ),
                  ),
                );
              },
            ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}