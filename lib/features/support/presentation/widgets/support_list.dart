import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import '../controllers/support_providers.dart';
import 'support_card.dart';

class SupportList extends ConsumerWidget {
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const SupportList({
    super.key,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsState = ref.watch(supportControllerProvider);

    return ticketsState.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(
            child: Text(
              'NO_ACTIVE_TICKETS',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: shrinkWrap,
          physics: physics,
          itemCount: items.length,
          itemBuilder: (_, i) => SupportCard(entity: items[i]),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.cyan),
      ),
      error: (err, stack) => Center(
        child: Text(
          'ERROR_FETCHING_TICKETS',
          style: TextStyle(
            color: AppColors.error.withValues(alpha: 0.7),
            fontFamily: 'monospace',
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
