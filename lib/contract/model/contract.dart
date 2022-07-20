import 'package:waterserver/area/models/area.dart';
import 'package:waterserver/tariff/model/tariff.dart';

enum ConsumptionType { metered, flat, bulkmeter }

enum ConnectionStatus { connected, disconnected, disqualified }

class Contract {
  final String id;
  final String contractNo;
  final String? dpc;
  final String? lastName;
  final String? firstName;
  final String? middleName;
  final String? tariff;
  final Category category;
  final bool metered;
  final String? meterNo;
  final int? volume;
  final int? agreedVolume;
  final DateTime? initialReadingDate;
  final DateTime? lastBillingDate;
  final String billingAddress;
  final String connectionAddress;
  final ConnectionStatus connectionStatus;
  final Area? area;
  final ConsumptionType consumptionType;

  late final String name;

  Contract({
    required this.id,
    required this.contractNo,
    this.dpc,
    this.lastName,
    this.firstName,
    this.middleName,
    this.tariff,
    required this.category,
    required this.metered,
    this.meterNo,
    this.agreedVolume,
    this.volume,
    this.initialReadingDate,
    this.lastBillingDate,
    required this.billingAddress,
    required this.connectionAddress,
    required this.connectionStatus,
    this.area,
    required this.consumptionType,
  }) {
    _initCasts();
  }

  void _initCasts() {
    name = '$lastName $firstName $middleName';
  }

  Contract.fromFPJson(Map<String, dynamic> json)
      : this(
          id: json['id'].toString(),
          contractNo: json['contract_no'].toString().trim(),
          dpc: json['dpc'],
          lastName: json['surname'].toString().trim(),
          firstName: json['firstname'].toString().trim(),
          middleName: json['middlename'].toString().trim(),
          tariff: json['tariff'],
          meterNo: json['meter1_no'],
          agreedVolume: json['agreed_volume'],
          volume: json['volume1'],
          initialReadingDate: null,
          lastBillingDate: null,
          category: getFPCategory(json['middlename']),
          metered: getFPMetered(json['metered']),
          billingAddress: json['address_billing'].toString().trim(),
          connectionAddress: json['address_connection'].toString().trim(),
          area: Area(
            code:
                "${json['district']}-${json['zone']}-${json['subzone']}-${json['rounds']}",
          ),
          consumptionType: getFPConsumptionType(json['consumption_type']),
          connectionStatus: getFPConnectionStatus(json['connection_status']),
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
        'category': category.name,
        'metered': metered,
        'volume': volume,
        'meterNo': meterNo,
        'agreedVolume': agreedVolume,
        'initialReadingDate': initialReadingDate,
        'lastBillingDate': lastBillingDate,
        'billingAddress': billingAddress,
        'connectionAddress': connectionAddress,
        'connectionStatus': connectionStatus,
        'consumptionType': consumptionType,
      };

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

  static ConsumptionType getFPConsumptionType(String consumptionType) {
    final trimConsumptionType = consumptionType.trim();
    switch (trimConsumptionType) {
      case 'METERED':
        return ConsumptionType.metered;
      default:
        return ConsumptionType.flat;
    }
  }

  static bool getFPMetered(String metered) {
    final trimMetered = metered.trim();
    switch (trimMetered) {
      case 'Y':
        return true;
      case 'N':
        return false;
      default:
        return false;
    }
  }

  static Category getFPCategory(String category) {
    final trimCategory = category.trim();
    switch (trimCategory) {
      case 'DOMESTIC':
        return Category.domestic;
      case 'COMMERCIAL':
        return Category.commercial;
      case 'INSTITUTION':
        return Category.institution;
      case 'BOREHOLE':
        return Category.borehole;
      case 'INDUSTRIAL ':
        return Category.industrial;
      case 'RAWWATER':
        return Category.rawwater;
      case 'TANKER':
        return Category.tanker;
      default:
        return Category.other;
    }
  }
}
