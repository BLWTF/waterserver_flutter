import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:waterserver/payment/payment.dart';
import 'package:waterserver/utilities/forms.dart';

class PaymentFormState extends Equatable with FormzMixin {
  final Name id;
  final Datetime dateTime;
  final Datetime billPeriod;
  final RequiredNumber amount;
  final RequiredName dpc;
  final RequiredName contractNo;
  final RequiredName fullName;
  final RequiredName contractId;
  final Name rcbNo;
  final Name cashpoint;
  final Name tariff;
  final Name district;
  final Name zone;
  final Name receiptNo;

  PaymentFormState({
    this.id = const Name.pure(),
    this.dateTime = const Datetime.pure(),
    this.billPeriod = const Datetime.pure(),
    this.amount = const RequiredNumber.pure(),
    this.dpc = const RequiredName.pure(),
    this.contractNo = const RequiredName.pure(),
    this.fullName = const RequiredName.pure(),
    this.contractId = const RequiredName.pure(),
    this.rcbNo = const Name.pure(),
    this.cashpoint = const Name.pure(),
    this.tariff = const Name.pure(),
    this.district = const Name.pure(),
    this.zone = const Name.pure(),
    this.receiptNo = const Name.pure(),
  });

  PaymentFormState.fromModel(Payment payment)
      : this(
          id: Name.dirty(payment.id),
          dateTime: Datetime.dirty(payment.dateTime),
          billPeriod: Datetime.dirty(payment.billPeriod),
          amount: RequiredNumber.dirty(payment.amount!.toString()),
          dpc: RequiredName.dirty(payment.dpc!),
          contractNo: RequiredName.dirty(payment.contractNo!),
          fullName: RequiredName.dirty(payment.fullName!),
          contractId: RequiredName.dirty(payment.contractId!),
          rcbNo: Name.dirty(payment.rcbNo),
          cashpoint: Name.dirty(payment.cashpoint),
          tariff: Name.dirty(payment.tariff),
          district: Name.dirty(payment.district),
          zone: Name.dirty(payment.zone),
          receiptNo: Name.dirty(payment.receiptNo),
        );

  Payment toModel() => Payment(
        id: id.value == null || id.value?.isEmpty == true ? null : id.value,
        contractNo: contractNo.value,
        dpc: dpc.value,
        fullName: fullName.value,
        contractId: contractId.value,
        dateTime: dateTime.value,
        billPeriod: billPeriod.value,
        amount: amount.value == null ? null : int.tryParse(amount.value!),
        rcbNo: rcbNo.value,
        cashpoint: cashpoint.value,
        tariff: tariff.value,
        district: district.value,
        zone: zone.value,
        receiptNo: receiptNo.value,
      );

  PaymentFormState copyWith({
    Name? id,
    Datetime? dateTime,
    Datetime? entryDate,
    Datetime? billPeriod,
    RequiredNumber? amount,
    RequiredName? dpc,
    RequiredName? contractNo,
    RequiredName? fullName,
    RequiredName? contractId,
    Name? rcbNo,
    Name? cashpoint,
    Name? tariff,
    Name? district,
    Name? zone,
    Name? receiptNo,
  }) =>
      PaymentFormState(
        id: id ?? this.id,
        dateTime: dateTime ?? this.dateTime,
        billPeriod: billPeriod ?? this.billPeriod,
        amount: amount ?? this.amount,
        contractNo: contractNo ?? this.contractNo,
        contractId: contractId ?? this.contractId,
        dpc: dpc ?? this.dpc,
        fullName: fullName ?? this.fullName,
        rcbNo: rcbNo ?? this.rcbNo,
        cashpoint: cashpoint ?? this.cashpoint,
        tariff: tariff ?? this.tariff,
        district: district ?? this.district,
        zone: zone ?? this.zone,
        receiptNo: receiptNo ?? this.receiptNo,
      );

  @override
  List<FormzInput> get inputs => [
        id,
        dateTime,
        billPeriod,
        amount,
        dpc,
        contractNo,
        fullName,
        contractId,
        rcbNo,
        cashpoint,
        tariff,
        district,
        zone,
        receiptNo,
      ];

  @override
  List<Object?> get props => inputs;
}
