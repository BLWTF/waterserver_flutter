part of 'bill_cubit.dart';

enum BillManagementPage { main, view, print }

class BillState extends Equatable {
  final BillManagementPage page;
  final HomeStatus status;
  final String? message;
  final List<String> columns;
  final String? tableSearchQuery;
  final DateTime? billDate;
  final DateTime? currentBillDate;
  final Bill? selectedBill;
  final DateTime? printBillDate;
  final String? billPrintBy;
  final List<Area>? printByAreas;
  final List<Area> selectedPrintByAreas;
  final bool isPrinting;

  const BillState({
    required this.page,
    this.status = HomeStatus.normal,
    this.message,
    this.columns = Bill.defaultTableColumns,
    this.tableSearchQuery,
    this.billDate,
    this.currentBillDate,
    this.selectedBill,
    this.printBillDate,
    this.billPrintBy,
    this.printByAreas,
    this.selectedPrintByAreas = const [],
    this.isPrinting = false,
  });

  BillState copyWith({
    BillManagementPage? page,
    HomeStatus? status,
    String? message,
    List<String>? columns,
    String? tableSearchQuery,
    DateTime? billDate,
    DateTime? currentBillDate,
    Bill? selectedBill,
    DateTime? printBillDate,
    String? billPrintBy,
    List<Area>? printByAreas,
    List<Area>? selectedPrintByAreas,
    bool? isPrinting,
  }) =>
      BillState(
        page: page ?? this.page,
        status: status ?? this.status,
        message: message ?? this.message,
        columns: columns ?? this.columns,
        tableSearchQuery: tableSearchQuery ?? this.tableSearchQuery,
        billDate: billDate ?? this.billDate,
        currentBillDate: currentBillDate ?? this.currentBillDate,
        selectedBill: selectedBill ?? this.selectedBill,
        printBillDate: printBillDate ?? this.printBillDate,
        billPrintBy: billPrintBy ?? this.billPrintBy,
        printByAreas: printByAreas ?? this.printByAreas,
        selectedPrintByAreas: selectedPrintByAreas ?? this.selectedPrintByAreas,
        isPrinting: isPrinting ?? this.isPrinting,
      );

  BillState copyWithNullBillPrintBy(String? billPrintBy) => BillState(
        page: page,
        status: status,
        message: message,
        columns: columns,
        tableSearchQuery: tableSearchQuery,
        billDate: billDate,
        currentBillDate: currentBillDate,
        selectedBill: selectedBill,
        printBillDate: printBillDate,
        billPrintBy: billPrintBy,
        printByAreas: null,
        selectedPrintByAreas: const [],
        isPrinting: false,
      );

  @override
  List<Object?> get props => [
        page,
        status,
        message,
        columns,
        tableSearchQuery,
        billDate,
        currentBillDate,
        selectedBill,
        printBillDate,
        billPrintBy,
        printByAreas,
        selectedPrintByAreas,
        isPrinting,
      ];
}
