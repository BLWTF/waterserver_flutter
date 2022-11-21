import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waterserver/bill/repository/bill_repository.dart';
import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/home/home.dart';
import 'package:waterserver/meter_reading/meter_reading.dart';
import 'package:waterserver/tariff/model/tariff.dart';
import 'package:waterserver/utilities/forms.dart';

part 'contract_state.dart';

class ContractCubit extends Cubit<ContractState> {
  final ContractRepository _contractRepository;
  final BillRepository _billRepository;
  final MeterReadingRepository _meterReadingRepository;

  ContractCubit({
    required ContractRepository contractRepository,
    required BillRepository billRepository,
    required MeterReadingRepository meterReadingRepository,
  })  : _contractRepository = contractRepository,
        _billRepository = billRepository,
        _meterReadingRepository = meterReadingRepository,
        super(const ContractState(page: ContractManagementPage.main));

  void pageChanged(ContractManagementPage page) {
    emit(state.copyWith(page: page));
  }

  void tableSearch(String query) {
    emit(state.copyWith(tableSearchQuery: query));
  }

  void lastNameUpdated(String value) {
    final lastName = RequiredName.dirty(value);
    final newFormState = state.formState == null
        ? ContractFormState(lastName: lastName)
        : state.formState!.copyWith(lastName: lastName);

    emit(state.copyWith(formState: newFormState));
  }

  void middleNameUpdated(String value) {
    final middleName = Name.dirty(value);
    final newFormState = state.formState == null
        ? ContractFormState(middleName: middleName)
        : state.formState!.copyWith(middleName: middleName);

    emit(state.copyWith(formState: newFormState));
  }

  void firstNameUpdated(String value) {
    final firstName = Name.dirty(value);
    final newFormState = state.formState == null
        ? ContractFormState(firstName: firstName)
        : state.formState!.copyWith(firstName: firstName);

    emit(state.copyWith(formState: newFormState));
  }

  void connectionAddressUpdated(String value) {
    final connectionAddress = Address.dirty(value);
    final newFormState = state.formState == null
        ? ContractFormState(connectionAddress: connectionAddress)
        : state.formState!.copyWith(connectionAddress: connectionAddress);

    emit(state.copyWith(formState: newFormState));
  }

  void billingAddressUpdated(String value) {
    final billingAddress = Address.dirty(value);
    final newFormState = state.formState == null
        ? ContractFormState(billingAddress: billingAddress)
        : state.formState!.copyWith(billingAddress: billingAddress);

    emit(state.copyWith(formState: newFormState));
  }

  void phoneUpdated(String value) {
    final phone = Phone.dirty(value);
    final newFormState = state.formState == null
        ? ContractFormState(phone: phone)
        : state.formState!.copyWith(phone: phone);

    emit(state.copyWith(formState: newFormState));
  }

  void emailUpdated(String value) {
    final email = Email.dirty(value);
    final newFormState = state.formState == null
        ? ContractFormState(email: email)
        : state.formState!.copyWith(email: email);

    emit(state.copyWith(formState: newFormState));
  }

  void meterNoUpdated(String value) {
    final meterNo = Name.dirty(value);
    final newFormState = state.formState == null
        ? ContractFormState(meterNo: meterNo)
        : state.formState!.copyWith(meterNo: meterNo);

    emit(state.copyWith(formState: newFormState));
  }

  void meterSizeUpdated(String value) {
    final meterSize = Name.dirty(value);
    final newFormState = state.formState == null
        ? ContractFormState(meterSize: meterSize)
        : state.formState!.copyWith(meterSize: meterSize);

    emit(state.copyWith(formState: newFormState));
  }

  void meterTypeUpdated(String value) {
    final meterType = Name.dirty(value);
    final newFormState = state.formState == null
        ? ContractFormState(meterType: meterType)
        : state.formState!.copyWith(meterType: meterType);

    emit(state.copyWith(formState: newFormState));
  }

  void districtUpdated(String value) {
    final district = ComboField.dirty(value);
    final newFormState = state.formState == null
        ? ContractFormState(district: district, zone: const ComboField.pure())
        : state.formState!
            .copyWith(district: district, zone: const ComboField.pure());

    emit(state.copyWith(formState: newFormState));
  }

  void zoneUpdated(String value) {
    final zone = ComboField.dirty(value);
    final newFormState = state.formState == null
        ? ContractFormState(zone: zone, subzone: const ComboField.pure())
        : state.formState!
            .copyWith(zone: zone, subzone: const ComboField.pure());

    emit(state.copyWith(formState: newFormState));
  }

  void subzoneUpdated(String value) {
    final subzone = ComboField.dirty(value);
    final newFormState = state.formState == null
        ? ContractFormState(subzone: subzone)
        : state.formState!.copyWith(subzone: subzone);

    emit(state.copyWith(formState: newFormState));
  }

  Future<void> roundUpdated(String roundCode) async {
    final round = ComboField.dirty(roundCode);
    final newFolio = await _contractRepository.getNewFolio(
      round: roundCode,
    );
    final folio = Name.dirty(newFolio.toString());
    final newFormState = state.formState == null
        ? ContractFormState(round: round, folio: folio)
        : state.formState!.copyWith(round: round, folio: folio);

    emit(state.copyWith(formState: newFormState));
  }

  void folioUpdated(String value) {
    final folio = Name.dirty(value);
    final newFormState = state.formState == null
        ? ContractFormState(folio: folio)
        : state.formState!.copyWith(folio: folio);

    emit(state.copyWith(formState: newFormState));
  }

  void tariffUpdated(Tariff tariffValue) {
    final tariff = ComboField.dirty(tariffValue.name);
    final category = Name.dirty(tariffValue.category);
    final subcategory = Name.dirty(tariffValue.subcategory);
    final consumptionType = Name.dirty(tariffValue.consumptionType);
    final volume = Number.dirty(tariffValue.volume);
    final agreedVolume = Number.dirty(tariffValue.agreedVolume);
    final limit = Number.dirty(tariffValue.limit);
    final rate = Number.dirty(tariffValue.rate);
    const meterNo = Name.pure();
    const meterSize = Name.pure();
    const meterType = Name.pure();
    final newFormState = state.formState == null
        ? ContractFormState(
            tariff: tariff,
            category: category,
            subcategory: subcategory,
            consumptionType: consumptionType,
            volume: volume,
            agreedVolume: agreedVolume,
            limit: limit,
            rate: rate,
            meterNo: meterNo,
            meterType: meterType,
            meterSize: meterSize,
          )
        : state.formState!.copyWith(
            tariff: tariff,
            category: category,
            subcategory: subcategory,
            consumptionType: consumptionType,
            volume: volume,
            agreedVolume: agreedVolume,
            limit: limit,
            rate: rate,
            meterNo: meterNo,
            meterSize: meterSize,
            meterType: meterType,
          );

    emit(state.copyWith(formState: newFormState));
  }

  void contractCreated(ContractFormState formState) async {
    _loadStatus('Creating contract...');
    await Future.delayed(const Duration(seconds: 1));
    final Contract contract = formState.toModel();
    final newContract = await _contractRepository.createContract(contract);
    _clearStatus();

    _loadStatus('Creating bill...');
    await Future.delayed(const Duration(seconds: 1));
    await _billRepository.createBill(newContract);
    _clearStatus();

    if (newContract.isMetered) {
      _loadStatus('Creating meter reading...');
      await Future.delayed(const Duration(seconds: 1));
      await _meterReadingRepository.createReading(newContract);
      _clearStatus();
    }

    emit(state.copyWith(formState: const ContractFormState()));
    viewContract(newContract);
  }

  void viewContractFromId(String? id) async {
    final contract = await _contractRepository.getContract(id: id);
    viewContract(contract);
  }

  void contractUpdated(ContractFormState formState) async {
    _loadStatus('Updating contract...');
    final Contract contract = formState.toModel();
    await _contractRepository.updateContract(contract);
    _clearStatus();
    emit(state.copyWith(formState: const ContractFormState()));
    viewContract(contract);
  }

  void viewContractFromContractNo(String? contractNo) async {
    final contract =
        await _contractRepository.getContract(contractNo: contractNo);
    viewContract(contract);
  }

  void viewContract(Contract? contract) {
    if (contract == null) {
      _showError('Contract info provided does not exist.');
    } else {
      emit(state.copyWith(
        selectedContract: contract,
        page: ContractManagementPage.view,
      ));
    }
  }

  void viewEditFormContract() {
    emit(state.copyWith(
      page: ContractManagementPage.form,
      formState: ContractFormState.fromModel(state.selectedContract!),
    ));
  }

  void viewNewContractPage() {
    emit(state.copyWith(
      page: ContractManagementPage.form,
      formState: state.formState != null && state.formState!.id.pure
          ? state.formState
          : const ContractFormState(),
    ));
  }

  void copyAddresses() {
    final formState = state.formState!;
    emit(state.copyWith(
        formState:
            formState.copyWith(billingAddress: formState.connectionAddress)));
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
