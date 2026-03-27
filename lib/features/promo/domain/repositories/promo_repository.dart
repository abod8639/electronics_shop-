import 'package:electronics_shop/features/promo/data/models/promo_model.dart';

abstract class PromoRepository {
  Future<List<PromoModel>> getPromos();
}
