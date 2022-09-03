import 'package:waterserver/cache/cache.dart';
import 'package:waterserver/database/database.dart';

import '../model/tariff.dart';

class TariffRepository {
  final MysqlDatabaseRepository _mysqlDatabaseRepository;
  final CacheClient _cache;
  static const tariffsCacheKey = '__tariffs_cache_key';

  TariffRepository(
      {required MysqlDatabaseRepository mysqlDatabaseRepository,
      CacheClient? cache})
      : _mysqlDatabaseRepository = mysqlDatabaseRepository,
        _cache = cache ?? CacheClient();

  List<Tariff>? get tariffsCache {
    return _cache.read<List<Tariff>>(key: tariffsCacheKey);
  }

  set tariffsCache(List<Tariff>? tariffs) {
    _cache.write<List<Tariff>>(key: tariffsCacheKey, value: tariffs!);
  }

  Future<List<Tariff>> getTariffs() async {
    if (tariffsCache == null) {
      final rows =
          await _mysqlDatabaseRepository.get(table: 'tariff', limit: 100);
      tariffsCache = rows.map((row) => Tariff.fromFPMap(row)).toList();
      return tariffsCache!;
    }

    return tariffsCache!;
  }
}
