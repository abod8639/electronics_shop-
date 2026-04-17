import 'package:flutter/material.dart';
// import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/home/presentation/widgets/image_section.dart';
import 'package:electronics_shop/features/home/presentation/widgets/title_and_description.dart';
// import 'package:electronics_shop/l10n/generated/app_localizations.dart';

class CyberpunkCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double cut = 16.0;
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

class ProductContainer extends StatefulWidget {
  const ProductContainer({
    super.key,
    required this.product,
    this.showName,
    this.onPageChanged,
    this.onTap,
    required this.isBackgroundWhite,
    this.query,
  });

  final void Function()? onTap;
  final ProductModel product;
  final bool? showName;
  final bool isBackgroundWhite;
  final String? query;
  final ValueChanged<int>? onPageChanged;

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

    final cyan = const Color(0xFF00FBFF);
    final magenta = const Color(0xFFFF00F7);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: cyan.withValues(alpha: 0.01),
            blurRadius: 10,
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipPath(
        clipper: CyberpunkCardClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              left: BorderSide(color: cyan.withAlpha(50), width: 3),
              bottom: BorderSide(color: cyan.withAlpha(50), width: 1),
            ),
          ),
          child: Stack(
            children: [
              // Digital grid background 
              Positioned.fill(
                child: Opacity(
                  opacity: 0.04,
                  child: GridPaper(
                    color: cyan,
                    divisions: 1,
                    subdivisions: 1,
                    interval: 25,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  Expanded(
                    flex: 4, 
                    child: Stack(
                      children: [
                        ImageSection(widget: widget),
                        // Pseudo-tech detail on image
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: magenta.withValues(alpha: .8),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              "STATUS: SCAN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 6,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ),

          // Details Section
          if (widget.showName != null && widget.showName == true)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleAndDescription(
                      product: widget.product,
                      query: widget.query,
                      // Note: We might need to adjust TitleAndDescription's text style too
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LE ${widget.product.baseEffectivePrice}',
                              style: TextStyle(
                                color: magenta,
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
                              border: Border.all(color: cyan.withValues(alpha: .5), width: 0.5),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.bolt, // Lightning bolt for rating
                                  size: 10.0,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 2.0),
                                Text(
                                  widget.product.averageRating.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: cyan,
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
                  painter: CornerAccentPainter(color: cyan),
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

