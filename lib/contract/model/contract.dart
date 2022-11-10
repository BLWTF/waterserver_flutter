import 'package:waterserver/area/area.dart';
import 'package:waterserver/meter/meter.dart';
import 'package:waterserver/tariff/tariff.dart';
import 'package:waterserver/utilities/generics/cap_first.dart';

class Contract {
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
  final String? meter2No;
  final String? meterSize;
  final String? meter2Size;
  final String? meterType;
  final int? volume;
  final int? rate;
  final int? agreedVolume;
  final DateTime? initialReadingDate;
  final DateTime? lastBillingDate;
  final String? billingAddress;
  final String? connectionAddress;
  final String? phone;
  final String? email;
  final String? district;
  final String? zone;
  final String? subzone;
  final String? round;
  final String? folio;
  final ConnectionStatus? connectionStatus;
  final ConsumptionType? consumptionType;

  late final String name;
  late final Meter? meter;
  late final Meter? meter2;
  late final Area? area;

  Contract({
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
    this.meter2No,
    this.meterSize,
    this.meter2Size,
    this.meterType,
    this.agreedVolume,
    this.volume,
    this.rate,
    this.initialReadingDate,
    this.lastBillingDate,
    this.billingAddress,
    this.connectionAddress,
    this.phone,
    this.email,
    this.connectionStatus = ConnectionStatus.disconnected,
    this.consumptionType,
    this.district,
    this.zone,
    this.subzone,
    this.round,
    this.folio,
  }) {
    _initCasts();
  }

  static const List<String> defaultTableColumns = [
    'id',
    'contractNo',
    'name',
    'dpc',
    'connectionAddress',
    'category',
    'tariff',
    'area',
  ];

  void _initCasts() {
    name = '$lastName $firstName $middleName'.trim();

    if (meterNo != null) {
      meter = Meter(
        meterNo: meterNo!,
        meterSize: meterSize,
        meterType: meterType,
      );
    } else {
      meter = null;
    }

    if (meter2No != null) {
      meter = Meter(
        meterNo: meter2No!,
        meterSize: meter2Size,
        meterType: meterType,
      );
    } else {
      meter2 = null;
    }

    if (district != null) {
      area = Area(
        district: district!,
        zone: zone,
        subzone: subzone,
        round: round,
      );
    } else {
      area = null;
    }
  }

  static Map<String, List<String>> casts = {
    'name': ['lastName', 'firstName', 'middleName'],
    'meter': ['meterNo', 'meterSize', 'meterType'],
    'area': ['district', 'zone', 'subzone', 'round'],
  };

  static String? getFPEquivalent(String field) {
    return {
      'id': 'id',
      'contractNo': 'contract_no',
      'dpc': 'dpc',
      'lastName': 'surname',
      'firstName': 'firstname',
      'middleName': 'middlename',
      'tariff': 'tariff',
      'category': 'category',
      'subcategory': 's_category',
      'meterNo': 'meter1_no',
      'meter2No': 'meter2_no',
      'meterType': 'meter_type',
      'meter2Type': 'meter2_type',
      'meterSize': 'size1',
      'meter2Size': 'meter2_size',
      'agreedVolume': 'agreed_volume',
      'volume': 'volume1',
      'limit': 'limit1',
      'rate': 'rate1',
      'initialReadingDate': 'initreadingdate',
      'lastBillingDate': 'lastbillingdate',
      'consumptionType': 'consumption_type',
      'connectionStatus': 'connection_status',
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
    }[field];
  }

  Contract.fromFPMap(Map<String, dynamic> map)
      : this(
          id: map[getFPEquivalent('id')].toString(),
          contractNo: map[getFPEquivalent('contractNo')].toString().trim(),
          dpc: map[getFPEquivalent('dpc')],
          lastName: map[getFPEquivalent('lastName')].toString().trim(),
          firstName: map[getFPEquivalent('firstName')]?.toString().trim(),
          middleName: map[getFPEquivalent('middleName')]?.toString().trim(),
          tariff: map[getFPEquivalent('tariff')]?.toString().trim(),
          district: map[getFPEquivalent('district')],
          zone: map[getFPEquivalent('zone')],
          subzone: map[getFPEquivalent('subzone')],
          round: map[getFPEquivalent('round')],
          folio: map[getFPEquivalent('folio')],
          meterNo: map[getFPEquivalent('meterNo')],
          meter2No: map[getFPEquivalent('meter2No')],
          meterSize: map[getFPEquivalent('meterSize')],
          meter2Size: map[getFPEquivalent('meter2Size')],
          meterType: map[getFPEquivalent('meterType')],
          agreedVolume: map[getFPEquivalent('agreedVolume')],
          volume: map[getFPEquivalent('volume')],
          rate: map[getFPEquivalent('rate')]?.toInt(),
          initialReadingDate: null,
          lastBillingDate: null,
          category: map['category'] != null
              ? Tariff.getFPCategory(map['category'])
              : null,
          subcategory: map[getFPEquivalent('subcategory')],
          metered: getFPMetered(map[getFPEquivalent('metered')]),
          billingAddress:
              map[getFPEquivalent('billingAddress')].toString().trim(),
          connectionAddress:
              map[getFPEquivalent('connectionAddress')].toString().trim(),
          phone: map[getFPEquivalent('phone')].toString().trim(),
          email: map[getFPEquivalent('email')].toString().trim(),
          consumptionType: map[getFPEquivalent('consumptionType')] != null
              ? Tariff.getFPConsumptionType(
                  map[getFPEquivalent('consumptionType')])
              : null,
          connectionStatus: map[getFPEquivalent('connection_status')] != null
              ? getFPConnectionStatus(map['connection_status'])
              : null,
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
        'area': area,
        'district': district,
        'zone': zone,
        'subzone': subzone,
        'round': round,
        'folio': folio,
        'volume': volume,
        'rate': rate,
        'meter': meter,
        'meter2': meter2,
        'meterNo': meterNo,
        'meter2No': meter2No,
        'meterSize': meterSize,
        'meter2Size': meter2Size,
        'meterType': meterType,
        'agreedVolume': agreedVolume,
        'initialReadingDate': initialReadingDate,
        'lastBillingDate': lastBillingDate,
        'billingAddress': billingAddress,
        'connectionAddress': connectionAddress,
        'phone': phone,
        'email': email,
        'connectionStatus': connectionStatus,
        'consumptionType': consumptionType,
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
          case 'consumptionType':
            value = Tariff.getFPConsumptionTypeReverse(consumptionType);
            break;
          case 'connectionStatus':
            value = getFPConnectionStatusReverse(connectionStatus);
            break;
          case 'metered':
            value = getFPMeteredReverse(metered);
            break;
          case 'lastName':
          case 'firstName':
          case 'middleName':
            value = e.value.toString().trim().capFirst();
            break;
          default:
            value = e.value;
        }
      }

      return MapEntry(getFPEquivalent(key)!, value);
    }));
    return fpMap;
  }

  static ConnectionStatus getFPConnectionStatus(String connectionStatus) {
    final trimConnectionStatus = connectionStatus.trim();
    switch (trimConnectionStatus) {
      case 'CONNECTED':
        return ConnectionStatus.connected;
      case 'DISQUALIFIED':
        return ConnectionStatus.disqualified;
      default:
        return ConnectionStatus.disconnected;
    }
  }

  static String? getFPConnectionStatusReverse(
      ConnectionStatus? connectionStatus) {
    switch (connectionStatus) {
      case ConnectionStatus.connected:
        return 'CONNECTED';
      case ConnectionStatus.disconnected:
        return 'DISCONNECTED';
      case ConnectionStatus.disqualified:
        return 'DISQUALIFIED';
      default:
        return null;
    }
  }

  static bool getFPMetered(String? metered) {
    if (metered == null) {
      return false;
    }
    final trimMetered = metered.trim();
    switch (trimMetered) {
      case 'Y':
        return true;
      case 'METERED': // in case consumption type string is given
        return true;
      case 'N':
        return false;
      default:
        return false;
    }
  }

  static String? getFPMeteredReverse(bool? metered) {
    switch (metered) {
      case true:
        return 'Y';
      default:
        return 'N';
    }
  }
}
