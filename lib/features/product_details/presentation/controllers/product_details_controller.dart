import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:electronics_shop/core/services/wishlist_service.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/product/data/models/product_size_model.dart';

part 'product_details_controller.g.dart';

class ProductDetailsState {
  final int selectedImageIndex;
  final String selectedColor;
  final ProductSize? selectedSizeObject;
  final bool isInWishlist;

  ProductDetailsState({
    this.selectedImageIndex = 0,
    this.selectedColor = "",
    this.selectedSizeObject,
    this.isInWishlist = false,
  });

  ProductDetailsState copyWith({
    int? selectedImageIndex,
    String? selectedColor,
    ProductSize? selectedSizeObject,
    bool? isInWishlist,
  }) {
    return ProductDetailsState(
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSizeObject: selectedSizeObject ?? this.selectedSizeObject,
      isInWishlist: isInWishlist ?? this.isInWishlist,
    );
  }
}

@riverpod
class ProductDetailsController extends _$ProductDetailsController {
  @override
  ProductDetailsState build(
    ProductModel product, {
    String? initialColor,
    String? initialSize,
  }) {
    final wishlistService = ref.watch(wishlistServiceProvider.notifier);

    final color =
        initialColor ??
        (product.colors.isNotEmpty ? product.colors.first : "");

    ProductSize? sizeObj;
    if (product.productSizes.isNotEmpty) {
      if (initialSize != null) {
        sizeObj = product.productSizes.firstWhere(
          (s) => s.size == initialSize,
          orElse: () => product.productSizes.first,
        );
      } else {
        sizeObj = product.productSizes.first;
      }
    }

    return ProductDetailsState(
      selectedColor: color,
      selectedSizeObject: sizeObj,
      isInWishlist: wishlistService.isFavorite(product.id),
    );
  }

  void selectImage(int index) {
    state = state.copyWith(selectedImageIndex: index);
  }

  void toggleWishlist(ProductModel product) {
    final wishlistService = ref.read(wishlistServiceProvider.notifier);
    wishlistService.toggleFavorite(product);
    state = state.copyWith(
      isInWishlist: wishlistService.isFavorite(product.id),
    );
  }

  void updateColor(String color) {
    state = state.copyWith(selectedColor: color);
  }

  void updateSize(ProductModel product, String sizeName) {
    if (product.productSizes.isNotEmpty) {
      final sizeObj = product.productSizes.firstWhere(
        (s) => s.size == sizeName,
        orElse: () => state.selectedSizeObject!,
      );
      state = state.copyWith(selectedSizeObject: sizeObj);
    }
  }

  double getDisplayPrice(ProductModel product) =>
      product.getPriceForSize(state.selectedSizeObject?.size);

  double getDisplayEffectivePrice(ProductModel product) =>
      product.getEffectivePriceForSize(state.selectedSizeObject?.size);

  bool getDisplayHasDiscount(ProductModel product) =>
      product.hasDiscountForSize(state.selectedSizeObject?.size);
}
