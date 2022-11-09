import 'package:waterserver/utilities/generics/string_to_datetime.dart';
import 'package:waterserver/utilities/generics/datetime_to_string.dart';

class Payment {
  final String? id;
  final DateTime? dateTime;
  final DateTime? entryDate;
  final DateTime? billPeriod;
  final int? amount;
  final String? invoiceNo;
  final String? receiptNo;
  final String? contractId;
  final String? contractNo;
  final String? dpc;
  final String? fullName;
  final String? rcbNo;
  final String? cashpoint;
  final String? tariff;
  final String? district;
  final String? zone;
  final bool? approved;
  final bool? cancelled;

  Payment({
    this.id,
    this.dateTime,
    this.entryDate,
    this.billPeriod,
    this.amount,
    this.invoiceNo,
    this.receiptNo,
    this.contractId,
    this.contractNo,
    this.dpc,
    this.fullName,
    this.rcbNo,
    this.cashpoint,
    this.tariff,
    this.district,
    this.zone,
    this.approved,
    this.cancelled,
  });

  static String? getFPEquivalent(String field) {
    return {
      'id': 'id',
      'dateTime': 'Paymentdate',
      'billPeriod': 'billing_period',
      'entryDate': 'date_of_entry',
      'amount': 'amount',
      'invoiceNo': 'invoice_no',
      'receiptNo': 'receipt_no',
      'contractId': 'contractid',
      'contractNo': 'contract_no',
      'dpc': 'dpc',
      'fullName': 'fullname',
      'rcbNo': 'rcb_no',
      'cashpoint': 'cashpoint',
      'tariff': 'tariff',
      'district': 'district',
      'zone': 'zone',
      'approved': 'approved',
      'cancelled': 'cancelled',
    }[field];
  }

  static bool getFPStatus(String? status) {
    if (status == null) {
      return false;
    }
    final trimStatus = status.trim();
    switch (trimStatus) {
      case 'Y':
        return true;
      case 'N':
        return false;
      default:
        return false;
    }
  }

  String getFPStatusReversed(bool? status) {
    switch (status) {
      case true:
        return 'Y';
      case false:
        return 'N';
      default:
        return 'N';
    }
  }

  static const List<String> defaultTableColumns = [
    'id',
    'contractNo',
    'fullName',
    'dpc',
    'amount',
    'dateTime',
    'receiptNo',
    'tariff',
  ];

  static Map<String, List<String>> casts = {};

  Payment.fromFPMap(Map<String, dynamic> map)
      : this(
          id: map[getFPEquivalent('id')].toString(),
          dateTime: map[getFPEquivalent('dateTime')]?.toString().toDatetime(),
          entryDate: map[getFPEquivalent('entryDate')]?.toString().toDatetime(),
          amount:
              double.parse(map[getFPEquivalent('amount')].toString()).toInt(),
          invoiceNo: map[getFPEquivalent('invoiceNo')].toString(),
          receiptNo: map[getFPEquivalent('receiptNo')].toString(),
          contractId: map[getFPEquivalent('contractId')].toString(),
          contractNo: map[getFPEquivalent('contractNo')].toString(),
          dpc: map[getFPEquivalent('dpc')].toString(),
          fullName: map[getFPEquivalent('fullName')].toString(),
          rcbNo: map[getFPEquivalent('rcbNo')].toString(),
          cashpoint: map[getFPEquivalent('cashpoint')].toString(),
          tariff: map[getFPEquivalent('tariff')].toString(),
          district: map[getFPEquivalent('district')].toString(),
          zone: map[getFPEquivalent('zone')].toString(),
          approved: getFPStatus(map[getFPEquivalent('approved')]),
          cancelled: getFPStatus(map[getFPEquivalent('cancelled')]),
        );

  Map<String, dynamic> toMap() => {
        'id': id,
        'dateTime': dateTime,
        'entryDate': entryDate,
        'billPeriod': billPeriod,
        'amount': amount,
        'invoiceNo': invoiceNo,
        'receiptNo': receiptNo,
        'contractId': contractId,
        'contractNo': contractNo,
        'dpc': dpc,
        'fullName': fullName,
        'rcbNo': rcbNo,
        'cashpoint': cashpoint,
        'tariff': tariff,
        'district': district,
        'zone': zone,
        'approved': approved,
        'cancelled': cancelled,
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
          case 'dateTime':
          case 'entryDate':
            value =
                e.value == null ? '' : (e.value as DateTime?)!.toDateString();
            break;
          case 'billPeriod':
            value = billPeriod!.month.toString();
            break;
          case 'approved':
          case 'cancelled':
            value = getFPStatusReversed(e.value);
            break;
          default:
            value = e.value;
        }
      }

      return MapEntry(getFPEquivalent(key)!, value);
    }));
    return fpMap;
  }
}

enum PaymentStatus { approved, cancelled }
