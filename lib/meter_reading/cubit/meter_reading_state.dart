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
