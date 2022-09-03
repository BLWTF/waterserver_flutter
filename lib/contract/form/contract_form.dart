import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:waterserver/area/area.dart';
import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/tariff/tariff.dart';

class ContractFormState extends Equatable with FormzMixin {
  final Name id;
  final Name contractNo;
  final Name dpc;
  final RequiredName lastName;
  final Name firstName;
  final Name middleName;
  final ComboField tariff;
  final Name category;
  final Name subcategory;
  final Name consumptionType;
  final Address connectionAddress;
  final Address billingAddress;
  final Phone phone;
  final Email email;
  final Number volume;
  final Number agreedVolume;
  final Number limit;
  final Number rate;
  final Name meterNo;
  final Name meterSize;
  final Name meterType;
  final ComboField district;
  final ComboField zone;
  final ComboField subzone;
  final ComboField round;

  const ContractFormState({
    this.id = const Name.pure(),
    this.contractNo = const Name.pure(),
    this.dpc = const Name.pure(),
    this.lastName = const RequiredName.pure(),
    this.firstName = const Name.pure(),
    this.middleName = const Name.pure(),
    this.tariff = const ComboField.pure(),
    this.category = const Name.pure(),
    this.subcategory = const Name.pure(),
    this.consumptionType = const Name.pure(),
    this.connectionAddress = const Address.pure(),
    this.billingAddress = const Address.pure(),
    this.phone = const Phone.pure(),
    this.email = const Email.pure(),
    this.volume = const Number.pure(),
    this.agreedVolume = const Number.pure(),
    this.limit = const Number.pure(),
    this.rate = const Number.pure(),
    this.meterNo = const Name.pure(),
    this.meterSize = const Name.pure(),
    this.meterType = const Name.pure(),
    this.district = const ComboField.pure(),
    this.zone = const ComboField.pure(),
    this.subzone = const ComboField.pure(),
    this.round = const ComboField.pure(),
  });

  ContractFormState.fromModel(Contract contract)
      : this(
          id: Name.dirty(contract.id!),
          contractNo: Name.dirty(contract.contractNo!),
          dpc: Name.dirty(contract.dpc!),
          lastName: RequiredName.dirty(contract.lastName!),
          firstName: Name.dirty(contract.firstName!),
          middleName: Name.dirty(contract.middleName!),
          tariff: ComboField.dirty(contract.tariff!),
          category: Name.dirty(contract.category!.name),
          subcategory: Name.dirty(contract.subcategory!),
          consumptionType: Name.dirty(contract.consumptionType!.name),
          connectionAddress: Address.dirty(contract.connectionAddress!),
          billingAddress: Address.dirty(contract.billingAddress!),
          phone: Phone.dirty(contract.phone!),
          email: Email.dirty(contract.email!),
          volume: Number.dirty(contract.volume?.toDouble() ?? 0),
          agreedVolume: Number.dirty(contract.agreedVolume?.toDouble()),
          limit: Number.dirty(0),
          rate: Number.dirty(contract.rate?.toDouble() ?? 0),
          meterNo: Name.dirty(contract.meterNo),
          meterSize: Name.dirty(contract.meterSize),
          meterType: Name.dirty(contract.meterType),
          district: ComboField.dirty(contract.district!),
          zone: ComboField.dirty('${contract.district!}-${contract.zone!}'),
          subzone: ComboField.dirty(
              '${contract.district!}-${contract.zone!}-${contract.subzone!}'),
          round: ComboField.dirty(
              '${contract.district!}-${contract.zone!}-${contract.subzone!}-${contract.round!}'),
        );

  ContractFormState copyWith({
    Name? id,
    Name? contractNo,
    Name? dpc,
    RequiredName? lastName,
    Name? firstName,
    Name? middleName,
    Name? category,
    Name? subcategory,
    Name? consumptionType,
    ComboField? tariff,
    Address? connectionAddress,
    Address? billingAddress,
    Phone? phone,
    Email? email,
    Number? volume,
    Number? agreedVolume,
    Number? limit,
    Number? rate,
    Name? meterNo,
    Name? meterType,
    Name? meterSize,
    ComboField? district,
    ComboField? zone,
    ComboField? subzone,
    ComboField? round,
  }) =>
      ContractFormState(
        id: id ?? this.id,
        contractNo: contractNo ?? this.contractNo,
        dpc: dpc ?? this.dpc,
        lastName: lastName ?? this.lastName,
        firstName: firstName ?? this.firstName,
        middleName: middleName ?? this.middleName,
        tariff: tariff ?? this.tariff,
        category: category ?? this.category,
        subcategory: subcategory ?? this.subcategory,
        consumptionType: consumptionType ?? this.consumptionType,
        connectionAddress: connectionAddress ?? this.connectionAddress,
        billingAddress: billingAddress ?? this.billingAddress,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        volume: volume ?? this.volume,
        agreedVolume: agreedVolume ?? this.agreedVolume,
        limit: limit ?? this.limit,
        rate: rate ?? this.rate,
        meterNo: meterNo ?? this.meterNo,
        meterSize: meterSize ?? this.meterSize,
        meterType: meterType ?? this.meterType,
        district: district ?? this.district,
        zone: zone ?? this.zone,
        subzone: subzone ?? this.subzone,
        round: round ?? this.round,
      );

  Contract toModel() => Contract(
        id: id.value == null || id.value?.isEmpty == true ? null : id.value,
        contractNo:
            contractNo.value == null || contractNo.value?.isEmpty == true
                ? null
                : contractNo.value,
        dpc: dpc.value == null || dpc.value?.isEmpty == true ? null : dpc.value,
        lastName: lastName.value,
        middleName: middleName.value,
        firstName: firstName.value,
        phone: phone.value,
        email: email.value,
        tariff: tariff.value,
        subcategory: subcategory.value,
        volume: volume.value?.toInt(),
        rate: rate.value?.toInt(),
        category: Tariff.getFPCategory(category.value),
        metered: Contract.getFPMetered(consumptionType.value),
        billingAddress: billingAddress.value,
        connectionAddress: connectionAddress.value,
        consumptionType: Tariff.getFPConsumptionType(consumptionType.value),
        meterNo: meterNo.value,
        meterSize: meterSize.value,
        meterType: meterType.value,
        district: district.value,
        zone: zone.value.getAreaCode(AreaType.zone),
        subzone: subzone.value.getAreaCode(AreaType.subzone),
        round: round.value.getAreaCode(AreaType.round),
      );

  @override
  List<FormzInput> get inputs => [
        id,
        contractNo,
        dpc,
        lastName,
        firstName,
        middleName,
        tariff,
        category,
        consumptionType,
        connectionAddress,
        billingAddress,
        phone,
        email,
        subcategory,
        volume,
        agreedVolume,
        limit,
        rate,
        meterNo,
        meterSize,
        meterType,
        district,
        zone,
        subzone,
        round,
      ];

  @override
  List<Object?> get props => inputs;
}

enum NameValidationError { empty, invalid }

class RequiredName extends FormzInput<String, NameValidationError> {
  const RequiredName.pure([String value = '']) : super.pure(value);
  const RequiredName.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : NameValidationError.empty;
  }
}

enum AddressValidationError { empty, invalid }

class Address extends FormzInput<String, AddressValidationError> {
  const Address.pure([String value = '']) : super.pure(value);
  const Address.dirty([String value = '']) : super.dirty(value);

  @override
  AddressValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : AddressValidationError.empty;
  }
}

enum PhoneValidationError { empty, invalid }

class Phone extends FormzInput<String, PhoneValidationError> {
  const Phone.pure([String value = '']) : super.pure(value);
  const Phone.dirty([String value = '']) : super.dirty(value);

  @override
  PhoneValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : PhoneValidationError.empty;
  }
}

enum EmailValidationError { empty, invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure([String value = '']) : super.pure(value);
  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  EmailValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : EmailValidationError.empty;
  }
}

class Name extends FormzInput<String?, NameValidationError> {
  const Name.pure([String? value = '']) : super.pure(value);
  const Name.dirty([String? value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String? value) {}
}

enum ComboValidationError { empty, invalid }

class ComboField extends FormzInput<String, ComboValidationError> {
  const ComboField.pure([String value = '']) : super.pure(value);
  const ComboField.dirty([String value = '']) : super.dirty(value);

  @override
  ComboValidationError? validator(String? value) {
    return value != null || value != 'none' ? null : ComboValidationError.empty;
  }
}

enum NumberValidationError { empty, invalid }

class Number extends FormzInput<double?, NumberValidationError> {
  const Number.pure([double? value]) : super.pure(value);
  const Number.dirty([double? value]) : super.dirty(value);

  @override
  NumberValidationError? validator(double? value) {}
}

class RequiredNumber extends FormzInput<double, NumberValidationError> {
  const RequiredNumber.pure([double value = 0]) : super.pure(value);
  const RequiredNumber.dirty([double value = 0]) : super.dirty(value);

  @override
  NumberValidationError? validator(double? value) {
    return value != 0 ? null : NumberValidationError.empty;
  }
}
