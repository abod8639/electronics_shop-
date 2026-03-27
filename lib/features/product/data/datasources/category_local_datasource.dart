import 'package:hive/hive.dart';
import 'package:electronics_shop/features/product/data/models/category_model.dart';

class CategoryLocalDataSource {
  final Box<CategoryModel> _box = Hive.box<CategoryModel>('categories');

  List<CategoryModel> getCachedCategories() => _box.values.toList();

  Future<void> cacheCategories(List<CategoryModel> categories) async {
    await _box.clear();
    await _box.addAll(categories);
  }
}
