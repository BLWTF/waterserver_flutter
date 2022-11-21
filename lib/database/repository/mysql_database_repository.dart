import 'package:waterserver/database/database.dart';
import 'package:waterserver/settings/models/mysql_settings.dart';

import '../../app/bloc/app_bloc.dart';

class MysqlDatabaseRepository {
  final MysqlUtilService _databaseProvider;

  MysqlDatabaseRepository({required databaseProvider})
      : _databaseProvider = databaseProvider;

  Future<void> connect(MysqlSettings settings) async {
    await _databaseProvider.connect(settings);
  }

  Stream<AppMysqlStatus> get mysqlStatus => _databaseProvider.mysqlStatus;

  Future<int?> count({
    required String table,
    String fields = '*',
    Map<String, dynamic>? where,
  }) {
    final count =
        _databaseProvider.count(table: table, fields: fields, where: where);

    return count;
  }

  Future<int> create({
    required String table,
    required Map<String, dynamic> fields,
  }) {
    final createdCount = _databaseProvider.create(table: table, fields: fields);
    return createdCount;
  }

  Future<int> createMany({
    required String table,
    required List<Map<String, dynamic>> fieldsList,
  }) =>
      _databaseProvider.createMany(table: table, fieldsList: fieldsList);

  Future<Map<dynamic, dynamic>> find({
    required String table,
    required String id,
    String? altId,
  }) =>
      _databaseProvider.find(table: table, id: id, altId: altId);

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
    List<String>? fields,
    int? limit,
    int? offset,
    String? orderBy,
  }) {
    final rows = _databaseProvider.get(
      table: table,
      where: where,
      fields: fields,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
    );
    return rows;
  }

  Future<List<dynamic>> rawGet({
    required String table,
    required String where,
    List<String>? fields,
    int? limit,
    int? offset,
    String? orderBy,
  }) {
    final rows = _databaseProvider.rawGet(
      table: table,
      where: where,
      fields: fields,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
    );
    return rows;
  }

  Future<int> rawCount({
    required String table,
    required String where,
  }) {
    final rows = _databaseProvider.rawCount(
      table: table,
      where: where,
    );
    return rows;
  }

  Future<List<dynamic>> search({
    required String table,
    required String query,
    required List<String> fields,
    Map<String, dynamic>? where,
    int? limit,
    int? offset,
    String? orderBy,
  }) {
    final rows = _databaseProvider.search(
      table: table,
      query: query,
      where: where,
      fields: fields,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
    );
    return rows;
  }

  Future<int> countSearch({
    required String table,
    required String query,
    required List<String> fields,
    Map<String, dynamic>? where,
  }) {
    final count = _databaseProvider.countSearch(
      table: table,
      query: query,
      fields: fields,
      where: where,
    );
    return count;
  }

  Future<double> max({
    required String table,
    required String field,
    String? group,
    Map<String, dynamic>? having,
    Map<String, dynamic>? where,
  }) async {
    final max = await _databaseProvider.max(
      table: table,
      field: field,
      where: where,
      group: group,
      having: having,
    );
    return max;
  }

  Future<int> delete({
    required String table,
    required Map<String, dynamic> where,
  }) async {
    return await _databaseProvider.delete(table: table, where: where);
  }
}

// extension ToMapForSqlSearch on List<String> {
//   Map<String, List> toMapForSqlSearch(String query) {
//     final Map<String, List> map =
//         Map.fromEntries(fold<Iterable<MapEntry<String, List<dynamic>>>>(
//       {},
//       (prev, el) => [
//         ...prev,
//         MapEntry(el, ['like', '%$query%'])
//       ],
//     ));
//     return map;
//   }
// }
