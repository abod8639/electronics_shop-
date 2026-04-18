import 'package:cached_network_image/cached_network_image.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/color_variant_image.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:electronics_shop/core/utils/functions/cache_manager.dart';
import 'package:electronics_shop/features/cart/data/models/cart_item_model.dart';
import 'package:electronics_shop/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartItemCard extends ConsumerWidget {
  final CartItemModel item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        boxShadow: [
          
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: .15),
            blurRadius: 15,
            spreadRadius: -5,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: ClipPath(
        clipper: CyberpunkShapeClipper(),
        child: Container(
          decoration: BoxDecoration(

            color: theme.colorScheme.surface.withValues(alpha: .9),
            border: Border.all(color: AppColors.cyan.withValues(alpha: .5), width: 0.5),
          ),
          child: InkWell(
            onTap: () => context.push(
              AppRoutes.productDetails,
              extra: {
                'product': item.product,
                'selectedColor': item.selectedColor,
                'selectedSize': item.selectedSize,
              },
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.cyan.withValues(alpha: .3)),
                    ),
                    child: CachedNetworkImage(
                      cacheManager: CustomCacheManager.instance,
                      imageUrl: item.product.imageUrls.isNotEmpty
                          ? item.product.imageUrls.first.thumbnail
                          : '',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => const Icon(Icons.image, size: 40),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.getLocalizedName(locale: locale).toUpperCase(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            color: AppColors.cyan,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        if ( item.selectedSize != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundDark ,
                            ),
                            child: Text(
                              '${item.selectedColor ?? ""} ${item.selectedSize ?? ""}'.trim(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.cyan,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${item.product.baseEffectivePrice} LE',
                              style: const TextStyle(
                                color: AppColors.magenta ,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                                fontSize: 16,
                                shadows: [
                                  Shadow(color: AppColors.magenta, blurRadius: 4),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (item.product.basePrice > item.product.baseEffectivePrice)
                              Text(
                                '${item.product.basePrice}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),

                                                    //  QuantityControls(product: item.product),
                                             Container(
                                              
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.cyan.withValues(alpha: 0.5)),
                          color: AppColors.cyan.withValues(alpha: 0.1),
                        ),
                        child: Text(
                          'QTY: ${item.quantity}',
                          style: const TextStyle(
                            color: AppColors.cyan,
                            fontFamily: 'monospace',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                          ],

                        ),


                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  const SizedBox(width: 8),
                  
                  

                  if (item.selectedColor != null) ...[
                    Builder(
                      builder: (context) {
                        final details = electronicsColorsData[item.selectedColor!.toLowerCase()];
                        return ColorVariantImage(
                          shadow: true,
                          isSelected: false,
                          baseColor: details?.color ?? AppColors.primary,
                          details: details ?? electronicsColorsData['default']!,
                          width: 34,
                          height: 34,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
