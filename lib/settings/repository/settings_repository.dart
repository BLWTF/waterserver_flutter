import 'package:waterserver/settings/settings.dart';

class SettingsRepository {
  final SettingsProvider _settingsProvider;

  const SettingsRepository({required SettingsProvider settingsProvider})
      : _settingsProvider = settingsProvider;

  Stream<MysqlSettings?> getMysqlSettings() =>
      _settingsProvider.getMysqlSettings();

  Future<void> saveMysqlSettings(MysqlSettings mysqlSettings) =>
      _settingsProvider.saveMysqlSettings(mysqlSettings);
}
