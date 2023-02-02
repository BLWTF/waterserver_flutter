import 'package:waterserver/database/database.dart';
import 'package:waterserver/settings/models/mysql_settings.dart';

class DatabaseService implements DatabaseProvider {
  final DatabaseProvider provider;

  DatabaseService(this.provider);

  @override
  Future<void> connect(MysqlSettings settings) async =>
      await provider.connect(settings);

  @override
  Future<int> count({
    required String table,
    String fields = '*',
    Map<String, dynamic>? where,
  }) async =>
      await provider.count(
        table: table,
        fields: fields,
        where: where,
      );

  @override
  Future<int> create(
          {required String table,
          required Map<String, dynamic> fields}) async =>
      await provider.create(table: table, fields: fields);

  @override
  Future<int> createMany({
    required String table,
    required List<Map<String, dynamic>> fieldsList,
  }) async =>
      await provider.createMany(table: table, fieldsList: fieldsList);

  @override
  Future<int> delete(
          {required String table, required Map<String, dynamic> where}) async =>
      await provider.delete(table: table, where: where);

  @override
  Future<Map<dynamic, dynamic>> find(
          {required String table, required String id}) async =>
      await provider.find(table: table, id: id);

  @override
  Future<int> update({
    required String table,
    required Map<String, dynamic> where,
    required Map<String, dynamic> fields,
  }) async =>
      await provider.update(
        table: table,
        where: where,
        fields: fields,
      );

  @override
  Future<List<dynamic>> get({
    required String table,
    required Map<String, dynamic>? where,
    List<String>? fields,
    int? limit,
    int? offset,
    String? orderBy,
  }) async =>
      await provider.get(
        table: table,
        where: where,
        limit: limit,
        offset: offset,
        orderBy: orderBy,
      );

  @override
  Future<void> close() async => await provider.close();

  @override
  Future max({
    required String table,
    required String field,
    String? group,
    Map<String, dynamic>? having,
    Map<String, dynamic>? where,
  }) async =>
      await provider.max(
        table: table,
        field: field,
        where: where,
        group: group,
        having: having,
      );
}
