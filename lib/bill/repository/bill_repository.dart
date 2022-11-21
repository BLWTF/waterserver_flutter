import 'dart:async';

import 'package:rxdart/transformers.dart';
import 'package:waterserver/area/area.dart';
import 'package:waterserver/bill/bill.dart';
import 'package:waterserver/cache/cache.dart';
import 'package:waterserver/contract/model/contract.dart';
import 'package:waterserver/database/database.dart';
import 'package:waterserver/tariff/tariff.dart';
import 'package:waterserver/utilities/generics/datetime_to_string.dart';

class BillRepository {
  final MysqlDatabaseRepository _mysqlDatabaseRepository;
  final AreaRepository _areaRepository;
  final TariffRepository _tariffRepository;
  final CacheClient _cache;
  static const billsCountCacheKey = '__bill_count_cache_key';
  static const currentBillDateCacheKey = '__current_bill_date_cache_key';
  static const table = 'bill';

  BillRepository({
    required MysqlDatabaseRepository mysqlDatabaseRepository,
    required AreaRepository areaRepository,
    required TariffRepository tariffRepository,
    CacheClient? cache,
  })  : _cache = cache ?? CacheClient(),
        _mysqlDatabaseRepository = mysqlDatabaseRepository,
        _areaRepository = areaRepository,
        _tariffRepository = tariffRepository;

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
    final billDateWhere = {
      Bill.getFPEquivalent('billingPeriod')!: billDate!.month,
      Bill.getFPEquivalent('billingYear')!: billDate.year,
    };
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

  Future<int> countBillsByAreas(
    List<String> areas,
    AreaType areaType,
    DateTime date,
  ) async {
    final where = getAreaWhereString(areas, areaType, date);

    final count =
        await _mysqlDatabaseRepository.rawCount(table: table, where: where);
    return count;
  }

  Future<List<Bill>> getBillsByAreas({
    required List<String> areas,
    required AreaType areaType,
    required DateTime date,
    List<String>? field,
    int? limit,
    int? offset,
    String? orderBy,
  }) async {
    final where = getAreaWhereString(areas, areaType, date);

    final billMaps = await _mysqlDatabaseRepository.rawGet(
      table: table,
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
    );

    return billMaps.map((billMap) => Bill.fromFPMap(billMap)).toList();
  }

  String getAreaWhereString(
    List<String> areas,
    AreaType areaType,
    DateTime date,
  ) {
    final List<Map<AreaType, String>> areaMapsList = areas.map((area) {
      var index = 0;
      final Map<AreaType, String> map = Map.fromEntries(
        area.split('-').map((e) {
          final entry = MapEntry(AreaType.values[index], e);
          index++;
          return entry;
        }),
      );
      return map;
    }).toList();

    final whereAreaString =
        areaMapsList.fold<String>('', (prevAreaString, areaMap) {
      final areaEntries = areaMap.entries;
      String areaString = '(';
      int i = 0;
      for (var area in areaEntries) {
        if ((areaEntries.length - 1) == i) {
          areaString +=
              '${Bill.getFPEquivalent(area.key.name)!} = "${area.value}")';
        } else {
          areaString +=
              '${Bill.getFPEquivalent(area.key.name)!} = "${area.value}" and ';
        }
        i++;
      }

      prevAreaString =
          prevAreaString.isEmpty ? prevAreaString : '$prevAreaString or';
      return '$prevAreaString $areaString';
    });

    final where =
        '($whereAreaString) and ${Bill.getFPEquivalent('billingPeriod')!} = "${date.month}" and ${Bill.getFPEquivalent('billingYear')!} = ${date.year}';

    return where;
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
    final billDateWhere = {
      Bill.getFPEquivalent('billingPeriod')!: billDate!.month,
      Bill.getFPEquivalent('billingYear')!: billDate.year,
    };
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
    final billDateWhere = {
      Bill.getFPEquivalent('billingPeriod')!: billDate!.month,
      Bill.getFPEquivalent('billingYear')!: billDate.year,
    };

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
    final billDateWhere = {
      Bill.getFPEquivalent('billingPeriod')!: billDate!.month,
      Bill.getFPEquivalent('billingYear')!: billDate.year,
    };

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

  Future<List<District>> getBillPeriodDistricts(DateTime billDate) async {
    final billPeriodDistrictMap = await _mysqlDatabaseRepository.get(
      table: table,
      fields: ['distinct district'],
      where: {
        'district': ['<>', '""'],
        'billdate': billDate.toDateString(),
      },
      limit: 100,
    );

    final districts = await _areaRepository.getDistricts();

    final billPeriodDistrict = billPeriodDistrictMap.map((districtMap) {
      return districts.firstWhere(
          (district) => district.code == districtMap['district'],
          orElse: () =>
              District(code: districtMap['district'], description: 'Nill'));
    }).toList();

    return billPeriodDistrict;
  }

  Future<List<Zone>> getBillPeriodZones(DateTime billDate) async {
    final billPeriodZoneMap = await _mysqlDatabaseRepository.get(
      table: table,
      fields: ['distinct district, zone'],
      where: {
        'zone': ['<>', '""'],
        'billdate': billDate.toDateString(),
      },
      limit: 100,
    );

    final billPeriodZones = await Future.wait(
      billPeriodZoneMap.map((zoneMap) async {
        final zones = await _areaRepository.getZones(zoneMap['district']);
        return zones.firstWhere(
            (zone) => zone.code == "${zoneMap['district']}-${zoneMap['zone']}",
            orElse: () => Zone(
                zoneCode: zoneMap['zone'],
                districtCode: zoneMap['district'],
                description: 'Nill'));
      }).toList(),
    );

    return billPeriodZones;
  }

  Future<List<Subzone>> getBillPeriodSubzones(DateTime billDate) async {
    final billPeriodSubzoneMap = await _mysqlDatabaseRepository.get(
      table: table,
      fields: ['distinct district, zone, subzone'],
      where: {
        'subzone': ['<>', '""'],
        'billdate': billDate.toDateString(),
      },
      limit: 100,
    );

    final billPeriodSubzones = await Future.wait(
      billPeriodSubzoneMap.map((subzoneMap) async {
        final subzones = await _areaRepository
            .getSubzones("${subzoneMap['district']}-${subzoneMap['zone']}");
        return subzones.firstWhere(
            (subzone) =>
                subzone.code ==
                "${subzoneMap['district']}-${subzoneMap['zone']}-${subzoneMap['subzone']}",
            orElse: () => Subzone(
                subzoneCode: subzoneMap['subzone'],
                zoneCode: subzoneMap['zone'],
                districtCode: subzoneMap['district'],
                description: 'Nill'));
      }).toList(),
    );
    return billPeriodSubzones;
  }

  Future<List<Round>> getBillPeriodRounds(DateTime billDate) async {
    final billPeriodRoundMap = await _mysqlDatabaseRepository.get(
      table: table,
      fields: ['distinct district, zone, subzone, rounds'],
      where: {
        'rounds': ['<>', '""'],
        'billdate': billDate.toDateString(),
      },
      limit: 1000,
    );

    final billPeriodRounds = await Future.wait(
      billPeriodRoundMap.map((roundMap) async {
        final rounds = await _areaRepository.getRounds(
            "${roundMap['district']}-${roundMap['zone']}-${roundMap['subzone']}");
        return rounds.firstWhere(
            (round) =>
                round.code ==
                "${roundMap['district']}-${roundMap['zone']}-${roundMap['subzone']}-${roundMap['rounds']}",
            orElse: () => Round(
                roundCode: roundMap['rounds'],
                subzoneCode: roundMap['subzone'],
                zoneCode: roundMap['zone'],
                districtCode: roundMap['district'],
                description: 'Nill'));
      }).toList(),
    );
    return billPeriodRounds;
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
