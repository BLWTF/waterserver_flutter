import 'package:waterserver/cache/cache.dart';
import 'package:waterserver/database/database.dart';
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
}
