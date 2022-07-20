import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waterserver/contract/contract.dart';

part 'contract_state.dart';

class ContractCubit extends Cubit<ContractState> {
  final ContractRepository _contractRepository;

  ContractCubit({required ContractRepository contractRepository})
      : _contractRepository = contractRepository,
        super(const ContractState()) {
    initDataTable();
  }

  void initDataTable() async {
    final customers = await _contractRepository.getCustomers();
    final tableData =
        ContractTableData(columns: state.columns, contracts: customers);
    emit(state.copyWith(tableData: tableData));
  }
}
