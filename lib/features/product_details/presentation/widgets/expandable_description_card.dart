import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/product/data/models/review_model.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/header_with_icon_and_title.dart';
import 'package:electronics_shop/features/product_details/presentation/widgets/stars_record.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

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

    return Container(
      decoration: _buildCardDecoration(theme),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
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
                    _buildToggleButton(theme, l10n),
                  const SizedBox(height: 16),
                  StarsRecord(reviews: widget.reviews),
                ],
              ),
            ),
          ],
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

  Widget _buildToggleButton(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: InkWell(
        onTap: _toggleExpanded,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isExpanded ? l10n.readLess : l10n.readMore,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              RotationTransition(
                turns: _iconRotation,
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primary,
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

  BoxDecoration _buildCardDecoration(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [
                theme.colorScheme.surface,
                theme.colorScheme.surface.withValues(alpha: .8),
              ]
            : [
                theme.colorScheme.surface,
                theme.colorScheme.primaryContainer.withValues(alpha: .1),
              ],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppColors.primary.withValues(alpha: .2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: .08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

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
