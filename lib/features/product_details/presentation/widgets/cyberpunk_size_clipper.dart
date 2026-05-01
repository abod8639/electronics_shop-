import 'package:flutter/material.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';

// cyberpunk_size_clipper
class CyberpunkSizeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double cut = 12.0;
    path.moveTo(cut, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cut);
    path.lineTo(size.width - cut, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cut);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ProductSizeSelector extends StatefulWidget {
  final ProductModel product;
  final String? initialSize;
  final Function(String) onSizeSelected;

  const ProductSizeSelector({
    super.key,
    required this.product,
    this.initialSize,
    required this.onSizeSelected,
  });

  @override
  State<ProductSizeSelector> createState() => _ProductSizeSelectorState();
}

class _ProductSizeSelectorState extends State<ProductSizeSelector> {
  late String? _selectedSize;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.initialSize;
  }

  @override
  void didUpdateWidget(ProductSizeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSize != oldWidget.initialSize) {
      _selectedSize = widget.initialSize;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productSizes = widget.product.productSizes;
    final legacySizes = widget.product.size;

    if (productSizes.isEmpty && legacySizes.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 14,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: AppColors.cyan,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: .5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              Text(
                "CHOOSE_SIZE_SPEC".toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  fontFamily: 'monospace',
                  color: AppColors.cyan,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: productSizes.isNotEmpty
              ? productSizes
                    .map((ps) => _buildSizeButton(ps.size, isDark))
                    .toList()
              : legacySizes.map((s) => _buildSizeButton(s, isDark)).toList(),
        ),
      ],
    );
  }

  Widget _buildSizeButton(String size, bool isDark) {
    final isSelected = _selectedSize == size;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: .2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSize = size;
          });
          widget.onSizeSelected(size);
        },
        child: ClipPath(
          clipper: CyberpunkSizeClipper(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.cyan.withValues(alpha: .8)
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppColors.greyDark),
              border: Border(
                left: BorderSide(
                  color: isSelected
                      ? AppColors.greyDark
                      : AppColors.cyan.withValues(alpha: .5),

                  width: 3,
                ),
              ),
            ),
            child: Text(
              size.toUpperCase(),
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : (isDark ? Colors.white70 : Colors.black87),
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.normal,
                shadows: [
                  BoxShadow(
                    color: AppColors.backgroundDark.withValues(alpha: .2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
                fontFamily: 'monospace',
                fontSize: 13,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
