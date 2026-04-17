import 'package:electronics_shop/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/utils/functions/app_guard.dart';
import 'package:electronics_shop/features/home/presentation/controllers/home_controller.dart';
import 'package:electronics_shop/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:electronics_shop/features/search/presentation/widgets/search_bar.dart';
import 'package:electronics_shop/features/home/presentation/widgets/shortcuts_row.dart';
import 'package:electronics_shop/features/promo/presentation/widgets/promo_banner.dart';
import 'package:electronics_shop/features/search/presentation/widgets/section_title.dart';
import 'package:electronics_shop/features/home/presentation/widgets/product_list.dart';

class HomeView extends ConsumerWidget {
  static const double _bottomPadding = 20.0;

  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryIndex = ref
        .watch(categoriesSectionsControllerProvider)
        .maybeWhen(
          data: (_) => ref
              .read(categoriesSectionsControllerProvider.notifier)
              .selectedIndex,
          orElse: () => 0,
        );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: RefreshIndicator(
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
                  if (selectedCategoryIndex == 0)
                    const SliverToBoxAdapter(child: PromoBanner()),
                  if (selectedCategoryIndex == 0)
                    SliverToBoxAdapter(child: SectionTitle(title: AppLocalizations.of(context)!.mostPopularOffers)),
                  const ProductRowList(),
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
