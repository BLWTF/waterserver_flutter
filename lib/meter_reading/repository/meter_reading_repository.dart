import 'package:waterserver/cache/cache.dart';
import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/database/database.dart';
import 'package:waterserver/meter_reading/meter_reading.dart';
import 'package:waterserver/tariff/repository/tariff_repository.dart';

class MeterReadingRepository {
  final MysqlDatabaseRepository _mysqlDatabaseRepository;
  final TariffRepository _tariffRepository;
  final CacheClient _cache;
  static const readingsCountCacheKey = '__reading_count_cache_key';
  static const table = 'meter_reading';

  MeterReadingRepository({
    required mysqlDatabaseRepository,
    required tariffRepository,
    CacheClient? cache,
  })  : _cache = cache ?? CacheClient(),
        _mysqlDatabaseRepository = mysqlDatabaseRepository,
        _tariffRepository = tariffRepository;

  int? get countCache {
    return _cache.read<int>(key: readingsCountCacheKey);
  }

  set countCache(int? count) {
    if (count != null) {
      _cache.write(key: readingsCountCacheKey, value: count);
    }
  }

  Future<int?> countReadings({
    Map<String, dynamic>? where,
  }) async {
    final count = countCache ??=
        await _mysqlDatabaseRepository.count(table: table, where: where);
    return count;
  }

  Future<List<MeterReading>> getReadings({
    int? limit,
    Map<String, dynamic>? where,
    int? offset,
    List<String>? fields,
    String? orderBy,
  }) async {
    final readingsMap = await _mysqlDatabaseRepository.get(
      table: table,
      where: where,
      limit: limit,
      offset: offset,
      fields: fields,
      orderBy: orderBy ?? 'id',
    );

    final List<MeterReading> readings = readingsMap.map((readingMap) {
      return MeterReading.fromFPMap(readingMap);
    }).toList();
    return readings;
  }

  Future<MeterReading> getReadingById(String id) async {
    final readingsList = await getReadings(where: {'id': id}, limit: 1);
    return readingsList.first;
  }

  Future<MeterReading?> getReadingByContract(
      {String? contractNo, String? contractId}) async {
    if (contractId != null) {
      final readingList = await getReadings(
        where: {MeterReading.getFPEquivalent('contractId')!: contractId},
        limit: 1,
      );
      return readingList.isNotEmpty ? readingList.first : null;
    }

    if (contractNo != null) {
      final readingList = await getReadings(
        where: {MeterReading.getFPEquivalent('contractNo')!: contractNo},
        limit: 1,
      );
      return readingList.isNotEmpty ? readingList.first : null;
    }

    return null;
  }

  Future<void> createReading(Contract contract) async {
    final readingMap = MeterReading.fromContract(contract).toFPMap()
      ..removeWhere((key, value) => value == null);
    await _mysqlDatabaseRepository.create(
      table: table,
      fields: readingMap,
    );
  }

  Future<void> updateReading(MeterReading reading) async {
    final readingMap = reading.toFPMap()
      ..removeWhere((key, value) => value == null);
    await _mysqlDatabaseRepository.update(
      table: table,
      where: {
        'id': reading.id,
      },
      fields: readingMap,
    );
  }

  Future<List<MeterReading>> searchReadings({
    int? limit,
    required String query,
    int? offset,
    required List<String> fields,
    String? orderBy,
  }) async {
    final readingsMap = await _mysqlDatabaseRepository.search(
      table: table,
      query: query,
      limit: limit,
      offset: offset,
      fields: fields,
      orderBy: orderBy ?? 'id',
    );

    final List<MeterReading> readings = readingsMap.map((readingJson) {
      return MeterReading.fromFPMap(readingJson);
    }).toList();

    return readings;
  }

  Future<int?> countSearchReadings({
    required String query,
    required List<String> fields,
  }) async {
    final count = await _mysqlDatabaseRepository.countSearch(
        table: table, query: query, fields: fields);
    return count;
  }
}
