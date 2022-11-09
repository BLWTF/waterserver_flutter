part of 'payment_cubit.dart';

enum PaymentManagementPage { main, form, view }

class PaymentState extends Equatable {
  final PaymentManagementPage page;
  final List<String> columns;
  final String? tableSearchQuery;
  final PaymentFormState? formState;
  final Payment? selectedPayment;
  final HomeStatus status;
  final String? message;

  const PaymentState({
    required this.page,
    this.status = HomeStatus.normal,
    this.columns = Payment.defaultTableColumns,
    this.tableSearchQuery,
    this.formState,
    this.selectedPayment,
    this.message,
  });

  PaymentState copyWith({
    PaymentManagementPage? page,
    HomeStatus? status,
    List<String>? columns,
    String? tableSearchQuery,
    PaymentFormState? formState,
    Payment? selectedPayment,
    String? message,
  }) =>
      PaymentState(
        page: page ?? this.page,
        status: status ?? this.status,
        columns: columns ?? this.columns,
        tableSearchQuery: tableSearchQuery ?? this.tableSearchQuery,
        formState: formState ?? this.formState,
        selectedPayment: selectedPayment ?? this.selectedPayment,
        message: message ?? this.message,
      );

  @override
  List<Object?> get props => [
        page,
        status,
        columns,
        tableSearchQuery,
        formState,
        selectedPayment,
        message,
      ];
}
