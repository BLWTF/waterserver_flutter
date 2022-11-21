import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/utilities/generics/cap_first.dart';
import 'package:waterserver/utilities/generics/datetime_to_string.dart';
import 'package:waterserver/utilities/generics/string_to_datetime.dart';

class MeterReading {
  final String? id;
  final String? contractNo;
  final String? contractId;
  final String? dpc;
  final String? lastName;
  final String? firstName;
  final String? address;
  final String? meterNo;
  final String? meter2No;
  final int? previousReading;
  final int? previousReading2;
  final int? presentReading;
  final int? presentReading2;
  final int? estimatedVolume;
  final DateTime? readingDate;
  final int? billingMonth;
  final int? billingYear;
  final String? tariff;
  final String? district;
  final String? zone;

  late final String name;
  late final DateTime? billingPeriod;

  MeterReading({
    this.id,
    this.contractNo,
    this.contractId,
    this.dpc,
    this.firstName,
    this.lastName,
    this.meterNo,
    this.meter2No,
    this.address,
    this.previousReading,
    this.previousReading2,
    this.presentReading,
    this.presentReading2,
    this.estimatedVolume,
    this.readingDate,
    this.billingMonth,
    this.billingYear,
    this.tariff,
    this.district,
    this.zone,
  }) {
    _initCasts();
  }

  void _initCasts() {
    name = '${lastName ?? ""} ${firstName ?? ""}'.trim();
    billingPeriod = billingMonth != null && billingYear != null
        ? DateTime(billingYear!, billingMonth!)
        : null;
  }

  static Map<String, List<String>> casts = {
    'name': ['lastName', 'firstName'],
    'billingPeriod': ['billingMonth', 'billingYear'],
  };

  static String? getFPEquivalent(String field) {
    return {
      'id': 'id',
      'contractNo': 'contract_no',
      'dpc': 'dpc',
      'contractId': 'Contractid',
      'firstName': 'firstname',
      'lastName': 'surname',
      'address': 'address',
      'meterNo': 'meter1_no',
      'meter2No': 'meter2_no',
      'previousReading': 'meter1_prev',
      'previousReading2': 'meter2_prev',
      'presentReading': 'meter1_pres',
      'presentReading2': 'meter2_pres',
      'estimatedVolume': 'estimatedvolume',
      'readingDate': 'readdate',
      'billingMonth': 'billing_period',
      'billingYear': 'billing_year',
      'tariff': 'tariff',
      'district': 'district',
      'zone': 'zone',
    }[field];
  }

  MeterReading.fromFPMap(Map<String, dynamic> map)
      : this(
          id: map[getFPEquivalent('id')].toString(),
          contractNo: map[getFPEquivalent('contractNo')].toString().trim(),
          contractId: map[getFPEquivalent('contractId')].toString(),
          dpc: map[getFPEquivalent('dpc')].toString(),
          firstName: map[getFPEquivalent('firstName')].toString().trim(),
          lastName: map[getFPEquivalent('lastName')].toString().trim(),
          address: map[getFPEquivalent('address')].toString(),
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
          billingMonth:
              int.tryParse(map[getFPEquivalent('billingMonth')].toString()),
          billingYear:
              int.tryParse(map[getFPEquivalent('billingYear')].toString()),
          tariff: map[getFPEquivalent('tariff')].toString(),
          district: map[getFPEquivalent('district')].toString(),
          zone: map[getFPEquivalent('zone')].toString(),
        );

  MeterReading.fromContract(Contract contract)
      : this(
          contractId: contract.id,
          contractNo: contract.contractNo,
          dpc: contract.dpc,
          firstName: contract.firstName,
          lastName: contract.lastName,
          meterNo: contract.meterNo,
          tariff: contract.tariff,
          district: contract.district,
          zone: contract.zone,
          address: contract.connectionAddress,
        );

  Map<String, dynamic> toMap() => {
        'id': id,
        'contractNo': contractNo,
        'contractId': contractId,
        'dpc': dpc,
        'name': name,
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'meterNo': meterNo,
        'meter2No': meter2No,
        'previousReading': previousReading,
        'previousReading2': previousReading2,
        'presentReading': presentReading,
        'presentReading2': presentReading2,
        'estimatedVolume': estimatedVolume,
        'readingDate': readingDate,
        'billingMonth': billingMonth,
        'billingYear': billingYear,
        'billingPeriod': billingPeriod,
        'tariff': tariff,
        'district': district,
        'zone': zone,
      };

  Map<String, dynamic> toFPMap([Map<String, dynamic>? replaceMap]) {
    final map = toMap()..removeWhere((key, value) => casts.containsKey(key));
    final fpMap = Map.fromEntries(map.entries.map((e) {
      final key = e.key;
      late final dynamic value;

      if (replaceMap != null && replaceMap.containsKey(key)) {
        value = replaceMap[key];
      } else {
        switch (key) {
          case 'lastName':
          case 'firstName':
            value = e.value.toString().trim().capFirst();
            break;
          case 'readingDate':
            value =
                e.value == null ? null : (e.value as DateTime?)!.toDateString();
            break;
          case 'billingPeriod':
            value = billingPeriod?.month.toString();
            break;
          case 'billingYear':
            value = billingPeriod?.year.toString();
            break;
          default:
            value = e.value;
        }
      }

      return MapEntry(getFPEquivalent(key)!, value);
    }));
    return fpMap;
  }

  static const List<String> defaultTableColumns = [
    'id',
    'contractNo',
    'name',
    'previousReading',
    'presentReading',
    'readingDate',
    'district',
  ];
}
