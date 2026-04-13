import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/functions/cache_manager.dart';

class ProductColorModel {
  final String name;
  final Color color;
  final String? image;
  ProductColorModel({required this.name, required this.color, this.image});
}

final Map<String, ProductColorModel> electronicsColorsData = {
  "black": ProductColorModel(
    name: "Obsidian Black",
    color: const Color(0xFF121212),
    // image: "https://images.unsplash.com/photo-1550009158-9ebf69173e03?auto=format&fit=crop&q=80&w=800",
  ),
  "white": ProductColorModel(
    name: "Pearl White",
    color: const Color(0xFFF5F5F7),
    // image: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&q=80&w=800",
  ),
  "silver": ProductColorModel(
    name: "Space Silver",
    color: const Color(0xFFBEC2CB),
    // image: "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&q=80&w=800",
  ),
  "gold": ProductColorModel(
    name: "Champagne Gold",
    color: const Color(0xFFE6CA97),
    // image: "https://images.unsplash.com/photo-1616348436168-de43ad0db179?auto=format&fit=crop&q=80&w=800",
  ),
  "blue": ProductColorModel(
    name: "Midnight Blue",
    color: const Color(0xFF1A3A5F),
    // image: "https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?auto=format&fit=crop&q=80&w=800",
  ),
  "grey": ProductColorModel(
    name: "Graphite",
    color: const Color(0xFF3C3C3C),
    // image: "https://images.unsplash.com/photo-1510511459019-5dee997d7ec1?auto=format&fit=crop&q=80&w=800",
  ),
  "default": ProductColorModel(
    name: "Standard",
    color: AppColors.primary,
    // image: "https://images.unsplash.com/photo-1588508065123-287b28e013da?auto=format&fit=crop&q=80&w=800",
  ),
};

class ColorVariantImage extends StatelessWidget {
  const ColorVariantImage({
    super.key,
    required this.isSelected,
    required this.baseColor,
    required this.details,
    this.width,
    this.height,
    this.shadow,
  });

  final bool? shadow;
  final bool isSelected;
  final Color baseColor;
  final ProductColorModel details;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width ?? 110,
      height: height ?? 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.grey,
          width: 3,
        ),

        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: baseColor.withValues(alpha: .4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : [],
        // image: details.image != null
            // ? 
            // DecorationImage(
            //     image: CachedNetworkImageProvider(
            //       details.image!,
            //       cacheManager: CustomCacheManager.instance,
            //     ),
            //     fit: BoxFit.cover,
            //     colorFilter: shadow == true
            //         ? ColorFilter.mode(
            //             isSelected
            //                 ? Colors.black.withValues(alpha: .2)
            //                 : Colors.black.withValues(alpha: .5),
            //             BlendMode.darken,
            //           )
            //         : null,
            //   )
            // : null,
        color:
        //  details.image == null ?
          baseColor,//
          //  : null,
      ),
      child: Center(
        child: Text(
          details.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 12,
            shadows: [
              Shadow(
                blurRadius: 8,
                color: Colors.black.withValues(alpha: .8),
                offset: const Offset(1, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
