// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:electronics_shop/features/home/data/models/selection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

class ShortcutItem extends ConsumerWidget {
  final int index;

  const ShortcutItem({super.key, required this.index});

  static const double _iconSize = 56.0;
  static const double _iconInnerSize = 28.0;
  static const double _labelWidth = 70.0;
  static const double _labelFontSize = 12.0;
  static const double _labelSpacing = 6.0;
  static const Duration _animationDuration = Duration(milliseconds: 180);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsState = ref.watch(categoriesSectionsControllerProvider);
    final selectedIndex = ref
        .watch(categoriesSectionsControllerProvider.notifier)
        .selectedIndex;
    final isSelected = selectedIndex == index;

    return sectionsState.when(
      data: (selections) {
        final item = selections[index];
        final theme = Theme.of(context);

        return Semantics(
          label: '${getLocalizedLabel(context, item.label)} category',
          selected: isSelected,
          button: true,
          child: GestureDetector(
            onTap: () => ref
                .read(categoriesSectionsControllerProvider.notifier)
                .updateIndex(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: _animationDuration,
                  curve: Curves.easeInOut,
                  width: _iconSize,
                  height: _iconSize,
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: theme.colorScheme.surfaceContainerHighest,
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? theme.colorScheme.primary.withValues(alpha: .3)
                            : theme.colorScheme.primary.withValues(alpha: .1),
                        blurRadius: isSelected ? 6 : 3,
                        offset: const Offset(2, 3),
                        blurStyle: BlurStyle.outer,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        //  (item.image != null && item.image!.isNotEmpty)
                        //  _buildImage(item.image, item.icon, isSelected, context, item)
                        //     :
                        Icon(
                          item.icon,
                          shadows: [
                            BoxShadow(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                              spreadRadius: isSelected ? 1 : 0,
                              blurRadius: isSelected ? 2 : 1,
                              offset: isSelected ? Offset(1, 1) : Offset(0, 0),
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          size: _iconInnerSize,
                        ),
                  ),
                ),
                const SizedBox(height: _labelSpacing),
                SizedBox(
                  width: _labelWidth,
                  child: Text(
                    getLocalizedLabel(context, item.label),
                    style: TextStyle(
                      fontSize: _labelFontSize,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  String getLocalizedLabel(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
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

Widget _buildImage(
  String? imageUrl,
  IconData icon,
  bool isSelected,
  BuildContext context,
  SelectionsModel item,
) {
  final theme = Theme.of(context);
  return CachedNetworkImage(
    imageUrl: imageUrl!,
    fit: BoxFit.none,
    placeholder: (context, url) => Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: theme.colorScheme.primary,
        ),
      ),
    ),
    errorWidget: (context, url, error) => Icon(
      item.icon,
      color: isSelected
          ? theme.colorScheme.primary
          : theme.colorScheme.onSurfaceVariant,
    ),
  );
}
