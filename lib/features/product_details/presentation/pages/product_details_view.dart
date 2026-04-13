import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/utils/functions/cache_manager.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/product_details/presentation/controllers/product_details_controller.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/bottom_icons_row.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/build_product_price.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/image_list_view.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/product_color_selector.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/build_description_section.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/build_product_name.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/build_show_reviews_list_section.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/main_image.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/build_product_badges.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/build_product_info.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/build_technical_specs_section.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/build_warranty_section.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/product_size_selector.dart';

class ProductDetailsView extends ConsumerWidget {
  static const double _contentPadding = 16.0;
  static const double _sectionSpacing = 24.0;
  static const double _smallSpacing = 8.0;
  static const double _mediumSpacing = 16.0;
  static const double _bottomPadding = 32.0;

  final ProductModel? product;
  final String? initialColor;
  final String? initialSize;

  const ProductDetailsView({
    super.key,
    this.product,
    this.initialColor,
    this.initialSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (product == null) {
      return const Scaffold(body: Center(child: Text("Product not found")));
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;

    final detailsState = ref.watch(
      productDetailsControllerProvider(
        product!,
        initialColor: initialColor,
        initialSize: initialSize,
      ),
    );
    final detailsNotifier = ref.watch(
      productDetailsControllerProvider(
        product!,
        initialColor: initialColor,
        initialSize: initialSize,
      ).notifier,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(product!.getLocalizedName(locale: locale)),
        elevation: 0,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: MainImage(
              product: product!,
              onImageTap: (index) => _showImageViewer(context, index),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(_contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.surfaceDark.withAlpha(100),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildProductName(product!),
                        const SizedBox(
                          width: double.infinity,
                          height: _smallSpacing,
                        ),
                        buildProductPrice(
                          product!,
                          alternateEffectivePrice: detailsNotifier
                              .getDisplayEffectivePrice(product!),
                          alternateOriginalPrice: detailsNotifier
                              .getDisplayPrice(product!),
                          alternateHasDiscount: detailsNotifier
                              .getDisplayHasDiscount(product!),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: _smallSpacing),
                  buildProductBadges(product!, context, .1),
                  const SizedBox(height: _mediumSpacing),
                  ImageListView(product: product!),
                  const SizedBox(height: _mediumSpacing),
                  if (product!.colors.isNotEmpty) ...[
                    ProductColorSelector(
                      product: product!,
                      selectedColor: detailsState.selectedColor,
                      onColorSelected: (selectedColor) {
                        detailsNotifier.updateColor(selectedColor);
                      },
                    ),
                    const SizedBox(height: _mediumSpacing),
                  ],
                  if (product!.productSizes.isNotEmpty) ...[
                    ProductSizeSelector(
                      product: product!,
                      initialSize: detailsState.selectedSizeObject?.size,
                      onSizeSelected: (selectedSize) {
                        detailsNotifier.updateSize(product!, selectedSize);
                      },
                    ),
                    const SizedBox(height: _mediumSpacing),
                  ],
                  if (product!.imageUrls.length > 1)
                    const SizedBox(height: _sectionSpacing),
                  buildDescriptionSection(product!),
                  const SizedBox(height: _sectionSpacing),
                  buildProductInfo(product!, isDark, context, ref),
                  const SizedBox(height: _sectionSpacing),
                  buildTechnicalSpecsSection(product!, isDark),
                  const SizedBox(height: _sectionSpacing),
                  buildWarrantySection(product!, isDark),
                  const SizedBox(height: _sectionSpacing),
                  buildShowReviewsListSection(product!),
                  const SizedBox(height: _bottomPadding),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomIconsRow(product: product!),
    );
  }

  void _showImageViewer(BuildContext context, int initialIndex) {
    if (product!.imageUrls.isEmpty) return;

    MultiImageProvider multiImageProvider = MultiImageProvider(
      product!.imageUrls
          .map(
            (url) => CachedNetworkImageProvider(
              url.original,
              cacheManager: CustomCacheManager.instance,
            ),
          )
          .toList(),
      initialIndex: initialIndex,
    );

    showImageViewerPager(
      context,
      multiImageProvider,
      useSafeArea: true,
      swipeDismissible: true,
      doubleTapZoomable: true,
      immersive: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      closeButtonColor: Theme.of(context).primaryColor,
    );
  }
}
