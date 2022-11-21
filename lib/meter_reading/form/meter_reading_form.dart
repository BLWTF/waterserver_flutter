import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:waterserver/meter_reading/meter_reading.dart';
import 'package:waterserver/utilities/forms.dart';

class MeterReadingFormState extends Equatable with FormzMixin {
  final Name id;
  final RequiredName contractNoDisplay;
  final RequiredName contractNo;
  final RequiredName lastName;
  final Name firstName;
  final RequiredName dpc;
  final Datetime readingDate;
  final Datetime billingPeriod;
  final Name previousReading;
  final RequiredNumber presentReading;

  MeterReadingFormState({
    this.id = const Name.pure(),
    this.contractNoDisplay = const RequiredName.pure(),
    this.contractNo = const RequiredName.pure(),
    this.lastName = const RequiredName.pure(),
    this.firstName = const Name.pure(),
    this.dpc = const RequiredName.pure(),
    this.readingDate = const Datetime.pure(),
    this.billingPeriod = const Datetime.pure(),
    this.previousReading = const Name.pure(),
    this.presentReading = const RequiredNumber.pure(),
  });

  MeterReadingFormState.fromModel(MeterReading reading)
      : this(
          id: Name.dirty(reading.id),
          contractNoDisplay: RequiredName.dirty(reading.contractNo!),
          contractNo: RequiredName.dirty(reading.contractNo!),
          firstName: Name.dirty(reading.firstName!),
          lastName: RequiredName.dirty(reading.lastName!),
          dpc: RequiredName.dirty(reading.dpc!),
          readingDate: Datetime.dirty(reading.readingDate),
          billingPeriod: Datetime.dirty(reading.billingPeriod),
          previousReading: Name.dirty(reading.previousReading?.toString()),
          presentReading:
              RequiredNumber.dirty(reading.presentReading?.toString()),
        );

  MeterReadingFormState copyWith({
    Name? id,
    RequiredName? contractNoDisplay,
    RequiredName? contractNo,
    Name? firstName,
    RequiredName? lastName,
    RequiredName? dpc,
    Datetime? readingDate,
    Datetime? billingPeriod,
    Name? previousReading,
    RequiredNumber? presentReading,
  }) =>
      MeterReadingFormState(
        id: id ?? this.id,
        contractNoDisplay: contractNoDisplay ?? this.contractNoDisplay,
        contractNo: contractNo ?? this.contractNo,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        dpc: dpc ?? this.dpc,
        readingDate: readingDate ?? this.readingDate,
        billingPeriod: billingPeriod ?? this.billingPeriod,
        previousReading: previousReading ?? this.previousReading,
        presentReading: presentReading ?? this.presentReading,
      );

  MeterReading toModel() => MeterReading(
        id: id.value == null || id.value?.isEmpty == true ? null : id.value,
        contractNo: contractNo.value,
        dpc: dpc.value,
        firstName: firstName.value,
        lastName: lastName.value,
        readingDate: readingDate.value,
        billingMonth: billingPeriod.value?.month,
        billingYear: billingPeriod.value?.year,
        previousReading: int.tryParse(previousReading.value ?? ''),
        presentReading: int.tryParse(presentReading.value ?? ''),
      );

  @override
  List<FormzInput> get inputs => [
        id,
        contractNoDisplay,
        contractNo,
        dpc,
        lastName,
        firstName,
        previousReading,
        presentReading,
        billingPeriod,
      ];

  @override
  List<Object?> get props => inputs;
}
