import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:electronics_shop/core/utils/components/product_container.dart';
import 'package:electronics_shop/core/utils/responsive_helper.dart';
import 'package:electronics_shop/features/search/presentation/widgets/search_bar_inline.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:electronics_shop/routes/routes.dart';
// import 'package:electronics_shop/features/home/presentation/controllers/home_controller.dart';
import '../controllers/product_search_controller.dart';

class ProductSearchsPage extends ConsumerWidget {
  final bool isFocused;
  const ProductSearchsPage({super.key, this.isFocused = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(productSearchControllerProvider);
    final searchNotifier = ref.watch(productSearchControllerProvider.notifier);
    // final homeProducts = ref.watch(homeControllerProvider).value ?? [];
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            
            pinned: false,
            floating: true,
            snap: true,
            centerTitle: true,
            title: Hero(
              tag: 'searchBar',
              child: Material(
                color: Colors.transparent,
                child: SearchBarInline(isFocused: isFocused),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: _buildFilterChips(ref, l10n.searchForProducts),
          ),

          searchState.when(
            data: (products) {
              // Show nothing if query is empty and we haven't searched (initial state)
              // Or show all products if that's the intended initial state
              final displayedProducts = products;

              if (searchNotifier.hasSearched && displayedProducts.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(context, l10n.noResultsFound),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 16.0,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(
                      context,
                    ),
                    childAspectRatio: ResponsiveHelper.getGridChildAspectRatio(
                      context,
                    ),
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 12.0,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = displayedProducts[index];
                    return GestureDetector(
                      onTap: () => context.push(
                        AppRoutes.productDetails,
                        extra: product,
                      ),
                      child: ProductContainer(
                        showName: true,
                        product: product,
                        isBackgroundWhite: false,
                        query: searchNotifier.searchQuery,
                      ),
                    );
                  }, childCount: displayedProducts.length),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(
                heightFactor: 3,
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, st) =>
                SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String title) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 72,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(WidgetRef ref, String lable) {
    final query = ref
        .watch(productSearchControllerProvider.notifier)
        .searchQuery;
    if (query.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: AlignmentDirectional.centerStart,
      child: Chip(
        label: Text('$lable "$query"'),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        onDeleted: () =>
            ref.read(productSearchControllerProvider.notifier).clearSearch(),
      ),
    );
  }
}
