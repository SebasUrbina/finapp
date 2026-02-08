import 'package:finapp/domain/models/finance_models.dart';

class SharedExpensesState {
  final List<Person> persons;
  final Split? currentSplit;
  final bool isLoading;
  final String? error;

  const SharedExpensesState({
    this.persons = const [],
    this.currentSplit,
    this.isLoading = false,
    this.error,
  });

  SharedExpensesState copyWith({
    List<Person>? persons,
    Split? currentSplit,
    bool? isLoading,
    String? error,
  }) {
    return SharedExpensesState(
      persons: persons ?? this.persons,
      currentSplit: currentSplit ?? this.currentSplit,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
