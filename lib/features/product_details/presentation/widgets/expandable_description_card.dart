import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/product/data/models/review_model.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/header_with_icon_and_title.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/stars_record.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

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
  final String? title;
  final Widget? icon;
  final String? description;
  final Widget? child;
  final List<ReviewModel>? reviews;
  final Color? accentColor;

  const ExpandableDescriptionCard({
    super.key,
    this.title,
    this.icon,
    this.description,
    this.child,
    this.reviews,
    this.accentColor,
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
    final accentColor = widget.accentColor ?? AppColors.cyan;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipPath(
        clipper: CyberpunkCardClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.surface : Colors.white,
            border: Border(
              left: BorderSide(color: accentColor.withValues(alpha: .5), width: 3),
              bottom: BorderSide(color: accentColor.withValues(alpha: .3), width: 1),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.04,
                  child: GridPaper(
                    color: accentColor,
                    divisions: 1,
                    subdivisions: 1,
                    interval: 30,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWithIconandTitle(
                    icon: widget.icon,
                    title: widget.title ?? l10n.productDescription,
                    color: accentColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.description != null) ...[
                          _buildDescriptionText(theme, widget.description!),
                          if (_shouldShowExpandButton(context, theme, widget.description!))
                            _buildToggleButton(theme, l10n, accentColor),
                        ],
                        if (widget.child != null) widget.child!,
                        if (widget.reviews != null && widget.reviews!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          StarsRecord(reviews: widget.reviews!),
                        ],
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

  Widget _buildDescriptionText(ThemeData theme, String text) {
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: .8),
      height: 1.6,
      letterSpacing: 0.2,
      fontFamily: 'monospace',
      fontSize: 13,
    );

    return AnimatedCrossFade(
      firstChild: Text(
        text,
        maxLines: _collapsedMaxLines,
        overflow: TextOverflow.ellipsis,
        style: textStyle,
      ),
      secondChild: Text(text, style: textStyle),
      crossFadeState: _isExpanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: _animationDuration,
    );
  }

  Widget _buildToggleButton(ThemeData theme, AppLocalizations l10n, Color accentColor) {
    final magenta = AppColors.magenta;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: InkWell(
        onTap: _toggleExpanded,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                  fontSize: 10,
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
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _shouldShowExpandButton(BuildContext context, ThemeData theme, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.6,
          letterSpacing: 0.2,
          fontFamily: 'monospace',
          fontSize: 13,
        ),
      ),
      maxLines: _collapsedMaxLines,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: MediaQuery.sizeOf(context).width - 64);

    return textPainter.didExceedMaxLines;
  }
}
