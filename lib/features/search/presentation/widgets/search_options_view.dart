import 'package:electronics_shop/core/utils/components/app_network_image.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/search/presentation/controllers/search_history_controller.dart';
import 'package:electronics_shop/features/search/presentation/widgets/highlight_text.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchOptionsView extends StatelessWidget {
  final BoxConstraints constraints;
  final Iterable<Object> options;
  final AutocompleteOnSelected<Object> onSelected;
  final String query;

  const SearchOptionsView({
    super.key,
    required this.constraints,
    required this.options,
    required this.onSelected,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final locale = l10n.localeName;

    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 8.0,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        color: theme.colorScheme.surface.withValues(alpha: 0.95),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 400,
            maxWidth: constraints.maxWidth,
          ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            itemCount: options.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: const Color(0xFF00FBFF).withValues(alpha: 0.1),
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final option = options.elementAt(index);

              if (option is String) {
                return HistoryItemTile(
                  label: option,
                  onSelected: () => onSelected(option),
                );
              }

              if (option is ProductModel) {
                return ProductItemTile(
                  product: option,
                  query: query,
                  locale: locale,
                  onSelected: () => onSelected(option),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class HistoryItemTile extends ConsumerWidget {
  final String label;
  final VoidCallback onSelected;

  const HistoryItemTile({
    super.key,
    required this.label,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.history, size: 20, color: Colors.grey),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 16),
        onPressed: () {
          ref.read(searchHistoryProvider.notifier).remove(label);
        },
      ),
      onTap: onSelected,
    );
  }
}

class ProductItemTile extends StatelessWidget {
  final ProductModel product;
  final String query;
  final String locale;
  final VoidCallback onSelected;

  const ProductItemTile({
    super.key,
    required this.product,
    required this.query,
    required this.locale,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          children: [
            AppNetworkImage(
              imageUrl: product.primaryThumbnailUrl,
              width: 50,
              height: 50,
              borderRadius: 4.0,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HighlightText(
                    text: product.getLocalizedName(locale: locale),
                    query: query,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00FBFF),
                    ),
                  ),
                  if (product.brand != null)
                    Text(
                      product.brand!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '${product.price.toStringAsFixed(2)} LE',
              style: const TextStyle(
                color: Color(0xFFFF00F7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
