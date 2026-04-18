import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:electronics_shop/features/cart/presentation/controllers/cart_controller.dart';
import 'package:electronics_shop/features/home/presentation/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyBottomNavigationBar extends ConsumerWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tabIndex = ref.watch(mainControllerProvider);
    final cartState = ref.watch(cartControllerProvider);
    final cartCount = cartState.value?.length ?? 0;

    return Container(
      height: 70,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FBFF).withValues(alpha: .15),
            blurRadius: 20,
            spreadRadius: -5,
            blurStyle: BlurStyle.outer
          ),
        ],
      ),
      child: ClipPath(
        clipper: CyberpunkShapeClipper(),
        child: Container(
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.surface.withValues(alpha:.9),
                blurRadius: 20,
                spreadRadius: -5,
                blurStyle: BlurStyle.outer
              ),
            ],
            border: const Border(
              top: BorderSide(color: Color(0xFF00FBFF), width: 1.5),
              bottom: BorderSide(color: Color(0xFF00FBFF), width: 0.5),
              left: BorderSide(color: Color(0xFF00FBFF), width: 0.5),
              right: BorderSide(color: Color(0xFF00FBFF), width: 0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                ref: ref,
                index: 0,
                currentIndex: tabIndex,
                icon: Icons.home_filled,
                label: 'HOME_',
              ),
              _buildNavItem(
                context: context,
                ref: ref,
                index: 1,
                currentIndex: tabIndex,
                icon: Icons.favorite_rounded,
                label: 'FAVS_',
              ),
              _buildNavItem(
                context: context,
                ref: ref,
                index: 2,
                currentIndex: tabIndex,
                icon: Icons.shopping_cart_rounded,
                label: 'CART_',
                badgeCount: cartCount,
              ),
              _buildNavItem(
                context: context,
                ref: ref,
                index: 3,
                currentIndex: tabIndex,
                icon: Icons.person_rounded,
                label: 'USER_',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required WidgetRef ref,
    required int index,
    required int currentIndex,
    required IconData icon,
    required String label,
    int badgeCount = 0,
  }) {
    final isSelected = currentIndex == index;
    final activeColor = const Color(0xFF00FBFF);
    final inactiveColor = Colors.grey.shade600;

    return InkWell(
      onTap: () => ref.read(mainControllerProvider.notifier).changeTabIndex(index),
      highlightColor: Colors.transparent,
      splashColor: activeColor.withOpacity(0.1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 26,
                  shadows: isSelected
                      ? [
                          Shadow(
                            color: activeColor.withOpacity(0.8),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF00F7),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFF00F7),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'monospace',
                letterSpacing: 1.2,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 2),
                height: 2,
                width: 12,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: [
                    BoxShadow(
                      color: activeColor,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
