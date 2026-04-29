import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/support_remote_datasource.dart';
import '../../data/datasources/support_local_datasource.dart';
import '../../data/repositories/support_repository_impl.dart';
import '../../domain/repositories/support_repository.dart';
import '../../domain/usecases/get_supports_usecase.dart';
import '../../domain/usecases/get_support_by_id_usecase.dart';
import '../../domain/usecases/create_support_usecase.dart';
import 'support_controller.dart';
import '../../domain/entities/support_entity.dart';

// Data Sources
final supportRemoteDataSourceProvider = Provider<SupportRemoteDatasource>((ref) {
  return SupportRemoteDatasourceImpl();
});

final supportLocalDataSourceProvider = Provider<SupportLocalDatasource>((ref) {
  return SupportLocalDatasourceImpl();
});

// Repository
final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupportRepositoryImpl(
    remoteDatasource: ref.watch(supportRemoteDataSourceProvider),
    localDatasource: ref.watch(supportLocalDataSourceProvider),
  );
});

// Use Cases
final getSupportsUseCaseProvider = Provider<GetSupportsUsecase>((ref) {
  return GetSupportsUsecase(ref.watch(supportRepositoryProvider));
});

final getSupportByIdUseCaseProvider = Provider<GetSupportByIdUsecase>((ref) {
  return GetSupportByIdUsecase(ref.watch(supportRepositoryProvider));
});

final createSupportUseCaseProvider = Provider<CreateSupportUsecase>((ref) {
  return CreateSupportUsecase(ref.watch(supportRepositoryProvider));
});

// State Notifier Provider for the Controller
final supportControllerProvider = StateNotifierProvider<SupportController, AsyncValue<List<SupportEntity>>>((ref) {
  return SupportController(
    getSupportsUsecase: ref.watch(getSupportsUseCaseProvider),
    getSupportByIdUsecase: ref.watch(getSupportByIdUseCaseProvider),
    createSupportUsecase: ref.watch(createSupportUseCaseProvider),
  );
});

// Search Query Provider
final supportSearchQueryProvider = StateProvider<String>((ref) => '');

// FAQ Data Provider (Static but could be remote)
final supportFAQProvider = Provider<List<Map<String, String>>>((ref) {
  return [
    {
      'question': 'How can I track my order?',
      'answer': 'You can track your order in the "Orders" section of your profile.'
    },
    {
      'question': 'What is your return policy?',
      'answer': 'We offer a 30-day return policy for most electronics.'
    },
    {
      'question': 'How do I reset my password?',
      'answer': 'Go to the login screen and click on "Forgot Password".'
    },
    {
      'question': 'Do you offer international shipping?',
      'answer': 'Yes, we ship to over 50 countries globally.'
    },
  ];
});
