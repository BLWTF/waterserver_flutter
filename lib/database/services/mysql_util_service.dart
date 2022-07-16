import 'dart:io';

import 'package:mysql_utils/mysql_utils.dart';
import 'package:waterserver/database/database_provider.dart';
import 'package:waterserver/database/exceptions.dart';
// ignore: depend_on_referenced_packages
import 'package:mysql_client/exception.dart';
import 'package:waterserver/settings/settings.dart' show MysqlSettings;

class MysqlUtilService implements DatabaseProvider {
  MysqlUtils? _db;

  MysqlUtilService();

  @override
  Future<void> connect(MysqlSettings settings) async {
    print(settings.toJson());
    try {
      final db = MysqlUtils(
        settings: settings.toJson(),
      );
      await db.singleConn;
      _db = db;
    } on MySQLServerException catch (e) {
      throw CouldNotConnectToDBException(e.message);
    } on SocketException catch (e) {
      throw CouldNotConnectToDBException(
          'Can\'t establish connection to database.');
    } catch (e) {
      throw CouldNotConnectToDBException(e.toString());
    }
  }

  @override
  Future<int> count({required String table, String fields = '*'}) async {
    final count = await _db!.count(table: table, fields: fields);
    return count;
  }

  @override
  Future<int> create({
    required String table,
    required Map<String, dynamic> fields,
  }) async {
    final createCount = _db!.insert(table: table, insertData: fields);
    return createCount;
  }

  @override
  Future<int> createMany(
      {required String table,
      required List<Map<String, dynamic>> fieldsList}) async {
    final createCount =
        await _db!.insertAll(table: table, insertData: fieldsList);
    return createCount;
  }

  @override
  Future<int> delete(
      {required String table, required Map<String, dynamic> where}) async {
    final deleteCount = await _db!.delete(table: table, where: where);
    return deleteCount;
  }

  @override
  Future<Map<String, dynamic>> find(
      {required String table, required String id}) async {
    final row = await _db!.getOne(table: table);
    return row as Map<String, dynamic>;
  }

  @override
  Future<int> update(
      {required String table,
      required Map<String, dynamic> where,
      required Map<String, dynamic> fields}) async {
    final updateCount = await _db!.update(
      table: table,
      updateData: fields,
      where: where,
    );
    return updateCount;
  }
}
