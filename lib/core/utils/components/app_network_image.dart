import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/functions/cache_manager.dart';

/// A shared, reusable network image widget with loading, error, and Hero support.
///
/// Replaces the duplicate implementations in:
/// - `order/widgets/build_product_image.dart`
/// - `wishlist/widget/build_product_image.dart`
/// - `cart/widgets/build_product_cart_image.dart`
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width = 80.0,
    this.height = 80.0,
    this.borderRadius = 8.0,
    this.fit = BoxFit.cover,
    this.heroTag,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;

  /// If provided, wraps the image in a [Hero] widget with the given tag.
  final String? heroTag;

  final int? memCacheWidth;
  final int? memCacheHeight;

  @override
  Widget build(BuildContext context) {
    final child = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: _buildImage(context),
    );

    if (heroTag != null) {
      return Hero(tag: heroTag!, child: child);
    }
    return child;
  }

  Widget _buildImage(BuildContext context) {
    final url = imageUrl ?? '';
    if (url.isEmpty) return _buildErrorWidget(context);

    return CachedNetworkImage(
      cacheManager: CustomCacheManager.instance,
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      placeholder: (context, _) => _buildPlaceholder(context),
      errorWidget: (context, _, __) => _buildErrorWidget(context),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2.0,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.primary.withValues(alpha: .5),
        size: width * 0.4,
      ),
    );
  }
}
