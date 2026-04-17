import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/product/data/models/review_model.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/header_with_icon_and_title.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/stars_record.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

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

class ExpandableDescriptionCard extends StatefulWidget {
  final String description;
  final double? stars;
  final int? reviewCount;
  final List<ReviewModel> reviews;

  const ExpandableDescriptionCard({
    super.key,
    required this.description,
    this.stars,
    this.reviewCount,
    required this.reviews,
  });

  @override
  State<ExpandableDescriptionCard> createState() =>
      _ExpandableDescriptionCardState();
}

class _ExpandableDescriptionCardState extends State<ExpandableDescriptionCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _iconRotation;

  static const int _collapsedMaxLines = 4;
  static const Duration _animationDuration = Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _iconRotation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final cyan = const Color(0xFF00FBFF);
    final magenta = const Color(0xFFFF00F7);


    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: cyan.withValues(alpha: 0.1),
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
              left: BorderSide(color: cyan.withValues(alpha: .5), width: 3),
              bottom: BorderSide(color: cyan.withValues(alpha: .5), width: 1),
            ),
          ),
          child: Stack(
            children: [
              // Digital grid pattern
              Positioned.fill(
                child: Opacity(
                  opacity: 0.04,
                  child: GridPaper(
                    color: cyan,
                    divisions: 1,
                    subdivisions: 1,
                    interval: 30,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderWithIconandTitle(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDescriptionText(theme),
                        if (_shouldShowExpandButton(context, theme))
                          _buildToggleButton(theme, l10n, cyan, magenta),
                        const SizedBox(height: 16),
                        StarsRecord(reviews: widget.reviews),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }

  // --- Widgets ---

  Widget _buildDescriptionText(ThemeData theme) {
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.6,
      letterSpacing: 0.2,
    );

    return AnimatedCrossFade(
      firstChild: Text(
        widget.description,
        maxLines: _collapsedMaxLines,
        overflow: TextOverflow.ellipsis,
        style: textStyle,
      ),
      secondChild: Text(widget.description, style: textStyle),
      crossFadeState: _isExpanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: _animationDuration,
    );
  }

  Widget _buildToggleButton(ThemeData theme, AppLocalizations l10n, Color cyan, Color magenta) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: InkWell(
        onTap: _toggleExpanded,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: magenta.withValues(alpha: .1),
            border: Border.all(color: magenta.withValues(alpha: .5), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (_isExpanded ? l10n.readLess : l10n.readMore).toUpperCase(),
                style: TextStyle(
                  color: magenta,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: 'monospace',
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(width: 4),
              RotationTransition(
                turns: _iconRotation,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: magenta,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // ---(Helper Methods) ---



  bool _shouldShowExpandButton(BuildContext context, ThemeData theme) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.description,
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.6,
          letterSpacing: 0.2,
        ),
      ),
      maxLines: _collapsedMaxLines,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: MediaQuery.sizeOf(context).width - 64);

    return textPainter.didExceedMaxLines;
  }
}
