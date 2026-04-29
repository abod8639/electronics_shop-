import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/support_entity.dart';
import '../../domain/usecases/get_supports_usecase.dart';
import '../../domain/usecases/get_support_by_id_usecase.dart';
import '../../domain/usecases/create_support_usecase.dart';

class SupportController extends StateNotifier<AsyncValue<List<SupportEntity>>> {
  final GetSupportsUsecase getSupportsUsecase;
  final GetSupportByIdUsecase getSupportByIdUsecase;
  final CreateSupportUsecase createSupportUsecase;

  SupportController({
    required this.getSupportsUsecase,
    required this.getSupportByIdUsecase,
    required this.createSupportUsecase,
  }) : super(const AsyncValue.loading()) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    try {
      state = const AsyncValue.loading();
      final results = await getSupportsUsecase();
      
      // For demo purposes, we'll add some dummy data if the list is empty
      if (results.isEmpty) {
        state = const AsyncValue.data([
          SupportEntity(id: 'TK-8821', name: 'Issue with display brightness'),
          SupportEntity(id: 'TK-8822', name: 'Refund request for Order #1234'),
        ]);
      } else {
        state = AsyncValue.data(results);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createTicket(String name) async {
    // Implementation for creating a new ticket
  }
}
