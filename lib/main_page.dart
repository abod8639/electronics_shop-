import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/features/home/presentation/controllers/main_controller.dart';
import 'package:electronics_shop/features/cart/presentation/pages/cart_view.dart';
import 'package:electronics_shop/features/home/presentation/pages/home_view.dart';
import 'package:electronics_shop/features/profile/presentation/pages/profile_page.dart';
import 'package:electronics_shop/features/wishlist/presentation/pages/wishlist_view.dart';
import 'package:electronics_shop/core/utils/components/my_bottom_navigation_bar.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(mainControllerProvider);

    final pages = <Widget>[
      const HomeView(),
      const WishlistView(),
      const CartView(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(index: tabIndex, children: pages),
          ),
        ],
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: MyBottomNavigationBar(),
      ),
    );
  }
}
