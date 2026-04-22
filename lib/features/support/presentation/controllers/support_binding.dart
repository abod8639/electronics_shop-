import 'package:get/get.dart';
import '../../data/datasources/support_remote_datasource.dart';
import '../../data/datasources/support_local_datasource.dart';
import '../../data/repositories/support_repository_impl.dart';
import '../../domain/usecases/get_supports_usecase.dart';
import '../../domain/usecases/get_support_by_id_usecase.dart';
import '../../domain/usecases/create_support_usecase.dart';
import 'support_controller.dart';

class SupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportRemoteDatasource>(() => SupportRemoteDatasourceImpl());
    Get.lazyPut<SupportLocalDatasource>(() => SupportLocalDatasourceImpl());
    Get.lazyPut(() => SupportRepositoryImpl(
          remoteDatasource: Get.find(),
          localDatasource: Get.find(),
        ));
    Get.lazyPut(() => GetSupportsUsecase(Get.find()));
    Get.lazyPut(() => GetSupportByIdUsecase(Get.find()));
    Get.lazyPut(() => CreateSupportUsecase(Get.find()));
    Get.lazyPut(() => SupportController(
          getSupportsUsecase: Get.find(),
          getSupportByIdUsecase: Get.find(),
          createSupportUsecase: Get.find(),
        ));
  }
}
