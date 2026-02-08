import 'package:finapp/domain/models/finance_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for shared expenses split operations
/// This is a pure utility class that only handles split calculations
/// Person management is handled by PersonsController
class SharedExpensesController {
  // Creación de splits
  Split createEqualSplit(Money total, List<String> personIds) {
    final count = personIds.length;
    final shareValue = total.value / count;

    final participants = personIds.map((id) {
      return SplitParticipant(personId: id, value: shareValue);
    }).toList();

    return Split(type: SplitType.equal, participants: participants);
  }

  Split createPercentageSplit(Money total, Map<String, double> percentages) {
    final participants = percentages.entries.map((entry) {
      return SplitParticipant(
        personId: entry.key,
        value: entry.value, // Porcentaje (0-1)
      );
    }).toList();

    return Split(type: SplitType.percentage, participants: participants);
  }

  Split createFixedSplit(Map<String, Money> amounts) {
    final participants = amounts.entries.map((entry) {
      return SplitParticipant(personId: entry.key, value: entry.value.value);
    }).toList();

    return Split(type: SplitType.fixedAmount, participants: participants);
  }

  // Validaciones
  bool validateSplit(Split split, Money totalAmount) {
    if (split.participants.isEmpty) return false;

    switch (split.type) {
      case SplitType.equal:
        return true; // Siempre válido si hay participantes

      case SplitType.percentage:
        final totalPercentage = split.participants.fold<double>(
          0,
          (sum, p) => sum + p.value,
        );
        return (totalPercentage - 1.0).abs() < 0.01; // Debe sumar ~100%

      case SplitType.fixedAmount:
        final totalFixed = split.participants.fold<double>(
          0,
          (sum, p) => sum + p.value,
        );
        return (totalFixed - totalAmount.value).abs() <
            0.01; // Debe sumar el total
    }
  }

  // Utilidades
  Money getMyShare(Transaction transaction, String myUserId) {
    if (transaction.split == null) return transaction.amount;

    final split = transaction.split!;
    final myParticipant = split.participants.firstWhere(
      (p) => p.personId == myUserId,
      orElse: () => SplitParticipant(personId: myUserId, value: 0),
    );

    switch (split.type) {
      case SplitType.equal:
      case SplitType.fixedAmount:
        return Money(myParticipant.value);

      case SplitType.percentage:
        return Money(transaction.amount.value * myParticipant.value);
    }
  }

  List<Person> getParticipants(Split split, List<Person> allPersons) {
    return split.participants
        .map(
          (p) => allPersons.firstWhere(
            (person) => person.id == p.personId,
            orElse: () => Person(id: p.personId, name: 'Desconocido'),
          ),
        )
        .toList();
  }

  String getParticipantsText(Split split, List<Person> allPersons) {
    final participants = getParticipants(split, allPersons);
    if (participants.isEmpty) return '';
    if (participants.length == 1) return participants.first.name;
    if (participants.length == 2) {
      return '${participants[0].name} y ${participants[1].name}';
    }
    return '${participants.length} personas';
  }
}

/// Provider for SharedExpensesController (stateless utility)
final sharedExpensesControllerProvider = Provider<SharedExpensesController>((
  ref,
) {
  return SharedExpensesController();
});
