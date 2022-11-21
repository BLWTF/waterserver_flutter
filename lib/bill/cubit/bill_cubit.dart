import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waterserver/area/area.dart';
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

  Future<void> printSessionInfo() async {
    final selectedAreas =
        state.selectedPrintByAreas.map((e) => e.code).toList();
    final printBy = state.billPrintBy!;
    final date = state.printBillDate ?? state.billDate;
    final billsCount =
        await _billRepository.countBillsByAreas(selectedAreas, printBy, date!);
    final printSession = PrintSession(billsCount: billsCount);
    emit(state.copyWith(printSession: printSession));
  }

  Future<void> proceedPrintSession([bool increased = false]) async {
    late final PrintSession printSession;
    final selectedAreas =
        state.selectedPrintByAreas.map((e) => e.code).toList();
    final printBy = state.billPrintBy!;
    final date = state.printBillDate ?? state.billDate;

    if (!increased) {
      printSession = state.printSession!;
    } else {
      printSession = state.printSession!.copyWith(
          sessionsCompleted: (state.printSession!.sessionsCompleted + 1));
    }

    final bills = await _billRepository.getBillsByAreas(
      areas: selectedAreas,
      areaType: printBy,
      date: date!,
      limit: printSession.printingNumber,
      offset: printSession.printingNumber * printSession.sessionsCompleted,
      orderBy: Bill.getFPEquivalent('id'),
    );

    emit(state.copyWith(
      printSession: printSession.copyWith(
        currentPrintBills: bills,
      ),
    ));
  }

  void cancelPrintSession() {
    emit(state.copyWithNullPrintSession());
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

  void updatePrintBillDate(DateTime date) {
    emit(state.copyWith(printBillDate: date));
  }

  Future<void> updateBillPrintBy(AreaType? printBy, DateTime billDate) async {
    emit(state.copyWithNullBillPrintBy(printBy));

    if (printBy == null) return;

    late final List<Area> areas;
    switch (printBy) {
      case AreaType.district:
        areas = (await _billRepository.getBillPeriodDistricts(billDate))
            .map((e) => e.toArea())
            .toList();
        break;
      case AreaType.zone:
        areas = (await _billRepository.getBillPeriodZones(billDate))
            .map((e) => e.toArea())
            .toList();
        break;
      case AreaType.subzone:
        areas = (await _billRepository.getBillPeriodSubzones(billDate))
            .map((e) => e.toArea())
            .toList();
        break;
      case AreaType.round:
        areas = (await _billRepository.getBillPeriodRounds(billDate))
            .map((e) => e.toArea())
            .toList();
        break;
    }
    emit(state.copyWith(printByAreas: areas, selectedPrintByAreas: areas));
  }

  void selectArea(Area area) {
    final selectedPrintByAreas = [...state.selectedPrintByAreas, area];

    emit(state.copyWith(selectedPrintByAreas: selectedPrintByAreas));
  }

  void deselectArea(Area area) {
    List<Area> selectedPrintByAreas = [...state.selectedPrintByAreas];
    selectedPrintByAreas.remove(area);

    emit(state.copyWith(selectedPrintByAreas: selectedPrintByAreas));
  }

  void selectAllAreas() {
    emit(state.copyWith(selectedPrintByAreas: [...?state.printByAreas]));
  }

  void deselectAllAreas() {
    emit(state.copyWith(selectedPrintByAreas: []));
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
