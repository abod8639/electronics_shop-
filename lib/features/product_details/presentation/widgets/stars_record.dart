import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/product/data/models/review_model.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class StarsRecord extends StatelessWidget {
  final List<ReviewModel> reviews;

  const StarsRecord({super.key, required this.reviews});

  /// Calculate average rating from reviews list
  double _calculateAverageRating() {
    if (reviews.isEmpty) return 0.0;

    final totalRating = reviews.fold<double>(
      0.0,
      (sum, review) => sum + review.rating,
    );

    return totalRating / reviews.length;
  }

  List<Widget> _buildStarRating(double stars) {
    final fullStars = stars.floor();
    final hasHalfStar = (stars - fullStars) >= 0.5;
    const amber = Colors.amber;

    final starIcons = <Widget>[];

    for (int i = 0; i < 5; i++) {
      IconData iconData;
      Color color;
      if (i < fullStars) {
        iconData = Icons.star_rounded;
        color = amber;
      } else if (i == fullStars && hasHalfStar) {
        iconData = Icons.star_half_rounded;
        color = amber;
      } else {
        iconData = Icons.star_outline_rounded;
        color = Colors.grey.withValues(alpha: 0.5);
      }

      starIcons.add(
        Icon(
          iconData,
          color: color,
          size: 18,
          shadows: [
            if (color == amber)
              Shadow(color: amber.withValues(alpha: 0.5), blurRadius: 4),
          ],
        ),
      );
    }

    return starIcons;
  }

  @override
  Widget build(BuildContext context) {
    final averageRating = _calculateAverageRating();
    final actualReviewCount = reviews.length;
    final intl10n = AppLocalizations.of(context)!;
    final magenta = AppColors.magenta;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: magenta.withValues(alpha: 0.05),
        border: Border.all(color: magenta.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._buildStarRating(averageRating),
          const SizedBox(width: 8),
          Text(
            '${averageRating.toStringAsFixed(1)} ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
              color: Colors.amber,
            ),
          ),
          Text(
            '($actualReviewCount ${intl10n.reviews})',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: magenta,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
