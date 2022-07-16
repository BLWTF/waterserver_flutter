import 'package:waterserver/database/database.dart';
import 'package:waterserver/settings/models/mysql_settings.dart';

class MysqlDatabaseRepository {
  final DatabaseProvider _databaseProvider;

  MysqlDatabaseRepository({required databaseProvider})
      : _databaseProvider = databaseProvider;

  Future<void> connect(MysqlSettings settings) async {
    await _databaseProvider.connect(settings);
  }

  Future<int?> count({required String table, String fields = '*'}) async {
    final count = await _databaseProvider.count(table: table, fields: fields);
    return count;
  }
}
