import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/tariff/tariff.dart';
import 'package:waterserver/utilities/generics/last_day_month.dart';

class Bill {
  final String? id;
  final String? contractNo;
  final String? dpc;
  final String? lastName;
  final String? firstName;
  final String? middleName;
  final String? tariff;
  final Category? category;
  final String? subcategory;
  final bool? metered;
  final String? meterNo;
  final String? meterSize;
  final int? volume;
  final int? agreedVolume;
  final int? rate;
  final String? billingAddress;
  final String? connectionAddress;
  final String? phone;
  final String? email;
  final String? district;
  final String? zone;
  final String? subzone;
  final String? round;
  final String? folio;
  final ConsumptionType? consumptionType;

  late final String name;

  final double? openingBalance;
  final double? closingBalance;
  final String? billingPeriod;
  final String? billingYear;
  final int? currentConsumption;
  final int? currentCharges;
  final int? totalCharges;
  final String? contractId;

  late final DateTime? monthStart;
  late final DateTime? monthEnd;

  Bill({
    this.id,
    this.contractNo,
    this.dpc,
    this.lastName,
    this.firstName,
    this.middleName,
    this.tariff,
    this.category,
    this.subcategory,
    this.metered,
    this.meterNo,
    this.meterSize,
    this.volume,
    this.agreedVolume,
    this.rate,
    this.billingAddress,
    this.connectionAddress,
    this.phone,
    this.email,
    this.consumptionType,
    this.district,
    this.zone,
    this.subzone,
    this.round,
    this.folio,
    this.openingBalance = 0,
    this.closingBalance = 0,
    this.billingPeriod,
    this.billingYear,
    this.currentConsumption = 0,
    this.currentCharges = 0,
    this.totalCharges = 0,
    this.contractId,
  }) {
    _initCasts();
  }

  void _initCasts() {
    name = '$lastName $firstName $middleName'.trim();

    if (billingPeriod != null && billingYear != null) {
      final currentDateTime =
          DateTime(int.parse(billingYear!), int.parse(billingPeriod!));

      monthStart = DateTime(currentDateTime.year, currentDateTime.month, 1);
      monthEnd = DateTime(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.lastDayOfMonth(),
      );
    } else {
      monthStart = null;
      monthEnd = null;
    }
  }

  static const Map<String, List<String>> casts = {
    'name': ['lastName', 'firstName', 'middleName'],
    'monthStart': ['billingPeriod', 'billingYear'],
    'monthEnd': ['billingPeriod', 'billingYear'],
  };

  static String? getFPEquivalent(String field) {
    return {
      'id': 'billid',
      'contractNo': 'contract_no',
      'dpc': 'dpc',
      'lastName': 'surname',
      'firstName': 'firstname',
      'middleName': 'middlename',
      'fullName': 'fullname',
      'tariff': 'tariff',
      'category': 'category',
      'subcategory': 's_category',
      'meterNo': 'meter1_no',
      'meterSize': 'size1',
      'agreedVolume': 'agreedvolume',
      'volume': 'volume1',
      'limit': 'limit1',
      'rate': 'rate1',
      'consumptionType': 'consumption_type',
      'metered': 'metered',
      'billingAddress': 'address_billing',
      'connectionAddress': 'address_connection',
      'phone': 'telephone',
      'email': 'email',
      'district': 'district',
      'zone': 'zone',
      'subzone': 'subzone',
      'round': 'rounds',
      'folio': 'folio',
      'openingBalance': 'openingbalance',
      'closingBalance': 'closingbalance',
      'monthStart': 'month_start',
      'monthEnd': 'month_end',
      'billingPeriod': 'billing_period',
      'billingYear': 'billing_year',
      'currentConsumption': 'currentconsumption',
      'currentCharges': 'currentcharges',
      'totalCharges': 'totalcharges',
      'contractId': 'contractid',
    }[field];
  }

  static const List<String> defaultTableColumns = [
    'id',
    'contractNo',
    'name',
    'dpc',
    'openingBalance',
    'closingBalance',
    'category',
    'tariff',
    'monthEnd',
  ];

  Bill.fromFPMap(Map<String, dynamic> map)
      : this(
          id: map[getFPEquivalent('id')].toString(),
          contractNo: map[getFPEquivalent('contractNo')].toString().trim(),
          dpc: map[getFPEquivalent('dpc')],
          lastName: map[getFPEquivalent('lastName')].toString().trim(),
          firstName: map[getFPEquivalent('firstName')].toString().trim(),
          middleName: map[getFPEquivalent('middleName')].toString().trim(),
          tariff: map[getFPEquivalent('tariff')],
          district: map[getFPEquivalent('district')],
          zone: map[getFPEquivalent('zone')],
          subzone: map[getFPEquivalent('subzone')],
          round: map[getFPEquivalent('round')],
          folio: map[getFPEquivalent('folio')],
          meterNo: map[getFPEquivalent('meterNo')],
          meterSize: map[getFPEquivalent('meterSize')],
          volume: map[getFPEquivalent('volume')],
          agreedVolume: map[getFPEquivalent('agreedVolume')],
          rate: map[getFPEquivalent('rate')] != null
              ? double.parse(map[getFPEquivalent('rate')]).toInt()
              : null,
          category: map['category'] != null
              ? Tariff.getFPCategory(map['category'])
              : null,
          subcategory: map[getFPEquivalent('subcategory')],
          metered: Contract.getFPMetered(map[getFPEquivalent('metered')]),
          billingAddress:
              map[getFPEquivalent('billingAddress')].toString().trim(),
          connectionAddress:
              map[getFPEquivalent('connectionAddress')].toString().trim(),
          phone: map[getFPEquivalent('phone')].toString().trim(),
          email: map[getFPEquivalent('email')].toString().trim(),
          consumptionType: map[getFPEquivalent('consumption_type')] != null
              ? Tariff.getFPConsumptionType(
                  map[getFPEquivalent('consumption_type')])
              : null,
          openingBalance: double.parse(map[getFPEquivalent('openingBalance')]),
          closingBalance: double.parse(map[getFPEquivalent('closingBalance')]),
          billingPeriod: map[getFPEquivalent('billingPeriod')].toString(),
          billingYear: map[getFPEquivalent('billingYear')].toString(),
          currentConsumption: map[getFPEquivalent('currentConsumption')],
          currentCharges: map[getFPEquivalent('currentCharges')] != null
              ? double.parse(map[getFPEquivalent('currentCharges')]).toInt()
              : null,
          totalCharges: map[getFPEquivalent('totalCharges')] != null
              ? double.parse(map[getFPEquivalent('totalCharges')]).toInt()
              : null,
          contractId: map[getFPEquivalent('contractId')].toString(),
        );

  Bill.fromContract(
    Contract contract, {
    double? openingBalance,
    double? closingBalance,
    String? billingPeriod,
    String? billingYear,
    int? currentConsumption,
    int? currentCharges,
    int? totalCharges,
  }) : this(
          contractNo: contract.contractNo,
          dpc: contract.dpc,
          lastName: contract.lastName,
          firstName: contract.firstName,
          middleName: contract.middleName,
          tariff: contract.tariff,
          category: contract.category,
          subcategory: contract.subcategory,
          meterNo: contract.meterNo,
          meterSize: contract.meterSize,
          volume: contract.volume,
          agreedVolume: contract.agreedVolume,
          rate: contract.rate,
          consumptionType: contract.consumptionType,
          metered: contract.metered,
          billingAddress: contract.billingAddress,
          connectionAddress: contract.connectionAddress,
          phone: contract.phone,
          email: contract.email,
          district: contract.district,
          zone: contract.zone,
          subzone: contract.subzone,
          round: contract.round,
          folio: contract.folio,
          openingBalance: openingBalance,
          closingBalance: closingBalance,
          billingPeriod: billingPeriod,
          billingYear: billingYear,
          currentConsumption: currentConsumption,
          currentCharges: currentCharges,
          totalCharges: totalCharges,
          contractId: contract.id,
        );

  Map<String, dynamic> toMap() => {
        'id': id,
        'contractNo': contractNo,
        'name': name,
        'dpc': dpc,
        'lastName': lastName,
        'firstName': firstName,
        'middleName': middleName,
        'tariff': tariff,
        'category': category?.name,
        'subcategory': subcategory,
        'metered': metered,
        'district': district,
        'zone': zone,
        'subzone': subzone,
        'round': round,
        'folio': folio,
        'volume': volume,
        'agreedVolume': agreedVolume,
        'rate': rate,
        'meterNo': meterNo,
        'meterSize': meterSize,
        'billingAddress': billingAddress,
        'connectionAddress': connectionAddress,
        'phone': phone,
        'email': email,
        'consumptionType': consumptionType,
        'openingBalance': openingBalance,
        'closingBalance': closingBalance,
        'billingPeriod': billingPeriod,
        'billingYear': billingYear,
        'monthStart': monthStart,
        'monthEnd': monthEnd,
        'currentConsumption': currentConsumption,
        'currentCharges': currentCharges,
        'totalCharges': totalCharges,
        'contractId': contractId,
      };

  Map<String, dynamic> toFPMap([Map<String, dynamic>? newMap]) {
    final map = toMap()..removeWhere((key, value) => casts.containsKey(key));

    final fpMapEnd = {
      getFPEquivalent('monthStart')!: monthStart,
      getFPEquivalent('monthEnd')!: monthEnd,
    };

    final fpMapStart = Map.fromEntries(map.entries.map((e) {
      final key = e.key;
      late final dynamic value;

      if (newMap != null && newMap.containsKey(key)) {
        value = newMap[key];
      } else {
        switch (key) {
          case 'consumptionType':
            value = Tariff.getFPConsumptionTypeReverse(consumptionType);
            break;
          case 'metered':
            value = Contract.getFPMeteredReverse(metered);
            break;
          default:
            value = e.value;
        }
      }

      return MapEntry(getFPEquivalent(key)!, value);
    }));

    final fpMap = fpMapStart..addAll(fpMapEnd);
    return fpMap;
  }
}
