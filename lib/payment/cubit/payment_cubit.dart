import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/home/home.dart';
import 'package:waterserver/payment/payment.dart';
import 'package:waterserver/utilities/forms.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final ContractRepository _contractRepository;
  final PaymentRepository _paymentRepository;

  PaymentCubit({
    required ContractRepository contractRepository,
    required PaymentRepository paymentRepository,
  })  : _contractRepository = contractRepository,
        _paymentRepository = paymentRepository,
        super(const PaymentState(page: PaymentManagementPage.main));

  void tableSearch(String query) {
    emit(state.copyWith(tableSearchQuery: query));
  }

  void pageChanged(PaymentManagementPage page) {
    emit(state.copyWith(page: page));
  }

  void deletePayment(String id) async {
    _loadStatus('Deleting payment');
    await _paymentRepository.deletePayment(id);
    await Future.delayed(const Duration(seconds: 1));
    _clearStatus();
    emit(state.copyWith(page: PaymentManagementPage.main));
  }

  void contractNoUpdated(String value) {
    final contractNo = RequiredName.dirty(value);
    final newFormState = state.formState == null
        ? PaymentFormState(contractNo: contractNo)
        : state.formState!.copyWith(contractNo: contractNo);

    emit(state.copyWith(formState: newFormState));
  }

  void amountUpdated(String value) {
    final amount = RequiredNumber.dirty(value);
    final newFormState = state.formState == null
        ? PaymentFormState(amount: amount)
        : state.formState!.copyWith(amount: amount);

    emit(state.copyWith(formState: newFormState));
  }

  void receiptNoUpdated(String value) {
    final receiptNo = Name.dirty(value);
    final newFormState = state.formState == null
        ? PaymentFormState(receiptNo: receiptNo)
        : state.formState!.copyWith(receiptNo: receiptNo);

    emit(state.copyWith(formState: newFormState));
  }

  void dateUpdated(DateTime value) {
    final date = Datetime.dirty(value);

    final newFormState = state.formState == null
        ? PaymentFormState(dateTime: date)
        : state.formState!.copyWith(dateTime: date);

    emit(state.copyWith(formState: newFormState));
  }

  void billingPeriodUpdated(DateTime value) {
    final billingPeriod = Datetime.dirty(value);

    final newFormState = state.formState == null
        ? PaymentFormState(billPeriod: billingPeriod)
        : state.formState!.copyWith(billPeriod: billingPeriod);

    emit(state.copyWith(formState: newFormState));
  }

  void datesDefault(DateTime? currentBillDate) {
    final billingPeriod = Datetime.dirty(currentBillDate);
    final date = Datetime.dirty(DateTime.now());

    final newFormState = state.formState == null
        ? PaymentFormState(billPeriod: billingPeriod, dateTime: date)
        : state.formState!.copyWith(billPeriod: billingPeriod, dateTime: date);

    emit(state.copyWith(formState: newFormState));
  }

  void paymentCreated(PaymentFormState formState) async {
    _loadStatus('Creating payment...');
    final Payment payment = formState.toModel();
    final newPayment = await _paymentRepository.createPayment(payment);
    await Future.delayed(const Duration(seconds: 1));
    _clearStatus();

    emit(state.copyWith(
        page: PaymentManagementPage.main, formState: PaymentFormState()));
  }

  Future<void> findFormContract() async {
    _loadStatus('Searching for contract');
    final formState = state.formState!;
    final contractNo = formState.contractNo.value;
    final contract =
        await _contractRepository.getContract(contractNo: contractNo);
    _clearStatus();
    if (contract != null) {
      final contractId = RequiredName.dirty(contract.id!);
      final dpc = RequiredName.dirty(contract.dpc!);
      final fullName = RequiredName.dirty(contract.name);
      final tariff = Name.dirty(contract.tariff);
      final district = Name.dirty(contract.district);
      final zone = Name.dirty(contract.zone);
      emit(state.copyWith(
        formState: formState.copyWith(
          contractId: contractId,
          dpc: dpc,
          fullName: fullName,
          tariff: tariff,
          district: district,
          zone: zone,
        ),
      ));
    } else {
      const contractId = RequiredName.dirty();
      const dpc = RequiredName.dirty();
      const fullName = RequiredName.dirty();
      const tariff = Name.dirty();
      const district = Name.dirty();
      const zone = Name.dirty();
      emit(state.copyWith(
        formState: formState.copyWith(
          contractId: contractId,
          dpc: dpc,
          fullName: fullName,
          tariff: tariff,
          district: district,
          zone: zone,
        ),
      ));
      _showError('Failed to find contract');
    }
  }

  void viewPaymentFromId(String id) async {
    final payment = await _paymentRepository.getPayment(id);
    // print(id);
    emit(state.copyWith(
      selectedPayment: payment,
      page: PaymentManagementPage.view,
    ));
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
