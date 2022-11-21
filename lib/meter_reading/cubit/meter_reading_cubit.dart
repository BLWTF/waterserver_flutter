import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/home/bloc/home_bloc.dart';
import 'package:waterserver/meter_reading/meter_reading.dart';
import 'package:waterserver/utilities/forms.dart';

part 'meter_reading_state.dart';

class MeterReadingCubit extends Cubit<MeterReadingState> {
  final ContractRepository _contractRepository;
  final MeterReadingRepository _meterReadingRepository;

  MeterReadingCubit({
    required ContractRepository contractRepository,
    required MeterReadingRepository meterReadingRepository,
  })  : _contractRepository = contractRepository,
        _meterReadingRepository = meterReadingRepository,
        super(const MeterReadingState(page: MeterReadingManagementPage.main));

  void pageChanged(MeterReadingManagementPage page) {
    emit(state.copyWith(page: page));
  }

  void viewFormPage() {
    emit(state.copyWith(
      page: MeterReadingManagementPage.form,
      formState: MeterReadingFormState(),
    ));
  }

  void viewReadingFromContractNo(String? contractNo) async {
    final reading = await _meterReadingRepository.getReadingByContract(
        contractNo: contractNo);
    viewReading(reading);
  }

  void viewReadingFromId(String id) async {
    final reading = await _meterReadingRepository.getReadingById(id);
    viewReading(reading);
  }

  void viewReading(MeterReading? reading) {
    if (reading == null) {
      _showError('Contract info provided does not exist.');
    } else {
      emit(state.copyWith(
        selectedReading: reading,
        page: MeterReadingManagementPage.view,
      ));
    }
  }

  void viewUpdateForm(MeterReading reading) async {
    final formState = MeterReadingFormState();
    final id = Name.dirty(reading.id!);
    final contractNoDisplay = RequiredName.dirty(reading.contractNo!);
    final contractNo = RequiredName.dirty(reading.contractNo!);
    final dpc = RequiredName.dirty(reading.dpc!);
    final firstName = Name.dirty(reading.firstName!);
    final lastName = RequiredName.dirty(reading.lastName!);
    final prevReading = Name.dirty(reading.previousReading?.toString());

    emit(state.copyWith(
      page: MeterReadingManagementPage.form,
      formState: formState.copyWith(
        id: id,
        contractNoDisplay: contractNoDisplay,
        contractNo: contractNo,
        dpc: dpc,
        firstName: firstName,
        lastName: lastName,
        previousReading: prevReading,
      ),
    ));
  }

  Future<void> findFormContract() async {
    _loadStatus('Searching for contract');
    final formState = state.formState!;
    final contractNo = formState.contractNoDisplay.value;
    final reading = await _meterReadingRepository.getReadingByContract(
        contractNo: contractNo);
    _clearStatus();

    if (reading != null) {
      final id = Name.dirty(reading.id!);
      final contractNoDisplay = RequiredName.dirty(reading.contractNo!);
      final contractNo = RequiredName.dirty(reading.contractNo!);
      final dpc = RequiredName.dirty(reading.dpc!);
      final firstName = Name.dirty(reading.firstName!);
      final lastName = RequiredName.dirty(reading.lastName!);
      final prevReading = Name.dirty(reading.previousReading?.toString());
      emit(state.copyWith(
        formState: formState.copyWith(
          id: id,
          contractNoDisplay: contractNoDisplay,
          contractNo: contractNo,
          dpc: dpc,
          firstName: firstName,
          lastName: lastName,
          previousReading: prevReading,
        ),
      ));
    } else {
      clearFormContract();
      _showError('Failed to find metered contract');
    }
  }

  void clearFormContract() {
    final formState = state.formState!;
    const id = Name.dirty();
    const contractNo = RequiredName.dirty();
    const dpc = RequiredName.dirty();
    const firstName = Name.dirty();
    const lastName = RequiredName.dirty();
    const prevReading = Name.dirty();
    emit(state.copyWith(
      formState: formState.copyWith(
        id: id,
        contractNo: contractNo,
        dpc: dpc,
        firstName: firstName,
        lastName: lastName,
        previousReading: prevReading,
      ),
    ));
  }

  void contractNoUpdated(String value) {
    final contractNoDisplay = RequiredName.dirty(value);
    final newFormState = state.formState == null
        ? MeterReadingFormState(contractNoDisplay: contractNoDisplay)
        : state.formState!.copyWith(contractNoDisplay: contractNoDisplay);

    emit(state.copyWith(formState: newFormState));
  }

  void presReadingUpdated(String value) {
    final prevReading = state.formState?.previousReading.value;
    final presReading =
        RequiredNumber.dirty(value, int.tryParse(prevReading ?? ''));
    final newFormState = state.formState == null
        ? MeterReadingFormState(presentReading: presReading)
        : state.formState!.copyWith(presentReading: presReading);

    emit(state.copyWith(formState: newFormState));
  }

  void readingDateUpdated(DateTime value) {
    final readingDate = Datetime.dirty(value);
    final newFormState = state.formState == null
        ? MeterReadingFormState(readingDate: readingDate)
        : state.formState!.copyWith(readingDate: readingDate);

    emit(state.copyWith(formState: newFormState));
  }

  void billingPeriodUpdated(DateTime value) {
    final billingPeriod = Datetime.dirty(value);

    final newFormState = state.formState == null
        ? MeterReadingFormState(billingPeriod: billingPeriod)
        : state.formState!.copyWith(billingPeriod: billingPeriod);

    emit(state.copyWith(formState: newFormState));
  }

  void datesDefault(DateTime? currentBillDate) {
    final billingPeriod = Datetime.dirty(currentBillDate);
    final readingDate = Datetime.dirty(DateTime.now());

    final newFormState = state.formState == null
        ? MeterReadingFormState(
            billingPeriod: billingPeriod, readingDate: readingDate)
        : state.formState!
            .copyWith(billingPeriod: billingPeriod, readingDate: readingDate);

    emit(state.copyWith(formState: newFormState));
  }

  void readingUpdated(MeterReadingFormState formState) async {
    _loadStatus('Creating reading...');
    final MeterReading reading = formState.toModel();
    await _meterReadingRepository.updateReading(reading);
    await Future.delayed(const Duration(seconds: 1));
    _clearStatus();

    emit(state.copyWith(
        page: MeterReadingManagementPage.main,
        formState: MeterReadingFormState()));
  }

  void _loadStatus(String? message) {
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
}
