import 'package:electronics_shop/core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import 'package:electronics_shop/features/product/data/models/category_model.dart';

class CategoryRemoteDataSource {
  final ApiService _apiService;

  CategoryRemoteDataSource(this._apiService);

  Future<List<CategoryModel>> fetchCategoriesFromApi() async {
    final response = await _apiService.get(ApiConfig.categories);
    List<dynamic> list = (response.data is Map)
        ? response.data['data']
        : response.data;
    return list.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
