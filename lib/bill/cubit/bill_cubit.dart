import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waterserver/bill/bill.dart';
import 'package:waterserver/home/home.dart';

part 'bill_state.dart';

class BillCubit extends Cubit<BillState> {
  final BillRepository _billRepository;
  final _billDate = StreamController<DateTime?>.broadcast();
  Stream<DateTime?> get billDate => _billDate.stream;

  BillCubit({required BillRepository billRepository})
      : _billRepository = billRepository,
        super(const BillState(page: BillManagementPage.main)) {
    _init();
  }

  void _init() async {
    final billDate = await _billRepository.getCurrentBillDate();
    _billDate.sink.add(
      billDate,
    );
    emit(state.copyWith(
      billDate: billDate,
      currentBillDate: billDate,
    ));
  }

  void billDateChanged(DateTime dateTime) {
    _billDate.sink.add(dateTime);
    emit(state.copyWith(billDate: dateTime));
  }

  void billDateReset() async {
    final billDate = await _billRepository.getCurrentBillDate();
    _billDate.sink.add(billDate);
    emit(state.copyWith(billDate: billDate));
  }

  void pageChanged(BillManagementPage page) {
    emit(state.copyWith(page: page));
  }

  void tableSearch(String query) {
    emit(state.copyWith(tableSearchQuery: query));
  }

  void viewBill(Bill? bill) {
    if (bill == null) {
      _showError('Bill info provided does not exist.');
    } else {
      emit(state.copyWith(
        selectedBill: bill,
        page: BillManagementPage.view,
      ));
    }
  }

  void viewBillFromContractNo(String contractNo, [DateTime? billDate]) async {
    _loadStatus('Searching for bill');
    final bill = await _billRepository.getBill(
        contractNo: contractNo, billDate: billDate);
    _clearStatus();
    viewBill(bill);
  }

  void viewBillFromId(String? id) async {
    final bool master = state.billDate != state.currentBillDate ? true : false;
    final contract = await _billRepository.getBill(
      id: id,
      master: master,
    );
    viewBill(contract);
  }

  void _loadStatus([String? message]) {
    emit(state.copyWith(
        status: HomeStatus.loading,
        message: message ?? 'Please wait while loading...'));
  }

  void _clearStatus() {
    emit(state.copyWith(status: HomeStatus.clear));

    emit(state.copyWith(status: HomeStatus.normal));
  }

  void _showError(String? message) {
    emit(state.copyWith(
      status: HomeStatus.error,
      message: message,
    ));

    emit(state.copyWith(status: HomeStatus.normal));
  }

  @override
  Future<void> close() {
    _billDate.close();
    return super.close();
  }
}
