import 'package:flutter/material.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';

/// Builds the product name text
Widget buildProductName(ProductModel product) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final locale = Localizations.localeOf(context).languageCode;
      return Text(
        product.getLocalizedName(locale: locale).toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          fontFamily: 'monospace',
          letterSpacing: 1.2,
          color: theme.colorScheme.onSurface,
        ),
      );

    },
  );
}
