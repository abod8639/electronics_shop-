// [Certain]
import 'package:electronics_shop/features/product_details/presentation/widgets/expandable_description_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/search/presentation/controllers/product_search_controller.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:electronics_shop/routes/routes.dart';

class CyberpunkInfoClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double cut = 16.0;
    path.moveTo(0, cut);
    path.lineTo(cut, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cut);
    path.lineTo(size.width - cut, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget buildProductInfo(
  ProductModel product,
  bool isDark,
  BuildContext context,
  WidgetRef ref,
) {
  // final theme = Theme.of(context);W
  final l10n = AppLocalizations.of(context)!;
  final locale = Localizations.localeOf(context).languageCode;
  final infoItems = <Widget>[];

  // دالة الملاحة للبراند
  void navigateToBrandPage(String brandName) {
    final searchNotifier = ref.read(productSearchControllerProvider.notifier);
    searchNotifier.clearSearch();
    searchNotifier.textController.text = brandName;
    searchNotifier.updateSearchQuery(brandName);
    context.push(AppRoutes.search, extra: false);
  }

  final List<Map<String, dynamic>> dataMap = [
    if (product.brand?.isNotEmpty ?? false)
      {'label': l10n.brand, 'value': product.brand!, 'isLink': true},
    if (product.category?.name != null)
      {
        'label': l10n.category,
        'value': product.category!.getLocalizedName(locale: locale),
      },
    if (product.sku != null) {'label': l10n.sku, 'value': product.sku!},
    if (product.warrantyInfo != null)
      {'label': l10n.warrantyInfo, 'value': product.warrantyInfo!},
    if (product.weight != null)
      {'label': l10n.weight, 'value': '${product.weight} كجم'},
    if (product.manufacturer != null)
      {'label': l10n.manufacturer, 'value': product.manufacturer!},
    if (product.countryOfOrigin != null)
      {'label': l10n.countryOfOrigin, 'value': product.countryOfOrigin!},
  ];

  final cyan = const Color(0xFF00FBFF);
  final magenta = const Color(0xFFFF00F7);

  for (var i = 0; i < dataMap.length; i++) {
    final item = dataMap[i];
    infoItems.add(
      _buildInfoRow(
        label: (item['label'] as String).toUpperCase(),
        value: item['value'] as String,
        isDark: isDark,
        cyan: cyan,
        magenta: magenta,
        isLink: item['isLink'] == true,
        onTap: item['isLink'] == true
            ? () => navigateToBrandPage(item['value'] as String)
            : null,
      ),
    );
    if (i < dataMap.length - 1) {
      infoItems.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Opacity(opacity: 0.1, child: Divider(color: cyan, height: 1)),
        ),
      );
    }
  }

  if (infoItems.isEmpty) return const SizedBox.shrink();

  return ExpandableDescriptionCard(
    title: l10n.productInfo.toUpperCase(),
    accentColor: cyan,
    icon: const Icon(Icons.info_outline_rounded),
    child: Column(children: infoItems),
  );
}

Widget _buildInfoRow({
  required String label,
  required String value,
  required bool isDark,
  required Color cyan,
  required Color magenta,
  bool isLink = false,
  VoidCallback? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'monospace',
              letterSpacing: 0.5,
              color: cyan.withValues(alpha: .8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 6,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'monospace',
                color: isLink
                    ? magenta
                    : (isDark ? Colors.white : Colors.black87),
                fontWeight: isLink ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
