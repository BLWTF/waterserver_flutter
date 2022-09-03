import 'package:waterserver/settings/models/mysql_settings.dart';

abstract class DatabaseProvider {
  Future<void> connect(MysqlSettings settings);

  Future<Map<dynamic, dynamic>> find({
    required String table,
    required String id,
  });

  Future<List<dynamic>> get({
    required String table,
    required Map<String, dynamic>? where,
    List<String>? fields,
    int? limit,
    int? offset,
    String? orderBy,
  });

  Future<int> create(
      {required String table, required Map<String, dynamic> fields});

  Future<int> createMany({
    required String table,
    required List<Map<String, dynamic>> fieldsList,
  });

  Future<int> update({
    required String table,
    required Map<String, dynamic> where,
    required Map<String, dynamic> fields,
  });

  Future<int> delete(
      {required String table, required Map<String, dynamic> where});

  Future<int> count({
    required String table,
    String fields = '*',
    Map<String, dynamic>? where,
  });

  Future max({
    required String table,
    required String field,
    String? group,
    Map<String, dynamic>? having,
    Map<String, dynamic>? where,
  });

  Future<void> close();
}
