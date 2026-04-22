import 'package:get/get.dart';
import '../../domain/entities/support_entity.dart';
import '../../domain/usecases/get_supports_usecase.dart';
import '../../domain/usecases/get_support_by_id_usecase.dart';
import '../../domain/usecases/create_support_usecase.dart';

class SupportController extends GetxController {
  final GetSupportsUsecase getSupportsUsecase;
  final GetSupportByIdUsecase getSupportByIdUsecase;
  final CreateSupportUsecase createSupportUsecase;

  SupportController({
    required this.getSupportsUsecase,
    required this.getSupportByIdUsecase,
    required this.createSupportUsecase,
  });

  final RxList<SupportEntity> items = <SupportEntity>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    items.value = await getSupportsUsecase();
    isLoading.value = false;
  }
}
