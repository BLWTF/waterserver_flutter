import 'package:waterserver/database/database_provider.dart';
import 'package:waterserver/settings/models/mysql_settings.dart';

class DatabaseService implements DatabaseProvider {
  final DatabaseProvider provider;

  DatabaseService(this.provider);

  @override
  Future<void> connect(MysqlSettings settings) => provider.connect(settings);

  @override
  Future<int> count({required String table, String fields = '*'}) =>
      provider.count(table: table, fields: fields);

  @override
  Future<int> create(
          {required String table, required Map<String, dynamic> fields}) =>
      provider.create(table: table, fields: fields);

  @override
  Future<int> createMany({
    required String table,
    required List<Map<String, dynamic>> fieldsList,
  }) =>
      provider.createMany(table: table, fieldsList: fieldsList);

  @override
  Future<int> delete(
          {required String table, required Map<String, dynamic> where}) =>
      provider.delete(table: table, where: where);

  @override
  Future<Map<String, dynamic>> find(
          {required String table, required String id}) =>
      provider.find(table: table, id: id);

  @override
  Future<int> update({
    required String table,
    required Map<String, dynamic> where,
    required Map<String, dynamic> fields,
  }) =>
      provider.update(
        table: table,
        where: where,
        fields: fields,
      );

  @override
  Future<List<dynamic>> get({
    required String table,
    required Map<String, dynamic>? where,
    int? limit,
  }) =>
      provider.get(table: table, where: where);
}
