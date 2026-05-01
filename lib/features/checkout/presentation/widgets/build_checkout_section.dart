import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:electronics_shop/features/cart/presentation/widgets/checkout_button.dart';
import 'package:electronics_shop/features/cart/presentation/widgets/total_price_section.dart';
import 'package:flutter/material.dart';

const double _checkoutHorizontalPadding = 20.0;
const double _checkoutVerticalPadding = 16.0;
const double _spacing = 16.0;

class BuildCheckoutSection extends StatelessWidget {
  const BuildCheckoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 12,left: 20,right: 20 ),
      decoration: BoxDecoration(
      color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color:  AppColors.cyan.withValues(alpha: .1),
            blurRadius: 10,
            spreadRadius: -15,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: ClipPath(
        clipper: CyberpunkShapeClipper(),
        child: Container(

          padding: const EdgeInsets.symmetric(
            horizontal: _checkoutHorizontalPadding,
            vertical: _checkoutVerticalPadding,
          ),
          decoration: BoxDecoration(
                // color: Colors.transparent,
           
            color: theme.colorScheme.surface.withValues(alpha: .95),
            border: Border(
              top: BorderSide(color:    AppColors.cyan , width: 1.5),
              left: BorderSide(color:   AppColors.cyan , width: 0.5),
              right: BorderSide(color:  AppColors.cyan , width: 0.5),
              bottom: BorderSide(color: AppColors.cyan , width: 0.5),
            ),
          ),
          child: const SafeArea(
            child: Row(
              children: [
                TotalPriceSection(),
                SizedBox(width: _spacing),
                CheckoutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
