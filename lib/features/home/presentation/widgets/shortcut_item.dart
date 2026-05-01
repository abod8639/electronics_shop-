import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/features/home/presentation/controllers/categories_sections_controller.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

class CyberpunkClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double cut = 13.0;
    path.moveTo(cut, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cut);
    path.lineTo(size.width - cut, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cut);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ShortcutItem extends ConsumerWidget {
  final int index;

  const ShortcutItem({super.key, required this.index});

  static const double _iconSize = 56.0;
  static const double _iconInnerSize = 24.0;
  static const double _labelWidth = 75.0;
  static const double _labelFontSize = 10.0;
  static const double _labelSpacing = 8.0;
  static const Duration _animationDuration = Duration(milliseconds: 180);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsState = ref.watch(categoriesSectionsControllerProvider);
    final selectedIndex = ref
        .watch(categoriesSectionsControllerProvider.notifier)
        .selectedIndex;
    final isSelected = selectedIndex == index;
    final theme = Theme.of(context);

    return sectionsState.when(
      data: (selections) {
        final item = selections[index];

        return Semantics(
          
          label: '${getLocalizedLabel(context, item.label)} category',
          selected: isSelected,
          button: true,
          child: Center(
            child: GestureDetector(
              onTap: () => ref
                  .read(categoriesSectionsControllerProvider.notifier)
                  .updateIndex(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow effect
                      if (isSelected)
                        Container(
                          width: _iconSize + 4,
                          height: _iconSize + 4,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: isSelected ? AppColors.cyan.withValues(alpha: .3) : Colors.black,
                                blurRadius: 8,
                                spreadRadius: .5,
                              ),
                            ],
                          ),
                        ),
                      // Clipped Container
                      ClipPath(
                        clipper: CyberpunkClipper(),
                        child: AnimatedContainer(
                          duration: _animationDuration,
                          width: _iconSize,
                          height: _iconSize,
                          decoration: BoxDecoration(
                            color: isSelected 
                              ? theme.colorScheme.surface 
                              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: .5),
                            border: Border(
                              left: BorderSide(
                                color: isSelected ? AppColors.cyan : AppColors.cyan.withValues(alpha: .3), 
                                width: isSelected ? 3 : 1
                              ),
                              bottom: BorderSide(
                                color: isSelected ? AppColors.cyan : AppColors.cyan.withValues(alpha: .3), 
                                width: isSelected ? 1 : 1.5
                              ),
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Grid pattern
                              Positioned.fill(
                                child: Opacity(
                                  opacity: isSelected ? 0.1 : 0.05,
                                  child: GridPaper(
                                    color: AppColors.cyan,
                                    divisions: 1,
                                    subdivisions: 1,
                                    interval: 15,
                                  ),
                                ),
                              ),
            
                              Icon(
                                item.icon,
                                color: isSelected ? AppColors.cyan : theme.colorScheme.onSurfaceVariant,
                                size: _iconInnerSize,
                              ),
                            ],
                          ), 
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: _labelSpacing),
                  SizedBox(
                    width: _labelWidth,
                    child: Column(
                      children: [
                        Text(
                          getLocalizedLabel(context, item.label).toUpperCase(),
                          style: TextStyle(
                            fontSize: _labelFontSize,
                            letterSpacing: 1.1,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.cyan : theme.colorScheme.onSurface,
                            fontFamily: 'monospace',
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        if (isSelected)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 20,
                            height: 2,
                            color: AppColors.magenta,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
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


// Widget _buildImage(
//   String? imageUrl,
//   IconData icon,
//   bool isSelected,
//   BuildContext context,
//   SelectionsModel item,
// ) {
//   final theme = Theme.of(context);
//   return CachedNetworkImage(
//     imageUrl: imageUrl!,
//     fit: BoxFit.none,
//     placeholder: (context, url) => Center(
//       child: SizedBox(
//         width: 20,
//         height: 20,
//         child: CircularProgressIndicator(
//           strokeWidth: 2,
//           color: theme.colorScheme.primary,
//         ),
//       ),
//     ),
//     errorWidget: (context, url, error) => Icon(
//       item.icon,
//       color: isSelected
//           ? theme.colorScheme.primary
//           : theme.colorScheme.onSurfaceVariant,
//     ),
//   );
// }
