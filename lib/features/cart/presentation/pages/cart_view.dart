import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/utils/components/base_app_bar.dart';
import 'package:electronics_shop/features/cart/presentation/controllers/cart_controller.dart';
import 'package:electronics_shop/features/home/presentation/controllers/main_controller.dart';
import 'package:electronics_shop/features/cart/presentation/widgets/build_cart_content.dart';
import 'package:electronics_shop/features/cart/presentation/widgets/empty_cart_view.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      // base app bar
      appBar: baseAppBar(context, localizations.cart),
      body: cartState.when(
        data: (items) => items.isEmpty
            ? EmptyCartView(
                onGoShopping: () =>
                    ref.read(mainControllerProvider.notifier).changeTabIndex(0),
              )
            : const BuildCartContent(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('خطأ: $e')),
      ),
    );
  }
}
