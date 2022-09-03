import 'package:waterserver/cache/cache.dart';
import 'package:waterserver/settings/settings.dart';

class SettingsRepository {
  static const settingsCacheKey = '__settings_cache_key';
  final SettingsProvider _settingsProvider;
  final CacheClient _cache;

  SettingsRepository(
      {required SettingsProvider settingsProvider, CacheClient? cache})
      : _cache = cache ?? CacheClient(),
        _settingsProvider = settingsProvider;

  Stream<MysqlSettings> get mysqlSettings =>
      _settingsProvider.getMysqlSettings().map((settings) {
        _cache.write<MysqlSettings>(key: settingsCacheKey, value: settings);
        return settings;
      });

  // MysqlSettings get currentMysqlSettings {
  //   return _cache.read<MysqlSettings>(key: settingsCacheKey) ??
  //       MysqlSettings.empty;
  // }

  Future<void> saveMysqlSettings(MysqlSettings mysqlSettings) =>
      _settingsProvider.saveMysqlSettings(mysqlSettings);
}
