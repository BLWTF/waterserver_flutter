part of 'contract_cubit.dart';

enum ContractManagementPage { main, form, view }

class ContractState extends Equatable {
  final ContractManagementPage page;
  final List<String> columns;
  final String? tableSearchQuery;
  final ContractFormState? formState;
  final Contract? selectedContract;
  final HomeStatus status;
  final String? message;

  const ContractState({
    required this.page,
    this.columns = Contract.defaultTableColumns,
    this.tableSearchQuery,
    this.formState,
    this.selectedContract,
    this.status = HomeStatus.normal,
    this.message,
  });

  ContractState copyWith({
    ContractManagementPage? page,
    List<String>? columns,
    String? tableSearchQuery,
    ContractFormState? formState,
    Contract? selectedContract,
    HomeStatus? status,
    String? message,
  }) =>
      ContractState(
        page: page ?? this.page,
        columns: columns ?? this.columns,
        tableSearchQuery: tableSearchQuery ?? this.tableSearchQuery,
        formState: formState ?? this.formState,
        selectedContract: selectedContract ?? this.selectedContract,
        status: status ?? this.status,
        message: message ?? this.message,
      );

  @override
  List<Object?> get props => [
        page,
        columns,
        tableSearchQuery,
        formState,
        selectedContract,
        status,
        message
      ];
}
