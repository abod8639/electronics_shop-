import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/support/presentation/pages/help_page.dart';
import 'package:electronics_shop/features/support/presentation/pages/supports_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:electronics_shop/features/auth/presentation/pages/auth_view.dart';
import 'package:electronics_shop/features/auth/presentation/pages/signin_page.dart';
import 'package:electronics_shop/features/auth/presentation/pages/signup_page.dart';
import 'package:electronics_shop/features/cart/presentation/pages/cart_view.dart';
import 'package:electronics_shop/features/home/presentation/pages/home_view.dart';
import 'package:electronics_shop/main_page.dart';
import 'package:electronics_shop/features/order/presentation/pages/order_view.dart';
import 'package:electronics_shop/features/product_details/presentation/pages/product_details_view.dart';
import 'package:electronics_shop/features/profile/presentation/pages/edit_user_info.dart';
import 'package:electronics_shop/features/profile/presentation/pages/profile_page.dart';
import 'package:electronics_shop/features/order/data/models/order_model.dart';
import 'package:electronics_shop/features/order/presentation/pages/order_details_view.dart';
import 'package:electronics_shop/features/wishlist/presentation/pages/wishlist_view.dart';
import 'package:electronics_shop/features/search/presentation/pages/searchs_page.dart';
import 'package:electronics_shop/features/checkout/presentation/pages/checkout_view.dart';
import 'package:electronics_shop/features/checkout/presentation/pages/order_success_view.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/splash/presentation/pages/splash_view.dart';
import 'package:electronics_shop/features/auth/presentation/controllers/auth_controller.dart';
import 'package:electronics_shop/features/product/data/repositories/product_repository.dart';

class AppRoutes {
  static const String main = '/';
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String productDetails = '/product_details';
  static const String wishlist = '/wishlist';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order_success';
  static const String editUserInfo = '/edit_user_info';
  static const String orderView = '/order_view';
  static const String orderDetails = '/order_details';
  static const String support = '/supports';
  static const String help = '/help';

}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: AuthRefreshListenable(ref),
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isLoggedIn = authState.value != null;

      final isAuthPath =
          state.matchedLocation.startsWith(AppRoutes.auth) ||
          state.matchedLocation == AppRoutes.signIn ||
          state.matchedLocation == AppRoutes.signUp;

      // If logged in and on an auth page, go to main
      if (isLoggedIn && isAuthPath) {
        return AppRoutes.main;
      }

      // No redirect
      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.main,
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthView(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) =>
            SignUpPage(onSignInTap: () => context.go(AppRoutes.signIn)),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) =>
            SignInPage(onSignUpTap: () => context.go(AppRoutes.signUp)),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) => const CartView(),
      ),
      GoRoute(
        path: AppRoutes.productDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is ProductModel) {
            return ProductDetailsView(product: extra);
          } else if (extra is Map<String, dynamic> &&
              extra.containsKey('product') &&
              extra['product'] is ProductModel) {
            return ProductDetailsView(
              product: extra['product'] as ProductModel,
              initialColor: extra['selectedColor'] as String?,
              initialSize: extra['selectedSize'] as String?,
              heroTagPrefix: extra['heroTagPrefix'] as String?,
            );
          } else if (extra is String || extra is int) {
            // Handle navigation when only productId is available (handles both String and int)
            final productId = extra.toString();
            return Consumer(
              builder: (context, ref, child) {
                return FutureBuilder<ProductModel>(
                  // We MUST use .notifier to access methods of a class-based Notifier provider
                  future: ref.read(productRepositoryProvider.notifier).getProductById(productId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      return ProductDetailsView(product: snapshot.data!);
                    } else if (snapshot.hasError) {
                      return Scaffold(
                        backgroundColor: Colors.black,
                        appBar: AppBar(backgroundColor: Colors.transparent),
                        body: Center(
                          child: Text(
                            "ERROR: ${snapshot.error}",
                            style: const TextStyle(color: AppColors.magenta, fontFamily: 'monospace'),
                          ),
                        ),
                      );
                    }
                    return const Scaffold(
                      backgroundColor: Colors.black,
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: AppColors.cyan),
                            SizedBox(height: 16),
                            Text(
                              'FETCHING_PRODUCT_DATA...',
                              style: TextStyle(color: AppColors.cyan, fontFamily: 'monospace', fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
          // Return a safe fallback or error state if data is missing
          return const Scaffold(
            body: Center(child: Text("Product data missing")),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.wishlist,
        builder: (context, state) => const WishlistView(),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is bool) {
            return ProductSearchsPage(isFocused: extra);
          }
          return const ProductSearchsPage(isFocused: true);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) => const CheckoutView(),
      ),
      GoRoute(
        path: AppRoutes.orderSuccess,
        builder: (context, state) => const OrderSuccessView(),
      ),
      GoRoute(
        path: AppRoutes.editUserInfo,
        builder: (context, state) => const EditUserInfoView(),
      ),
      GoRoute(
        path: AppRoutes.orderView,
        builder: (context, state) => const OrderView(),
      ),
      GoRoute(
        path: AppRoutes.orderDetails,
        builder: (context, state) {
          final extra = state.extra;
          OrderModel? order;
          if (extra is OrderModel) {
            order = extra;
          } else if (extra is Map<String, dynamic>) {
            order = OrderModel.fromJson(extra);
          }
          
          if (order != null) {
            return OrderDetailsView(order: order);
          }
          return const Scaffold(
            body: Center(child: Text("ORDER_DATA_MISSING", style: TextStyle(color: AppColors.error, fontFamily: 'monospace'))),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.support,
        builder: (context, state) => const SupportsPage(),
      ),
      GoRoute(
        path: AppRoutes.help,
        builder: (context, state) => const HelpView(),
      ),
    ],
  );
});

enum PageTransitionType { fade, slideRight, slideUp, scale }

CustomTransitionPage<T> buildPageWithTransition<T>({
  required GoRouterState state,
  required Widget child,
  PageTransitionType transitionType = PageTransitionType.fade,
  Duration duration = const Duration(milliseconds: 300),
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case PageTransitionType.fade:
          return FadeTransition(opacity: animation, child: child);
        // TODO: Handle this case.
        case PageTransitionType.slideRight:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        // bottom to top
        case PageTransitionType.slideUp:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );

        // case PageTransitionType.slideUp:
        //   return SlideTransition(
        //     position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        //         .animate(animation),
        //     child: child,
        //   );

        case PageTransitionType.scale:
          return ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
            ),
            child: child,
          );
      }
    },
  );
}

/// A listenable that triggers whenever the auth state changes.
class AuthRefreshListenable extends ChangeNotifier {
  AuthRefreshListenable(Ref ref) {
    ref.listen(authControllerProvider, (previous, next) {
      // Trigger update whenever value changes (login/logout)
      if (previous?.value != next.value) {
        notifyListeners();
      }
    });
  }
}
