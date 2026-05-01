import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:electronics_shop/core/utils/components/product_container.dart';
import 'package:electronics_shop/routes/routes.dart';

class ProductRowList extends StatelessWidget {
  static const double _horizontalPadding = 16.0;
  static const double _mainAxisSpacing = 12.0;
  final List<ProductModel> products;
  final String? heroTagPrefix;

  const ProductRowList({super.key, required this.products, this.heroTagPrefix});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 280, // Adjust height as needed
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Container(
              width: 170, // Adjust width as needed
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 0,
                right: _mainAxisSpacing,
              ),
              // child: null, // Just a placeholder, we use GestureDetector
              // Wait, the syntax:
              child: GestureDetector(
                onTap: () => context.push(
                  AppRoutes.productDetails,
                  extra: {'product': product, 'heroTagPrefix': heroTagPrefix},
                ),
                child: ProductContainer(
                  heroTagPrefix: heroTagPrefix,
                  product: product,
                  showName: true,
                  isBackgroundWhite: false,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
