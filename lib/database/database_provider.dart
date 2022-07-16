import 'package:waterserver/settings/models/mysql_settings.dart';

abstract class DatabaseProvider {
  Future<void> connect(MysqlSettings settings);

  Future<Map<String, dynamic>> find(
      {required String table, required String id});

  Future create({required String table, required Map<String, dynamic> fields});

  Future<int> createMany({
    required String table,
    required List<Map<String, dynamic>> fieldsList,
  });

  // Future<Model> updateModel(
  //     {required Model model, Map<String, dynamic> fields});

  Future<int> update({
    required String table,
    required Map<String, dynamic> where,
    required Map<String, dynamic> fields,
  });

  Future<int> delete(
      {required String table, required Map<String, dynamic> where});

  Future<int> count({required String table, String fields = '*'});
}
