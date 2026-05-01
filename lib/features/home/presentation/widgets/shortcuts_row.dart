import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:electronics_shop/features/home/presentation/widgets/shortcut_item.dart';

class CategoriesShortcutsRow extends ConsumerWidget {
  static const double _horizontalPadding = 3.0;
  static const double _verticalPadding = 8.0;
  static const double _rowHeight = 110;
  static const double _spacing = 1.0;

  const CategoriesShortcutsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsState = ref.watch(categoriesSectionsControllerProvider);

    return sectionsState.when(
      data: (selections) => Padding(
        padding: const EdgeInsets.only(
          left: _horizontalPadding - 3,
          right: _horizontalPadding,
          top: _verticalPadding,
          bottom: _verticalPadding,
        ),
        child: SizedBox(
          height: _rowHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: selections.length,
            separatorBuilder: (_, index) => const SizedBox(width: _spacing),
            itemBuilder: (context, index) => ShortcutItem(index: index),
            addRepaintBoundaries: true,
          ),
        ),
      ),
      loading: () => const SizedBox(height: _rowHeight),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
