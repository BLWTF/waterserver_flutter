import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterserver/settings/models/mysql_settings.dart';

class SettingsProvider {
  final SharedPreferences _plugin;

  SettingsProvider({required SharedPreferences plugin}) : _plugin = plugin {
    _init();
  }

  static const mysqlSettingsKey = 'mysql_settings';

  String? _getValue(String key) => _plugin.getString(key);

  Future _setValue(String key, String value) => _plugin.setString(key, value);

  final _mysqlSettingsController = BehaviorSubject<MysqlSettings>();

  void _init() {
    final mysqlSettingsJson = _getValue(mysqlSettingsKey);
    if (mysqlSettingsJson != null) {
      final mysqlSettings =
          MysqlSettings.fromJson(jsonDecode(mysqlSettingsJson));
      _mysqlSettingsController.add(mysqlSettings);
    } else {
      _mysqlSettingsController.add(MysqlSettings.empty);
    }
  }

  Stream<MysqlSettings> getMysqlSettings() =>
      _mysqlSettingsController.asBroadcastStream();

  Future<void> saveMysqlSettings(MysqlSettings mysqlSettings) {
    _mysqlSettingsController.add(mysqlSettings);
    return _setValue(mysqlSettingsKey, jsonEncode(mysqlSettings.toJson()));
  }
}
