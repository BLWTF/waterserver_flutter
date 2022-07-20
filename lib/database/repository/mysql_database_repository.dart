import 'package:waterserver/database/database.dart';
import 'package:waterserver/settings/models/mysql_settings.dart';

class MysqlDatabaseRepository {
  final DatabaseProvider _databaseProvider;

  MysqlDatabaseRepository({required databaseProvider})
      : _databaseProvider = databaseProvider;

  Future<void> connect(MysqlSettings settings) async {
    await _databaseProvider.connect(settings);
  }

  Future<int?> count({required String table, String fields = '*'}) =>
      _databaseProvider.count(table: table, fields: fields);

  Future<int> create({
    required String table,
    required Map<String, dynamic> fields,
  }) =>
      _databaseProvider.create(table: table, fields: fields);

  Future<int> createMany({
    required String table,
    required List<Map<String, dynamic>> fieldsList,
  }) =>
      _databaseProvider.createMany(table: table, fieldsList: fieldsList);

  Future<Map<String, dynamic>> find({
    required String table,
    required String id,
  }) =>
      _databaseProvider.find(table: table, id: id);

  Future<int> update({
    required String table,
    required Map<String, dynamic> where,
    required Map<String, dynamic> fields,
  }) =>
      _databaseProvider.update(
        table: table,
        where: where,
        fields: fields,
      );

  Future<List<dynamic>> get({
    required String table,
    Map<String, dynamic>? where,
    int? limit,
  }) =>
      _databaseProvider.get(
        table: table,
        where: where,
        limit: limit,
      );
}
