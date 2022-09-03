part of 'bill_cubit.dart';

enum BillManagementPage { main, view }

class BillState extends Equatable {
  final BillManagementPage page;
  final HomeStatus status;
  final String? message;
  final List<String> columns;
  final String? tableSearchQuery;
  final DateTime? billDate;
  final DateTime? currentBillDate;
  final Bill? selectedBill;

  const BillState({
    required this.page,
    this.status = HomeStatus.normal,
    this.message,
    this.columns = Bill.defaultTableColumns,
    this.tableSearchQuery,
    this.billDate,
    this.currentBillDate,
    this.selectedBill,
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
        selectedBill
      ];
}
