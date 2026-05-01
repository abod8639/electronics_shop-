import 'package:electronics_shop/features/home/data/models/selection_model.dart';
import 'package:electronics_shop/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:electronics_shop/features/home/presentation/widgets/product_row_list.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/product/data/repositories/product_repository.dart';
import 'package:electronics_shop/features/search/presentation/widgets/section_title.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryProductsProvider =
    FutureProvider.family<List<ProductModel>, String?>((ref, categoryId) async {
      final repo = ref.watch(productRepositoryProvider.notifier);
      return repo.getProducts(categoryId: categoryId);
    });

class CategorySectionRow extends ConsumerWidget {
  final SelectionsModel selection;
  final int index;

  const CategorySectionRow({
    super.key,
    required this.selection,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selection.id.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    final productsAsync = ref.watch(categoryProductsProvider(selection.id));

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty)
          return const SliverToBoxAdapter(child: SizedBox.shrink());

        return SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(
              child: SectionTitle(
                title: _getLocalizedLabel(context, selection.label),
                onSeeAllPressed: () {
                  ref
                      .read(categoriesSectionsControllerProvider.notifier)
                      .updateIndex(index);
                },
              ),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(height: 8),
            ), // Provide a tiny gap for better visual spacing
            ProductRowList(
              products: products,
              heroTagPrefix: 'category_${selection.id}_',
            ),
          ],
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (err, stack) => const SliverToBoxAdapter(child: SizedBox.shrink()),
    );
  }

  String _getLocalizedLabel(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return key;

    switch (key) {
      case 'categoryHome':
        return l10n.categoryHome;
      case 'phons':
        return l10n.categoryPhones;
      case 'Watch':
        return l10n.categoryWatches;
      case 'Laptops':
        return l10n.categoryLaptops;
      case 'audio':
        return l10n.categoryAudio;
      case 'screens':
        return l10n.categoryScreens;
      case 'cameras':
        return l10n.categoryCameras;
      case 'gaming':
        return l10n.categoryGaming;
      case 'accessories':
        return l10n.categoryAccessories;
      default:
        return key;
    }
  }
}
