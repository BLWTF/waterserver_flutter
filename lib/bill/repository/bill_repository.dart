import 'dart:async';

import 'package:waterserver/bill/bill.dart';
import 'package:waterserver/cache/cache.dart';
import 'package:waterserver/contract/model/contract.dart';
import 'package:waterserver/database/database.dart';

class BillRepository {
  final MysqlDatabaseRepository _mysqlDatabaseRepository;
  final CacheClient _cache;
  static const billsCountCacheKey = '__bill_count_cache_key';
  static const currentBillDateCacheKey = '__current_bill_date_cache_key';
  static const table = 'bill';

  BillRepository({
    required MysqlDatabaseRepository mysqlDatabaseRepository,
    CacheClient? cache,
  })  : _cache = cache ?? CacheClient(),
        _mysqlDatabaseRepository = mysqlDatabaseRepository;

  DateTime? get currentBillDateCache {
    return _cache.read<DateTime>(key: currentBillDateCacheKey);
  }

  set currentBillDateCache(DateTime? currentBillDate) {
    if (currentBillDate != null) {
      _cache.write(key: currentBillDateCacheKey, value: currentBillDate);
    }
  }

  Map<String, int> get billsCountCache {
    return _cache.read<Map<String, int>>(key: billsCountCacheKey) ?? {};
  }

  set billsCountCache(Map<String, int> counts) {
    _cache.write<Map<String, int>>(key: billsCountCacheKey, value: counts);
  }

  Future<void> createBill(Contract contract) async {
    DateTime currentDateTime = DateTime.now();
    final newBill = Bill.fromContract(
      contract,
      billingPeriod: currentDateTime.month.toString(),
      billingYear: currentDateTime.year.toString(),
    );
    final billMap = newBill.toFPMap();
    await _mysqlDatabaseRepository.create(table: table, fields: billMap);
  }

  Future<List<Bill>> getBills({
    int? limit,
    Map<String, dynamic>? where,
    int? offset,
    List<String>? fields,
    String? orderBy,
    DateTime? billDate,
    bool master = false,
  }) async {
    final billDateString = billDate.toString().split(' ').first;
    final billDateWhere = {'billdate': billDateString};
    var whereFinal = where;

    if (whereFinal != null) {
      billDate != null ? whereFinal.addAll(billDateWhere) : null;
    } else {
      billDate != null ? whereFinal = billDateWhere : null;
    }

    final tableFinal = await getTable(billDate, master);

    try {
      final billsMap = await _mysqlDatabaseRepository.get(
        table: tableFinal,
        where: whereFinal,
        limit: limit,
        offset: offset,
        fields: fields,
        orderBy: orderBy,
      );

      final List<Bill> bills = billsMap.map((billsMap) {
        return Bill.fromFPMap(billsMap);
      }).toList();

      return bills;
    } on TimeoutException catch (_) {
      return await getBills(
          limit: limit,
          where: where,
          offset: offset,
          fields: fields,
          orderBy: orderBy,
          master: master);
    }
  }

  Future<String> getTable([DateTime? billDate, bool master = false]) async {
    if (master) {
      return 'bill_master';
    }
    final currentBillDate = await getCurrentBillDate();
    final tableFinal = billDate != null && currentBillDate.isAfter(billDate)
        ? 'bill_master'
        : table;
    return tableFinal;
  }

  Future<int?> countBills({
    Map<String, dynamic>? where,
    DateTime? billDate,
  }) async {
    final billDateString = billDate.toString().split(' ').first;
    final billDateWhere = {'billdate': billDateString};
    var whereFinal = where;

    if (whereFinal != null) {
      billDate != null ? whereFinal.addAll(billDateWhere) : null;
    } else {
      billDate != null ? whereFinal = billDateWhere : null;
    }

    final tableFinal = await getTable(billDate);

    try {
      final count = await _mysqlDatabaseRepository.count(
        table: tableFinal,
        where: whereFinal,
      );
      return billsCountCache.putIfAbsent(billDateString, () => count!);
    } on TimeoutException catch (_) {
      return await countBills(where: where, billDate: billDate);
    }
  }

  Future<List<Bill>> searchBills({
    int? limit,
    int? offset,
    required List<String> fields,
    required String query,
    Map<String, dynamic>? where,
    String? orderBy,
    DateTime? billDate,
  }) async {
    final billDateString = billDate.toString().split(' ').first;
    final billDateWhere = {'billdate': billDateString};

    if (where != null) {
      billDate != null ? where.addAll(billDateWhere) : null;
    } else {
      billDate != null ? where = billDateWhere : null;
    }

    final tableFinal = await getTable(billDate);

    final billsMap = await _mysqlDatabaseRepository.search(
      table: tableFinal,
      query: query,
      where: where,
      limit: limit,
      offset: offset,
      fields: fields,
      orderBy: orderBy,
    );

    final List<Bill> bills = billsMap.map((billsMap) {
      return Bill.fromFPMap(billsMap);
    }).toList();

    return bills;
  }

  Future<int?> countSearchBills({
    required String query,
    required List<String> fields,
    Map<String, dynamic>? where,
    DateTime? billDate,
  }) async {
    final billDateString = billDate.toString().split(' ').first;
    final billDateWhere = {'billdate': billDateString};

    if (where != null) {
      billDate != null ? where.addAll(billDateWhere) : null;
    } else {
      billDate != null ? where = billDateWhere : null;
    }

    final tableFinal = await getTable(billDate);

    final count = await _mysqlDatabaseRepository.countSearch(
      table: tableFinal,
      query: query,
      fields: fields,
      where: where,
    );
    return count;
  }

  Future<DateTime> getCurrentBillDate() async {
    if (currentBillDateCache == null) {
      final rawCurrentBillDate = await _mysqlDatabaseRepository.get(
          table: table, fields: ['max(billdate) as _max'], limit: 1);

      currentBillDateCache =
          rawCurrentBillDate.first['_max'].toString().toDateTime();
      return currentBillDateCache!;
    }
    return currentBillDateCache!;
  }

  Future<Bill?> getBill(
      {String? id,
      String? contractNo,
      DateTime? billDate,
      bool master = false}) async {
    if (id != null) {
      final tableFinal = await getTable(null, master);
      final contractMap = await _mysqlDatabaseRepository.find(
          table: tableFinal, id: id, altId: Bill.getFPEquivalent('id'));
      return Bill.fromFPMap(
          contractMap.map((key, value) => MapEntry(key.toString(), value)));
    }

    if (contractNo != null) {
      final billList = await getBills(
        where: {'contract_no': contractNo},
        billDate: billDate,
        orderBy: billDate != null ? 'billdate' : null,
        master: master,
        limit: 1,
      );
      return billList.isNotEmpty ? billList.first : null;
    }

    return null;
  }
}

extension MysqlDateTimeToDateTime on String {
  DateTime toDateTime() {
    final splitList = split('-');
    return DateTime(
      int.parse(splitList[0]),
      int.parse(splitList[1]),
      int.parse(splitList[2]),
    );
  }
}
