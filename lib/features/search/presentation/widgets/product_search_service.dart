import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:fuzzy/fuzzy.dart';

class ProductSearchService {
  static List<Object> getSuggestions({
    required String query,
    required List<ProductModel> products,
    required List<String> history,
    required String locale,
  }) {
    final cleanQuery = query.toLowerCase().trim();
    if (cleanQuery.isEmpty) return history;

    // logic للبحث المتطابق
    final results = products.where((p) {
      final name = p.getLocalizedName(locale: locale).toLowerCase();
      final brand = (p.brand ?? "").toLowerCase();
      return name.contains(cleanQuery) || brand.contains(cleanQuery);
    }).toList();

    if (results.isEmpty) {
      // هنا يمكن استدعاء Fuzzy logic إذا لم يوجد نتائج
      return _runFuzzySearch(cleanQuery, products, locale);
    }
    return results;
  }

  static List<ProductModel> _runFuzzySearch(
    String query,
    List<ProductModel> products,
    String locale,
  ) {
    final fuse = Fuzzy<ProductModel>(
      products,
      options: FuzzyOptions(
        keys: [
          WeightedKey(
            name: 'name',
            getter: (p) => p.getLocalizedName(locale: locale),
            weight: 1.0,
          ),
        ],
        threshold: 0.35,
      ),
    );
    return fuse.search(query).take(5).map((r) => r.item).toList();
  }
}
