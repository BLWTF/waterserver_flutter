part of 'meter_reading_cubit.dart';

enum MeterReadingManagementPage { main, form, view }

class MeterReadingState extends Equatable {
  final MeterReadingManagementPage page;
  final List<String> columns;
  final String? tableSearchQuery;
  final MeterReadingFormState? formState;
  final MeterReading? selectedReading;
  final HomeStatus status;
  final String? message;

  const MeterReadingState({
    required this.page,
    this.columns = MeterReading.defaultTableColumns,
    this.tableSearchQuery,
    this.formState,
    this.selectedReading,
    this.status = HomeStatus.normal,
    this.message,
  });

  MeterReadingState copyWith({
    MeterReadingManagementPage? page,
    List<String>? columns,
    String? tableSearchQuery,
    MeterReadingFormState? formState,
    MeterReading? selectedReading,
    HomeStatus? status,
    String? message,
  }) =>
      MeterReadingState(
        page: page ?? this.page,
        columns: columns ?? this.columns,
        tableSearchQuery: tableSearchQuery ?? this.tableSearchQuery,
        formState: formState ?? this.formState,
        selectedReading: selectedReading ?? this.selectedReading,
        status: status ?? this.status,
        message: message ?? this.message,
      );

  @override
  List<Object?> get props => [
        page,
        columns,
        status,
        selectedReading,
        status,
        message,
        formState,
      ];
}
