import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/database/database.dart';

class ContractRepository {
  final MysqlDatabaseRepository _mysqlDatabaseRepository;

  static const table = 'contract';

  ContractRepository({required MysqlDatabaseRepository mysqlDatabaseRepository})
      : _mysqlDatabaseRepository = mysqlDatabaseRepository;

  Future<List<Contract>> getCustomers() async {
    final customersMap = await _mysqlDatabaseRepository.get(
      table: table,
      limit: 20,
    );

    final List<Contract> customers = customersMap.map((customerJson) {
      return Contract.fromFPJson(customerJson);
    }).toList();

    return customers;
  }
}
