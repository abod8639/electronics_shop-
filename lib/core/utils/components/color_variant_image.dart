// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
// import 'package:electronics_shop/core/utils/functions/cache_manager.dart';

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

class CyberpunkColorClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double cut = size.width * 0.25;
    path.moveTo(cut, 0);
    path.lineTo(size.width - cut, 0);
    path.lineTo(size.width, cut);
    path.lineTo(size.width, size.height - cut);
    path.lineTo(size.width - cut, size.height);
    path.lineTo(cut, size.height);
    path.lineTo(0, size.height - cut);
    path.lineTo(0, cut);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

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
      width: width ?? 50,
      height: height ?? 50,
      decoration: BoxDecoration(
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: .3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: ClipPath(
        clipper: CyberpunkColorClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.cyan : Colors.transparent,
          ),
          padding: const EdgeInsets.all(2),
          child: ClipPath(
            clipper: CyberpunkColorClipper(),
            child: Container(
              color: baseColor,
              child: isSelected 
                  ? Center(
                      child: Icon(
                        Icons.check, 
                        size: 20, 
                        color: baseColor.computeLuminance() > 0.5 ? Colors.black : Colors.white
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

