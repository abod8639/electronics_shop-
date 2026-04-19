// import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/utils/functions/app_guard.dart';
import 'package:electronics_shop/features/home/presentation/controllers/home_controller.dart';
import 'package:electronics_shop/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:electronics_shop/features/search/presentation/widgets/search_bar.dart';
import 'package:electronics_shop/features/home/presentation/widgets/shortcuts_row.dart';
import 'package:electronics_shop/features/promo/presentation/widgets/promo_banner.dart';
import 'package:electronics_shop/features/search/presentation/widgets/section_title.dart';
import 'package:electronics_shop/features/home/presentation/widgets/product_row_list.dart';
import 'package:electronics_shop/features/home/presentation/widgets/category_section_row.dart';
import 'package:electronics_shop/features/home/presentation/widgets/product_grid_list.dart';

class HomeView extends ConsumerWidget {
  static const double _bottomPadding = 20.0;

  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesState = ref.watch(categoriesSectionsControllerProvider);
    final selectedCategoryIndex = ref
        .watch(categoriesSectionsControllerProvider.notifier)
        .selectedIndex;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: RefreshIndicator(
              color: AppColors.cyan,
              onRefresh: () => AppGuard.runSafeInternet(
                ref,
                () => ref.read(homeControllerProvider.notifier).refreshHome(),
              ),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  const SearchBar(),
                  const SliverToBoxAdapter(child: CategoriesShortcutsRow()),
                  if (selectedCategoryIndex == 0) ...[
                    const SliverToBoxAdapter(child: PromoBanner()),
                    
                    // Recommended/Most Popular section from HomeController
                    ref.watch(homeControllerProvider).when(
                      data: (products) => SliverMainAxisGroup(
                        slivers: [
                          SliverToBoxAdapter(
                            child: SectionTitle(
                              title:""
                              //  AppLocalizations.of(context)!.recommended,
                            ),
                          ),
                          ProductRowList(products: products ),
                        ],
                      ),
                      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                      error: (err, stack) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                    ) ,

                    // Show various category sections
                    categoriesState.when(
                      data: (selections ) {
                        return SliverMainAxisGroup(
                          slivers: selections
                              .asMap()
                              .entries
                              .where((e) => e.key > 0)
                              .map((e) => CategorySectionRow(
                                    selection: e.value,
                                    index: e.key,
                                  ))
                              .toList(),
                        );
                      },
                      loading: () => const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (err, stack) =>
                          const SliverToBoxAdapter(child: SizedBox.shrink()),
                    ),
                  ] else ...[
                    const ProductGridList(),
                  ],

                  const SliverToBoxAdapter(
                    child: SizedBox(height: _bottomPadding),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

