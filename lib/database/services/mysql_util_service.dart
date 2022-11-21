import 'dart:developer';
import 'dart:io';

import 'package:mysql_utils/mysql_utils.dart';
import 'package:rxdart/subjects.dart';
import 'package:waterserver/app/bloc/app_bloc.dart';
import 'package:waterserver/database/database_provider.dart';
import 'package:waterserver/database/exceptions.dart';
import 'package:waterserver/settings/settings.dart' show MysqlSettings;
// ignore: depend_on_referenced_packages
import 'package:mysql_client/exception.dart';

class MysqlUtilService implements DatabaseProvider {
  MysqlUtils? _db;
  MysqlSettings _settings = const MysqlSettings();

  MysqlUtilService();

  final _mysqlStatusController = BehaviorSubject<AppMysqlStatus>();

  Stream<AppMysqlStatus> get mysqlStatus =>
      _mysqlStatusController.asBroadcastStream();

  void changeMysqlStatus(AppMysqlStatus status) =>
      _mysqlStatusController.add(status);

  @override
  Future<void> connect([MysqlSettings? settings]) async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    _settings = settings ?? _settings;
    if (_settings.isNotEmpty) {
      final settingsMap = {
        ..._settings.toMap(),
        'secure': false,
        'pool': false,
      };
      try {
        final db = MysqlUtils(
            settings: settingsMap,
            errorLog: (error) {
              log(error);
            });

        if (settings?.pool != true) {
          await db.singleConn;
        } else {
          await db.poolConn;
        }

        _db = db;
        _mysqlStatusController.add(AppMysqlStatus.connected);
      } on MySQLServerException catch (e) {
        throw CouldNotConnectToDBException(e.message);
      } on SocketException catch (_) {
        throw CouldNotConnectToDBException(
            'Can\'t establish connection to database.');
      } catch (e) {
        throw CouldNotConnectToDBException(e.toString());
      }
    } else {
      throw DatabaseSettingsNotProvidedException();
    }
  }

  Future<void> _ensureDbIsConnected() async {
    try {
      await connect();
    } on DatabaseAlreadyOpenException {
      // _mysqlStatusController.add(AppMysqlStatus.disconnected);
    }
  }

  Future<MysqlUtils> _getDbOrThrow() async {
    final db = _db;
    if (db == null) {
      _mysqlStatusController.add(AppMysqlStatus.disconnected);
      throw DatabaseIsNotConnectedException();
    } else {
      return db;
    }
  }

  @override
  Future<int> count({
    required String table,
    String fields = '*',
    Map<String, dynamic>? where,
  }) async {
    await _ensureDbIsConnected();
    final db = await _getDbOrThrow();
    final count = db.count(table: table, fields: fields, where: where);
    return count;
  }

  Future<int> rawCount({
    required String table,
    String fields = '*',
    required String where,
  }) async {
    await _ensureDbIsConnected();
    final db = await _getDbOrThrow();
    final count = db.count(table: table, fields: fields, where: where);
    return count;
  }

  Future<int> countOr({
    required String table,
    required Map<String, List> where,
    Map<String, dynamic>? andWhere,
  }) async {
    await _ensureDbIsConnected();
    final db = await _getDbOrThrow();
    final whereOr = where.sqlify('or');
    final whereAnd = andWhere != null
        ? andWhere.entries.fold<String>(
            '', (prev, el) => '$prev${el.key} = "${el.value}" and ')
        : '';
    final whereFinal = '$whereAnd ($whereOr)';

    final count = db.count(
      table: table,
      where: whereFinal,
    );
    return count;
  }

  @override
  Future<int> create({
    required String table,
    required Map<String, dynamic> fields,
  }) async {
    await _ensureDbIsConnected();
    final db = await _getDbOrThrow();
    final createCount = db.insert(table: table, insertData: fields);
    return createCount;
  }

  @override
  Future<int> createMany({
    required String table,
    required List<Map<String, dynamic>> fieldsList,
  }) async {
    await _ensureDbIsConnected();
    final db = await _getDbOrThrow();
    final createCount = db.insertAll(table: table, insertData: fieldsList);
    return createCount;
  }

  @override
  Future<int> delete({
    required String table,
    required Map<String, dynamic> where,
  }) async {
    await _ensureDbIsConnected();
    final db = await _getDbOrThrow();
    final deleteCount = await db.delete(table: table, where: where);
    return deleteCount;
  }

  @override
  Future<Map<dynamic, dynamic>> find({
    required String table,
    required String id,
    String? altId,
  }) async {
    await _ensureDbIsConnected();
    final db = await _getDbOrThrow();
    final row = db.getOne(table: table, where: {'${altId ?? "id"}': id});
    return row;
  }

  @override
  Future<int> update({
    required String table,
    required Map<String, dynamic> where,
    required Map<String, dynamic> fields,
  }) async {
    await _ensureDbIsConnected();
    final db = await _getDbOrThrow();
    final updateCount = db.update(
      table: table,
      updateData: fields,
      where: where,
    );
    return updateCount;
  }

  Future<List<dynamic>> rawGet({
    required String table,
    required String where,
    List<String>? fields,
    int? limit,
    int? offset,
    String? orderBy,
  }) async {
    await _ensureDbIsConnected();
    final db = await _getDbOrThrow();
    final fieldsString = fields == null
        ? '*'
        : fields.reduce((value, element) => '$value,$element');
    final limitOffset =
        offset == null ? '${limit ?? ""}' : '$limit OFFSET $offset';
    print(limitOffset);
    final rows = await db.getAll(
      table: table,
      where: where,
      fields: fieldsString,
      limit: limitOffset,
      order: orderBy,
    );
    return rows;
  }

  @override
  Future<List<dynamic>> get({
    required String table,
    required Map<String, dynamic>? where,
    List<String>? fields,
    int? limit,
    int? offset,
    String? orderBy,
  }) async {
    await _ensureDbIsConnected();
    final db = await _getDbOrThrow();
    final fieldsString = fields == null
        ? '*'
        : fields.reduce((value, element) => '$value,$element');
    final limitOffset =
        offset == null ? '${limit ?? ""}' : '$limit OFFSET $offset';
    final rows = db.getAll(
      table: table,
      fields: fieldsString,
      where: where,
      limit: limitOffset,
      order: orderBy,
    );
    return rows;
  }

  Future<List<dynamic>> getOr({
    required String table,
    required Map<String, List> where,
    Map<String, dynamic>? andWhere,
    List<String>? fields,
    int? limit,
    int? offset,
    String? orderBy,
  }) async {
    await _ensureDbIsConnected();
    final db = await _getDbOrThrow();
    final fieldsString = fields == null
        ? '*'
        : fields.reduce((value, element) => '$value,$element');
    final limitOffet =
        offset == null ? '${limit ?? ""}' : '$limit OFFSET $offset';
    final whereOr = where.sqlify('or');
    final whereAnd = andWhere != null
        ? andWhere.entries.fold<String>(
            '', (prev, el) => '$prev${el.key} = "${el.value}" and ')
        : '';
    final whereFinal = '$whereAnd ($whereOr)';
    final rows = db.getAll(
      table: table,
      fields: fieldsString,
      where: whereFinal,
      limit: limitOffet,
      order: orderBy,
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
  }) async {
    await _ensureDbIsConnected();
    final db = await _getDbOrThrow();
    final fieldsString = fields.reduce((value, element) => '$value,$element');
    final limitOffet =
        offset == null ? '${limit ?? ""}' : '$limit OFFSET $offset';
    final splitQueries = query.split(' ');
    final whereOrMapList =
        splitQueries.map((query) => fields.toMapForSqlSearch(query));
    final whereOrString = whereOrMapList.fold<String>('', (prev, el) {
      prev = prev.isEmpty ? prev : '$prev and ';
      return '$prev(${el.sqlify('or')})';
    });
    // final whereAnd = andWhere != null
    //     ? andWhere.entries.fold<String>(
    //         '', (prev, el) => '$prev${el.key} = "${el.value}" and ')
    //     : '';
    // final whereFinal = '$whereAnd ($whereOrString)';
    final rows = db.getAll(
      table: table,
      fields: fieldsString,
      where: whereOrString,
      limit: limitOffet,
      order: orderBy,
    );
    return rows;
  }

  Future<int> countSearch({
    required String table,
    required String query,
    required List<String> fields,
    Map<String, dynamic>? where,
  }) async {
    await _ensureDbIsConnected();
    final db = await _getDbOrThrow();
    final splitQueries = query.split(' ');
    final whereOrMapList =
        splitQueries.map((query) => fields.toMapForSqlSearch(query));
    final whereOrString = whereOrMapList.fold<String>('', (prev, el) {
      prev = prev.isEmpty ? prev : '$prev and ';
      return '$prev(${el.sqlify('or')})';
    });
    // final whereAnd = andWhere != null
    //     ? andWhere.entries.fold<String>(
    //         '', (prev, el) => '$prev${el.key} = "${el.value}" and ')
    //     : '';
    // final whereFinal = '$whereAnd ($whereOrString)';
    final count = db.count(
      table: table,
      where: whereOrString,
    );
    return count;
  }

  @override
  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotConnectedException();
    } else {
      await db.close();
      _db = null;
    }
  }

  @override
  Future max({
    required String table,
    required String field,
    String? group,
    Map<String, dynamic>? having,
    Map<String, dynamic>? where,
  }) async {
    final db = await _getDbOrThrow();
    return db.max(
      table: table,
      fields: field,
      where: where,
      having: having,
      group: group,
    );
  }
}

extension Sqlify on Map<String, List> {
  String sqlify(String seperator) {
    String sql = entries.fold<String>('', (prev, el) {
      prev = prev.isEmpty ? prev : '$prev $seperator ';
      return '$prev${el.key} ${el.value.first} "${el.value.elementAt(1)}"';
    });
    return sql;
  }
}

extension ToMapForSqlSearch on List<String> {
  Map<String, List> toMapForSqlSearch(String query) {
    final Map<String, List> map =
        Map.fromEntries(fold<Iterable<MapEntry<String, List<dynamic>>>>(
      {},
      (prev, el) => [
        ...prev,
        MapEntry(el, ['like', '%$query%'])
      ],
    ));
    return map;
  }
}
