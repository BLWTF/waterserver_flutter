import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:waterserver/area/area.dart';
import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/tariff/tariff.dart';
import 'package:waterserver/utilities/forms.dart';

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
  final Name folio;

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
    this.folio = const Name.pure(),
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
          folio: Name.dirty(contract.folio),
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
    Name? folio,
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
        folio: folio ?? this.folio,
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
        folio: folio.value,
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
        folio,
      ];

  @override
  List<Object?> get props => inputs;
}
