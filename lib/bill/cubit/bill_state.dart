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
  final AreaType? billPrintBy;
  final List<Area>? printByAreas;
  final List<Area> selectedPrintByAreas;
  final bool isPrinting;
  final PrintSession? printSession;

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
    this.printSession,
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
    AreaType? billPrintBy,
    List<Area>? printByAreas,
    List<Area>? selectedPrintByAreas,
    bool? isPrinting,
    PrintSession? printSession,
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
        printSession: printSession ?? this.printSession,
      );

  BillState copyWithNullBillPrintBy(AreaType? billPrintBy) => BillState(
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
        printSession: printSession,
      );

  BillState copyWithNullPrintSession() => BillState(
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
        printByAreas: printByAreas,
        selectedPrintByAreas: selectedPrintByAreas,
        isPrinting: isPrinting,
        printSession: null,
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
        printSession,
      ];
}

class PrintSession extends Equatable {
  final int billsCount;
  final int sessionsCompleted;
  final int printingNumber;
  final List<Bill> currentPrintBills;

  const PrintSession({
    required this.billsCount,
    this.sessionsCompleted = 0,
    this.printingNumber = 100,
    this.currentPrintBills = const [],
  });

  PrintSession copyWith({
    int? billsCount,
    int? sessionsCompleted,
    int? printingNumber,
    List<Bill>? currentPrintBills,
  }) =>
      PrintSession(
        billsCount: billsCount ?? this.billsCount,
        sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
        printingNumber: printingNumber ?? this.printingNumber,
        currentPrintBills: currentPrintBills ?? this.currentPrintBills,
      );

  int get sessions {
    int printSessions = billsCount ~/ printingNumber;
    if (lastSessionNumber > 0) {
      printSessions++;
    }
    return printSessions;
  }

  int get numberPrinted {
    if (sessionsCompleted == sessions) {
      return ((sessionsCompleted - 1) * printingNumber) + lastSessionNumber;
    }
    return sessionsCompleted * printingNumber;
  }

  int get lastSessionNumber => billsCount % printingNumber;

  @override
  List<Object?> get props => [
        billsCount,
        sessionsCompleted,
        printingNumber,
        sessions,
        lastSessionNumber,
        currentPrintBills,
      ];
}
