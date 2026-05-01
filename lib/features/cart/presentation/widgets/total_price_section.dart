import 'package:electronics_shop/features/cart/presentation/controllers/cart_controller.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double _totalLabelFontSize = 12.0;
const double _totalPriceFontSize = 22.0;
const double _itemCountFontSize = 10.0;
const double _smallSpacing = 2.0;

class TotalPriceSection extends ConsumerWidget {
  const TotalPriceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final cartNotifier = ref.watch(cartControllerProvider.notifier);
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    final cyanColor = const Color(0xFF00FBFF);
    final magentaColor = const Color(0xFFFF00F7);

    return cartState.when(
      data: (items) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  localizations.total.toUpperCase(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: _totalLabelFontSize,
                    color: cyanColor,
                    fontFamily: 'monospace',
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 1.0,
                  ),
                  decoration: BoxDecoration(
                    color: magentaColor.withValues(alpha: 0.1),
                    border: Border.all(
                      color: magentaColor.withValues(alpha: 0.5),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    '[${items.length}]',
                    style: TextStyle(
                      fontSize: _itemCountFontSize,
                      fontWeight: FontWeight.bold,
                      color: magentaColor,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: _smallSpacing),
            Text(
              '${cartNotifier.totalPrice.toStringAsFixed(2)} LE',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: _totalPriceFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'monospace',
                shadows: [
                  Shadow(
                    color: magentaColor.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
