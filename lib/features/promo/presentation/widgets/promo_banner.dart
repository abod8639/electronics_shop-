import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/promo/data/models/promo_model.dart';
import 'package:electronics_shop/core/utils/functions/cache_manager.dart';
import 'package:electronics_shop/features/promo/presentation/controllers/promo_controller.dart';

class PromoBanner extends ConsumerWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promosAsync = ref.watch(promosProvider);
    final promoNotifier = ref.watch(promoControllerProvider.notifier);
    final currentIndex = ref.watch(promoControllerProvider);

    return promosAsync.when(
      data: (promos) {
        if (promos.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            SizedBox(
              height: 200,
              child: PageView.builder(
                allowImplicitScrolling: true,
                pageSnapping: true,
                controller: promoNotifier.pageController,
                onPageChanged: (index) =>
                    promoNotifier.updateCurrentIndex(index, promos.length),
                itemBuilder: (context, index) {
                  final promo = promos[index % promos.length];
                  return _buildPromoCard(context, ref, promo);
                },
              ),
            ),
            const SizedBox(height: 12),
            _buildIndicators(promos.length, currentIndex),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }

  Widget _buildIndicators(int length, int currentIndex) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          length,
          (index) {
            final isSelected = currentIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: isSelected ? 24 : 8,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.4)
                        : Colors.transparent,
                    blurRadius: isSelected ? 10 : 0,
                    spreadRadius: isSelected ? 1 : 0,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPromoCard(
    BuildContext context,
    WidgetRef ref,
    PromoModel promo,
  ) {
    final promoNotifier = ref.read(promoControllerProvider.notifier);

    return GestureDetector(
      onTap: () => promoNotifier.onPromoPressed(context, promo),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: promo.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            CachedNetworkImage(
              cacheManager: CustomCacheManager.instance,
              imageUrl: promo.imageUrl,
              fit: BoxFit.cover,
              errorWidget: (context, error, stackTrace) =>
                  Container(color: promo.backgroundColor),
            ),
            
            // Modern Multi-stage Gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                    ],
                    begin: AlignmentDirectional.centerStart,
                    end: AlignmentDirectional.centerEnd,
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Content Area
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (promo.title != null)
                    _buildGlassTag(promo.title!),
                  
                  const SizedBox(height: 12),
                  
                  if (promo.subtitle != null)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 200),
                      child: Text(
                        promo.subtitle!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .95),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(1, 1),
                            )
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  
                  const SizedBox(height: 20),
                  
                  if (promo.targetId != null)
                    _buildCTAButton(promo.buttonText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildGlassTag(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCTAButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.black,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

