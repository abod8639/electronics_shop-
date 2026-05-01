import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/features/search/data/datasources/search_local_datasource.dart';
import 'package:electronics_shop/features/search/data/datasources/search_remote_datasource.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:electronics_shop/features/home/presentation/controllers/home_controller.dart';
import 'package:electronics_shop/features/product/data/repositories/product_repository.dart';
import 'package:electronics_shop/features/profile/presentation/controllers/language_controller.dart';

part 'product_search_controller.g.dart';

@riverpod
class ProductSearchController extends _$ProductSearchController {
  final SearchLocalDataSource _localDataSource = SearchLocalDataSource();
  final TextEditingController textController = TextEditingController();

  Timer? _debounceTimer;

  List<ProductModel> _localProducts = [];
  List<ProductModel> _combinedResults = [];

  String _searchQuery = "";
  double _filterMinPrice = 0.0;
  double _filterMaxPrice = 1000.0;
  double _dataMinPrice = 0.0;
  double _dataMaxPrice = 1000.0;
  bool _hasSearched = false;

  double get filterMinPrice => _filterMinPrice;
  double get filterMaxPrice => _filterMaxPrice;
  double get dataMinPrice => _dataMinPrice;
  double get dataMaxPrice => _dataMaxPrice;
  String get searchQuery => _searchQuery;
  bool get hasSearched => _hasSearched;

  @override
  FutureOr<List<ProductModel>> build() {
    ref.onDispose(() {
      textController.dispose();
      _debounceTimer?.cancel();
    });

    // Listen to home products to populate the search screen initially when they load
    ref.listen(homeControllerProvider, (previous, next) {
      final homeProducts = next.value;
      if (homeProducts != null && homeProducts.isNotEmpty) {
        _localProducts = homeProducts;
        if (!_hasSearched) {
          _combinedResults = homeProducts;
          state = AsyncData(homeProducts);
        }
      }
    });

    // Initialize with cached products immediately if possible
    final cachedProducts = ref
        .read(productRepositoryProvider.notifier)
        .getCachedProducts();
    if (cachedProducts.isNotEmpty) {
      _localProducts = List.from(cachedProducts);
      _combinedResults = List.from(cachedProducts);
      return cachedProducts;
    }

    // Fallback to homeProducts if already loaded
    final homeProducts = ref.read(homeControllerProvider).value;
    if (homeProducts != null && homeProducts.isNotEmpty) {
      _localProducts = homeProducts;
      _combinedResults = homeProducts;
      return homeProducts;
    }

    return [];
  }

  void setProducts(List<ProductModel> products) {
    _localProducts = products;
    _updateDataBounds();
    _filterMinPrice = _dataMinPrice;
    _filterMaxPrice = _dataMaxPrice;
    _applyFilters();
  }

  void onSearchChanged(String query) {
    _searchQuery = query.trim();

    // 1. Instant local search for immediate feedback
    _performLocalSearchOnly(_searchQuery);

    // 2. Debounce remote search — this is the authoritative source
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _handleRemoteSearch(_searchQuery);
    });
  }

  /// Alias for onSearchChanged to maintain backward compatibility
  void updateSearchQuery(String query) {
    onSearchChanged(query);
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    _searchQuery = "";
    _hasSearched = false;
    textController.clear();

    // Rebuild the local product pool from cache + homeProducts
    _rebuildLocalProducts();

    _combinedResults = _localProducts;
    _updateDataBounds();
    state = AsyncData(_localProducts);
  }

  /// Rebuilds the local product pool using all available sources (cache + home)
  void _rebuildLocalProducts() {
    final cachedProducts = ref
        .read(productRepositoryProvider.notifier)
        .getCachedProducts();
    final homeProducts = ref.read(homeControllerProvider).value ?? [];

    // Merge cache and home products, deduplicated by ID
    final seen = <String>{};
    final merged = <ProductModel>[];
    for (var p in [...cachedProducts, ...homeProducts]) {
      if (seen.add(p.id)) merged.add(p);
    }
    if (merged.isNotEmpty) {
      _localProducts = merged;
    }
  }

  /// Performs an instant local search on the provided query
  void _performLocalSearchOnly(String query) {
    if (query.isEmpty) {
      _hasSearched = false;
      _rebuildLocalProducts();
      _combinedResults = _localProducts;
      state = AsyncData(_localProducts);
      return;
    }

    // Ensure we have the freshest full product pool before filtering
    _rebuildLocalProducts();

    _hasSearched = true;
    final locale = ref.read(languageControllerProvider).languageCode;

    // Search across ALL locally available products (cache + home)
    final results = _prioritizedLocalFilter(query, _localProducts, locale);
    _combinedResults = results;

    _updateDataBounds();
    _applyFiltersToResults(results);
  }

  /// Handles remote search — the API is the authoritative source for search
  /// because it has access to ALL products, not just the locally cached ones.
  Future<void> _handleRemoteSearch(String query) async {
    if (query.isEmpty) return;
    // If query changed while waiting, skip this stale call
    if (query != _searchQuery) return;

    try {
      final remoteDataSource = ref.read(searchRemoteDataSourceProvider);

      // Fetch all matching products from the API for this query
      final List<ProductModel> remoteResults = await remoteDataSource
          .fetchProductsFromApi(query);

      // The API result is authoritative — use it directly as the result set
      // Also cache any new products found by the remote search
      final cachedIds = _localProducts.map((e) => e.id).toSet();
      for (var p in remoteResults) {
        if (!cachedIds.contains(p.id)) {
          _localProducts.add(p);
          cachedIds.add(p.id);
        }
      }

      // Replace combined results with the authoritative API response
      _combinedResults = remoteResults;
      _updateDataBounds();
      _applyFiltersToResults(_combinedResults);
    } catch (e, st) {
      // Don't overwrite state with error if we already have local results
      if (_combinedResults.isEmpty) {
        state = AsyncError(e, st);
      }
    }
  }

  /// Advanced Local Filter: Multi-language & Multi-token Search
  List<ProductModel> _prioritizedLocalFilter(
    String query,
    List<ProductModel> products,
    String locale,
  ) {
    final lowerQuery = query.toLowerCase().trim();
    // Split the query into individual words (tokens)
    final searchTerms = lowerQuery
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();
    if (searchTerms.isEmpty) return [];

    final List<ProductModel> exact = [];
    final List<ProductModel> containsAllTokens = [];
    final List<ProductModel> containsAnyToken = [];

    for (var p in products) {
      // Gather all searchable fields across both Arabic and English regardless of current app locale
      final nameAr = (p.name?.ar ?? "").toLowerCase();
      final nameEn = (p.name?.en ?? "").toLowerCase();
      final brand = (p.brand ?? "").toLowerCase();
      final categoryAr = (p.category?.name?.ar ?? "").toLowerCase();
      final categoryEn = (p.category?.name?.en ?? "").toLowerCase();
      final tags = p.tags.map((t) => t.toLowerCase()).toList();

      // Exact match check (if the user types exactly the brand or name)
      if (nameAr == lowerQuery ||
          nameEn == lowerQuery ||
          brand == lowerQuery ||
          categoryAr == lowerQuery ||
          categoryEn == lowerQuery) {
        exact.add(p);
        continue;
      }

      // Combine text to check for tokens
      final fullText =
          "$nameAr $nameEn $brand $categoryAr $categoryEn ${tags.join(" ")}";

      bool matchesAll = true;
      bool matchesAny = false;

      for (var term in searchTerms) {
        if (fullText.contains(term)) {
          matchesAny = true;
        } else {
          matchesAll = false;
        }
      }

      if (matchesAll) {
        containsAllTokens.add(p);
      } else if (matchesAny) {
        containsAnyToken.add(p);
      }
    }

    // Deduplicate and combine results
    final combined = <ProductModel>[];
    final addedIds = <String>{};

    void addProducts(List<ProductModel> list) {
      for (var p in list) {
        if (!addedIds.contains(p.id)) {
          combined.add(p);
          addedIds.add(p.id);
        }
      }
    }

    // Priority 1: Exact matches
    addProducts(exact);
    // Priority 2: Matches that contain ALL query words (e.g., "samsung" AND "galaxy")
    addProducts(containsAllTokens);

    // Priority 3: Matches that contain ANY of the words, only if combined results are few
    if (combined.length < 5) {
      addProducts(containsAnyToken);
    }

    // Priority 4: Fuzzy search fallback if still few results
    if (combined.length < 5) {
      final fuzzyResults = _performLocalFuzzySearch(query, products, locale);
      addProducts(fuzzyResults);
    }

    return combined;
  }

  List<ProductModel> _performLocalFuzzySearch(
    String query,
    List<ProductModel> products,
    String locale,
  ) {
    if (query.isEmpty) return [];

    final fuse = Fuzzy<ProductModel>(
      products,
      options: FuzzyOptions(
        keys: [
          // Search across both English and Arabic names for better fuzzy matching
          WeightedKey(
            name: 'nameEn',
            getter: (p) => p.name?.en ?? "",
            weight: 1.0,
          ),
          WeightedKey(
            name: 'nameAr',
            getter: (p) => p.name?.ar ?? "",
            weight: 1.0,
          ),
          WeightedKey(name: 'brand', getter: (p) => p.brand ?? "", weight: 0.7),
        ],
        threshold: 0.35,
      ),
    );

    return fuse.search(query).take(10).map((r) => r.item).toList();
  }

  void _updateDataBounds() {
    final source = _combinedResults.isEmpty && !_hasSearched
        ? _localProducts
        : _combinedResults;
    if (source.isEmpty) return;

    final bounds = _localDataSource.calculatePriceBounds(source);
    _dataMinPrice = bounds['min']!;
    _dataMaxPrice = bounds['max']!;

    _filterMinPrice = _filterMinPrice.clamp(_dataMinPrice, _dataMaxPrice);
    _filterMaxPrice = _filterMaxPrice.clamp(_dataMinPrice, _dataMaxPrice);
  }

  void applyPriceFilter(double min, double max) {
    _filterMinPrice = min;
    _filterMaxPrice = max;
    _applyFiltersToResults(
      _combinedResults.isEmpty && !_hasSearched
          ? _localProducts
          : _combinedResults,
    );
  }

  void _applyFilters() {
    _applyFiltersToResults(_localProducts);
  }

  void _applyFiltersToResults(List<ProductModel> results) {
    // Ensure absolute uniqueness by ID before applying further states
    final uniqueProducts = <ProductModel>[];
    final seen = <String>{};
    for (var p in results) {
      if (!seen.contains(p.id)) {
        uniqueProducts.add(p);
        seen.add(p.id);
      }
    }

    final filtered = _localDataSource.filterByPrice(
      uniqueProducts,
      _filterMinPrice,
      _filterMaxPrice,
    );
    state = AsyncData(filtered);
  }
}
