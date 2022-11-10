import 'package:waterserver/utilities/generics/string_to_datetime.dart';

class MeterReading {
  final String? id;
  final String? contractNo;
  final String? contractId;
  final String? dpc;
  final String? lastName;
  final String? firstName;
  final String? meterNo;
  final String? meter2No;
  final int? previousReading;
  final int? previousReading2;
  final int? presentReading;
  final int? presentReading2;
  final int? estimatedVolume;
  final DateTime? readingDate;
  final DateTime? billingPeriod;
  final String? tariff;
  final String? district;
  final String? zone;

  late final String fullName;

  MeterReading({
    this.id,
    this.contractNo,
    this.contractId,
    this.dpc,
    this.firstName,
    this.lastName,
    this.meterNo,
    this.meter2No,
    this.previousReading,
    this.previousReading2,
    this.presentReading,
    this.presentReading2,
    this.estimatedVolume,
    this.readingDate,
    this.billingPeriod,
    this.tariff,
    this.district,
    this.zone,
  }) {
    _initCasts();
  }

  void _initCasts() {
    fullName = '$lastName $firstName'.trim();
  }

  static Map<String, List<String>> casts = {
    'fullName': ['lastName', 'firstName']
  };

  static String? getFPEquivalent(String field) {
    return {
      'id': 'id',
      'contractNo': 'contract_no',
      'dpc': 'dpc',
      'contractId': 'Contractid',
      'firstName': 'firstname',
      'lastName': 'surname',
      'meterNo': 'meter1_no',
      'meter2No': 'meter2_no',
      'previousReading': 'meter1_prev',
      'previousReading2': 'meter2_prev',
      'presentReading': 'meter1_pres',
      'presentReading2': 'meter2_pres',
      'estimatedVolume': 'estimatedvolume',
      'readingDate': 'readdate',
      'billingPeriod': 'billing_period',
      'tariff': 'tariff',
      'district': 'district',
      'zone': 'zone',
    }[field];
  }

  MeterReading.fromFPMap(Map<String, dynamic> map)
      : this(
          id: map[getFPEquivalent('id')].toString(),
          contractNo: map[getFPEquivalent('contractNo')].toString(),
          contractId: map[getFPEquivalent('contractId')].toString(),
          dpc: map[getFPEquivalent('dpc')].toString(),
          firstName: map[getFPEquivalent('firstName')].toString(),
          lastName: map[getFPEquivalent('lastName')].toString(),
          meterNo: map[getFPEquivalent('meterNo')].toString(),
          meter2No: map[getFPEquivalent('meter2No')].toString(),
          presentReading:
              int.tryParse(map[getFPEquivalent('presentReading')].toString()),
          presentReading2:
              int.tryParse(map[getFPEquivalent('presentReading2')].toString()),
          previousReading:
              int.tryParse(map[getFPEquivalent('previousReading')].toString()),
          previousReading2:
              int.tryParse(map[getFPEquivalent('previousReading2')].toString()),
          estimatedVolume:
              int.tryParse(map[getFPEquivalent('estimatedVolume')].toString()),
          readingDate:
              map[getFPEquivalent('readingDate')].toString().toDatetime(),
          tariff: map[getFPEquivalent('tariff')].toString(),
          district: map[getFPEquivalent('district')].toString(),
          zone: map[getFPEquivalent('zone')].toString(),
        );

  // Map<String, dynamic> toMap() {

  // }

  static const List<String> defaultTableColumns = [];
}
