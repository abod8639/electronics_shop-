import 'package:flutter/material.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

/// Builds the product price text
Widget buildProductPrice(
  ProductModel product, {
  double? alternateEffectivePrice,
  double? alternateOriginalPrice,
  bool? alternateHasDiscount,
}) {
  return Builder(
    builder: (context) {
      final effectivePrice = alternateEffectivePrice ?? product.baseEffectivePrice;
      final originalPrice = alternateOriginalPrice ?? product.basePrice;
      final hasDiscount = alternateHasDiscount ?? product.baseHasDiscount;
      final magenta = const Color(0xFFFF00F7);

      if (effectivePrice <= 0) {
        return Text(
          AppLocalizations.of(context)!.priceOnRequest.toUpperCase(),
          style: TextStyle(
            color: magenta,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            letterSpacing: 1,
          ),
        );
      }

      return Wrap(
        spacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'LE ${effectivePrice.toStringAsFixed(2)}',
            style: TextStyle(
              color: magenta,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: 'monospace',
              letterSpacing: -0.5,
            ),
          ),
          if (hasDiscount)
            Text(
              'LE ${originalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
        ],
      );

    },
  );
}
