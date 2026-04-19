import 'package:flutter/material.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/search/presentation/widgets/highlight_text.dart';

class TitleAndDescription extends StatelessWidget {
  const TitleAndDescription({super.key, required this.product, this.query});

  final ProductModel product;
  final String? query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HighlightText(
          text: product.getLocalizedName(locale: locale).length > 30
              ? '${product.getLocalizedName(locale: locale).substring(0, 30)}...'
              : product.getLocalizedName(locale: locale),
          query: query ?? "",
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4.0),
        Builder(
          builder: (context) {
            final description = product.getLocalizedDescription(locale: locale);
            return Text(
              description.length > 100
                  ? '${description.substring(0, 100)}...'
                  : description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.8,
                ),
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
      ],
    );
  }
}
