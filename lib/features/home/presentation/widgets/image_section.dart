import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:electronics_shop/core/utils/functions/cache_manager.dart';
import 'package:electronics_shop/core/utils/components/product_container.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/build_product_badges.dart';
import 'image_indicators.dart';

class ImageSection extends StatefulWidget {
  const ImageSection({super.key, required this.widget});

  final ProductContainer widget;

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  late final PageController _pageController;
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final images = widget.widget.product.imageUrls;

    return GestureDetector(
      onTap: widget.widget.onTap,
      child: Stack(
        children: [
          Container(
            width: double.maxFinite,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromARGB(47, 30, 30, 30),
              //  theme.colorScheme.surfaceContainerLowest,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16.0),
              ),
              child: images.isEmpty
                  ? buildNoImage(theme)
                  : PageView.builder(
                      allowImplicitScrolling: true,
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                        if (widget.widget.onPageChanged != null) {
                          widget.widget.onPageChanged!(index);
                        }
                      },
                      itemBuilder: (context, index) {
                        return buildImage(
                          images[index].medium,
                          theme,
                          widget.widget.product.isBackgroundWhite,
                          index,
                        );
                      },
                    ),
            ),
          ),

          if (images.length > 1)
            ImageIndicators(
              product: widget.widget.product,
              selectedImageIndex: _selectedImageIndex,
            ),

          if (widget.widget.product.discountPrice != null)
            Positioned(
              top: 12,
              right: 15,
              child: buildProductBadges(widget.widget.product, context, .5),
            ),
          // Positioned(
          //   top: 12,
          //   right: 15,
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //     decoration: BoxDecoration(
          //       color: Colors.redAccent,
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     child: const Text(
          //       'خصم',
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 10,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildImage(String url, ThemeData theme, bool isBackgroundWhite, int index) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isBackgroundWhite
            ? Colors.white.withValues(alpha: .9)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Hero(
          tag: index == 0 ? '${widget.widget.heroTagPrefix ?? ''}product_image_${widget.widget.product.id}' : '${widget.widget.heroTagPrefix ?? ''}product_image_${widget.widget.product.id}_$index',
          child: CachedNetworkImage(
            cacheManager: CustomCacheManager.instance,
            imageUrl: url,
            fit: BoxFit.scaleDown,
            placeholder: (context, url) => buildShimmerEffect(theme),
            errorWidget: (context, url, error) => buildErrorWidget(theme),
          ),
        ),
      ),
    );
  }

  Widget buildShimmerEffect(ThemeData theme) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: theme.colorScheme.primary.withValues(alpha: .5),
      ),
    );
  }

  Widget buildNoImage(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 40,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 4),
          Text('لا توجد صور', style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }

  Widget buildErrorWidget(ThemeData theme) {
    return Container(
      color: theme.colorScheme.errorContainer.withValues(alpha: .2),
      child: Icon(Icons.broken_image_outlined, color: theme.colorScheme.error),
    );
  }
}
