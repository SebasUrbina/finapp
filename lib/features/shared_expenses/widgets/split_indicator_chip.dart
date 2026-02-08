import 'package:finapp/domain/models/finance_models.dart';
import 'package:finapp/features/shared_expenses/shared_expenses_controller.dart';
import 'package:finapp/data/providers/finance_providers.dart';
import 'package:flutter/material.dart' hide Split;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplitIndicatorChip extends ConsumerWidget {
  final Split split;
  final Money totalAmount;
  final String currentUserId;

  const SplitIndicatorChip({
    super.key,
    required this.split,
    required this.totalAmount,
    this.currentUserId = 'p1', // Default to first person (Sebastián)
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final personsAsync = ref.watch(personsProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: personsAsync.when(
        loading: () => const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (_, __) => const Icon(Icons.error_outline, size: 14),
        data: (persons) {
          // Get controller to access utility methods
          final controller = ref.read(sharedExpensesControllerProvider);

          // Calculate my share
          final myShare = _calculateMyShare();
          final participantsText = controller.getParticipantsText(
            split,
            persons,
          );

          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            runSpacing: 2,
            children: [
              Icon(Icons.people_outline, size: 14, color: colors.primary),
              Text(
                participantsText,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              if (myShare != null) ...[
                Text(
                  '•',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.primary.withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  'Tu parte: \$${myShare.toStringAsFixed(0)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  double? _calculateMyShare() {
    final myParticipant = split.participants.firstWhere(
      (p) => p.personId == currentUserId,
      orElse: () => const SplitParticipant(personId: '', value: 0),
    );

    if (myParticipant.personId.isEmpty) return null;

    switch (split.type) {
      case SplitType.equal:
      case SplitType.fixedAmount:
        return myParticipant.value;
      case SplitType.percentage:
        return totalAmount.value * myParticipant.value;
    }
  }
}
