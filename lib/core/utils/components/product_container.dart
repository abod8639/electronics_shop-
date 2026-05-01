import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/back_grid.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/home/presentation/widgets/image_section.dart';
import 'package:electronics_shop/features/home/presentation/widgets/title_and_description.dart';


class ProductContainer extends StatefulWidget {
  const ProductContainer({
    super.key,
    required this.product,
    this.showName,
    this.onPageChanged,
    this.onTap,
    required this.isBackgroundWhite,
    this.query,
    this.heroTagPrefix,
  });

  final void Function()? onTap;
  final ProductModel product;
  final bool? showName;
  final bool isBackgroundWhite;
  final String? query;
  final ValueChanged<int>? onPageChanged;
  final String? heroTagPrefix;

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.greyDark.withValues(alpha: 0.02),
            blurRadius: 10,
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipPath(
        clipper: CyberpunkCardClipper(),
        child: Container(
          
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: -2,
                blurStyle: BlurStyle.outer,
                // offset: Offset(0, 2),
                
              ),
            ],
            color: Colors.transparent,
            // color: theme.colorScheme.surface,
            border: Border(
              left: BorderSide(color: AppColors.cyan.withAlpha(80), width: 3),
              bottom: BorderSide(color: AppColors.cyan.withAlpha(80), width: 2),
            ),
          ),
          child: Stack(
            children: [
              // Digital grid background 
           BackGrid(accentColor: Colors.cyan.withValues(alpha: .5)),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  Expanded(
                    flex:3, 
                    child: Stack(
                      children: [

                        ImageSection(widget: widget),

                        // Pseudo-tech detail on image
                        // Positioned(
                        //   top: 8,
                        //   left: 8,
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        //     decoration: BoxDecoration(
                        //       color: AppColors.magenta.withValues(alpha: .8),
                        //       borderRadius: BorderRadius.circular(2),
                        //     ),
                        //     child: Text(
                        //       "STATUS: SCAN",
                        //       style: TTitleAndDescriptionextStyle(
                        //         color: Colors.white,
                        //         fontSize: 6,
                        //         fontWeight: FontWeight.bold,
                        //         fontFamily: 'monospace',
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    )
                  ),

          // Details Section
          if (widget.showName != null && widget.showName == true)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TitleAndDescription(
                            product: widget.product,
                            query: widget.query,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'LE ${widget.product.baseEffectivePrice}',
                                  style: TextStyle(
                                    color: AppColors.priceColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    fontFamily: 'monospace',
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                if (widget.product.baseHasDiscount)
                                  Text(
                                    'LE ${widget.product.formattedPrice}',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 9,
                                    ),
                                  ),
                              ],
                            ),
                            if (widget.product.reviewCount > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.cyan.withValues(alpha: .5), width: 0.5),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.bolt,
                                      size: 10.0,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 2.0),
                                    Text(
                                      widget.product.averageRating.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.cyan,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),

              ),
            ),
                ],
              ),
              // Corner Accent
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomPaint(
                  size: const Size(12, 12),
                  painter: CornerAccentPainter(color: AppColors.cyan),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CornerAccentPainter extends CustomPainter {
  final Color color;
  CornerAccentPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

