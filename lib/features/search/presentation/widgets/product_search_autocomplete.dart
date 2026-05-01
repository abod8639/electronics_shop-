import 'package:electronics_shop/features/home/presentation/controllers/home_controller.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/search/presentation/controllers/product_search_controller.dart';
import 'package:electronics_shop/features/search/presentation/controllers/search_history_controller.dart';
import 'package:electronics_shop/features/search/presentation/widgets/cyberpunk_search_field.dart';
import 'package:electronics_shop/features/search/presentation/widgets/product_search_service.dart';
import 'package:electronics_shop/features/search/presentation/widgets/search_options_view.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:electronics_shop/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductSearchAutocomplete extends ConsumerStatefulWidget {
  final bool autofocus;
  final bool readOnly;
  final VoidCallback? onTap;

  const ProductSearchAutocomplete({
    super.key,
    this.autofocus = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  ConsumerState<ProductSearchAutocomplete> createState() =>
      _ProductSearchAutocompleteState();
}

class _ProductSearchAutocompleteState
    extends ConsumerState<ProductSearchAutocomplete> {
  late final FocusNode _focusNode;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final products = ref.watch(homeControllerProvider).asData?.value ?? [];
    final history = ref.watch(searchHistoryProvider);

    return LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<Object>(
        focusNode: _focusNode,
        textEditingController: _textController,
        optionsBuilder: (value) => ProductSearchService.getSuggestions(
          query: value.text,
          products: products,
          history: history,
          locale: l10n.localeName,
        ),
        onSelected: (selection) => _handleSelection(selection, l10n.localeName),
        fieldViewBuilder: (ctx, ctrl, node, onFieldSubmitted) {
          return CyberpunkSearchField(
            controller: ctrl,
            focusNode: node,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            onTap: widget.onTap,
            onSubmitted: (val) {
              ref.read(searchHistoryProvider.notifier).add(val);
              onFieldSubmitted();
            },
            onChanged: (val) {
              ref
                  .read(productSearchControllerProvider.notifier)
                  .onSearchChanged(val);
              setState(() {}); // لتحديث زر المسح (Clear)
            },
          );
        },
        optionsViewBuilder: (context, onSelected, options) => SearchOptionsView(
          constraints: constraints,
          options: options,
          onSelected: onSelected,
          query: _textController.text,
        ),
      ),
    );
  }

  void _handleSelection(Object selection, String locale) {
    final historyNotifier = ref.read(searchHistoryProvider.notifier);
    final searchController = ref.read(productSearchControllerProvider.notifier);

    if (selection is ProductModel) {
      final name = selection.getLocalizedName(locale: locale);
      historyNotifier.add(name);
      searchController.onSearchChanged(name);
      context.push(AppRoutes.productDetails, extra: selection);
    } else if (selection is String) {
      _textController.text = selection;
      searchController.onSearchChanged(selection);
      historyNotifier.add(selection);
    }
  }
}
