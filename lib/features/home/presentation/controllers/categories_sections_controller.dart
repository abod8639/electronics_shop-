import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:electronics_shop/features/home/data/models/selection_model.dart';
import 'package:electronics_shop/features/product/data/models/category_model.dart';
import 'package:electronics_shop/features/product/data/repositories/category_repository.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/language_controller.dart';
import 'package:electronics_shop/features/home/presentation/controllers/home_controller.dart';

part 'categories_sections_controller.g.dart';

@riverpod
class CategoriesSectionsController extends _$CategoriesSectionsController {
  @override
  FutureOr<List<SelectionsModel>> build() async {
    final categoryRepository = ref.watch(categoryRepositoryProvider.notifier);
    final locale = ref.watch(languageControllerProvider);
    final langCode = locale.languageCode;

    final cached = categoryRepository.getCachedCategories();
    if (cached.isNotEmpty) {
      _categories = cached;
      return _getSelectionsList(cached, langCode);
    }

    final fetched = await categoryRepository.getAllCategories();
    _categories = fetched;
    return _getSelectionsList(fetched, langCode);
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  Future<void> fetchCategories() async {
    state = const AsyncLoading();
    final categoryRepository = ref.read(categoryRepositoryProvider.notifier);
    final langCode = ref.read(languageControllerProvider).languageCode;
    try {
      final fetched = await categoryRepository.getAllCategories();
      _categories = fetched;
      state = AsyncData(_getSelectionsList(fetched, langCode));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  List<SelectionsModel> _getSelectionsList(
      List<CategoryModel> categoryList, String langCode) {
    return [
      SelectionsModel(id: "", label: 'categoryHome', icon: Icons.home),
      ...categoryList.map(
        (cat) => SelectionsModel(
          id: cat.id,
          label: cat.id, // Use ID as the label key for local mapping in ShortcutItem
          icon: _getIconForCategory(cat.id),
          image: cat.imageUrl,
        ),
      ),
    ];
  }

  void updateIndex(int index) {
    if (index >= 0 && state.hasValue && index < state.value!.length) {
      _selectedIndex = index;
      final selectedId = state.value![index].id;

      ref
          .read(homeControllerProvider.notifier)
          .fetchProductsForSection(
            index,
            categoryId: selectedId.isEmpty ? null : selectedId,
          );

      // إعادة تعيين الحالة لإعلام المستمعين بتغيير الـ selectedIndex
      // في Riverpod، يفضل فصل الـ selectedIndex في provider مستقل إذا كان يتغير كثيراً
      state = AsyncData(state.value!);
    }
  }

  IconData _getIconForCategory(String id) {
    final icons = {
      'phons': Icons.phone_android_rounded,
      'Watch': Icons.watch_rounded,
      'Laptops': Icons.laptop_rounded,
      'audio': Icons.headphones_rounded,
      'screens': Icons.tv_rounded,
      'cameras': Icons.camera_alt_rounded,
      'gaming': Icons.videogame_asset_rounded,
      'accessories': Icons.cable_rounded,
    };
    return icons[id] ?? Icons.category_rounded;
  }
}
