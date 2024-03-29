import 'package:waterserver/area/area.dart';
import 'package:waterserver/cache/cache.dart';
import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/database/database.dart';
import 'package:waterserver/tariff/repository/tariff_repository.dart';

class ContractRepository {
  final MysqlDatabaseRepository _mysqlDatabaseRepository;
  final AreaRepository _areaRepository;
  final TariffRepository _tariffRepository;
  final CacheClient _cache;
  static const contractsCountCacheKey = '__contract_count_cache_key';

  static const table = 'contract';

  ContractRepository({
    required MysqlDatabaseRepository mysqlDatabaseRepository,
    required AreaRepository areaRepository,
    required TariffRepository tariffRepository,
    CacheClient? cache,
  })  : _cache = cache ?? CacheClient(),
        _mysqlDatabaseRepository = mysqlDatabaseRepository,
        _areaRepository = areaRepository,
        _tariffRepository = tariffRepository;

  int? get countCache {
    return _cache.read<int>(key: contractsCountCacheKey);
  }

  set countCache(int? count) {
    if (count != null) {
      _cache.write(key: contractsCountCacheKey, value: count);
    }
  }

  Future<Contract> createContract(Contract contract) async {
    final newContractNo = await getNewContractNo();
    final contractMap = contract.toFPMap({
      'contractNo': newContractNo,
      'dpc':
          '${contract.district!}-${contract.zone!}-${contract.subzone!}-${contract.round!}-${contract.folio!}',
    });
    final newContactId = await _mysqlDatabaseRepository.create(
        table: table, fields: contractMap);
    final newContract = await getContract(id: newContactId.toString());
    return newContract!;
  }

  Future<void> updateContract(Contract contract) async {
    await _mysqlDatabaseRepository.update(
        table: table, where: {'id': contract.id}, fields: contract.toFPMap());
  }

  Future<String> getNewContractNo() async {
    final lastContractNo = await _mysqlDatabaseRepository.get(
      table: table,
      where: {
        'contract_no': ['like', '%FP']
      },
      fields: ['contract_no'],
      limit: 1,
      orderBy: 'id DESC',
    );

    if (lastContractNo.isEmpty) {
      return '1000FP';
    } else {
      final newContractNo = int.parse(
            lastContractNo.first['contract_no'].toString().split('FP').first,
          ) +
          1;
      return '${newContractNo}FP';
    }
  }

  Future<String> getNewFolio({
    required String round,
  }) async {
    final district = round.getAreaCode(AreaType.district);
    final zone = round.getAreaCode(AreaType.zone);
    final subzone = round.getAreaCode(AreaType.subzone);
    final roundCode = round.getAreaCode(AreaType.round);
    final lastFolio = await _mysqlDatabaseRepository.get(
      table: table,
      fields: ['max(folio) as _max'],
      where: {
        'district': district,
        'zone': zone,
        'subzone': subzone,
        'rounds': roundCode,
      },
      limit: 1,
    );
    final newFolio = int.parse(lastFolio.first['_max'] ?? '0').abs() + 100;
    return newFolio.toString().padLeft(4, '0');
  }

  Future<Contract?> getContract({String? id, String? contractNo}) async {
    if (id != null) {
      final contractMap =
          await _mysqlDatabaseRepository.find(table: table, id: id);
      return Contract.fromFPMap(
          contractMap.map((key, value) => MapEntry(key.toString(), value)));
    }

    if (contractNo != null) {
      final contractList =
          await getContracts(where: {'contract_no': contractNo}, limit: 1);
      return contractList.isNotEmpty ? contractList.first : null;
    }

    return null;
  }

  Future<List<Contract>> getContracts({
    int? limit,
    Map<String, dynamic>? where,
    int? offset,
    List<String>? fields,
    String? orderBy,
  }) async {
    final contractsMap = await _mysqlDatabaseRepository.get(
      table: table,
      where: where,
      limit: limit,
      offset: offset,
      fields: fields,
      orderBy: orderBy ?? 'id',
    );

    final List<Contract> contracts = contractsMap.map((contractMap) {
      return Contract.fromFPMap(contractMap);
    }).toList();

    return contracts;
  }

  Future<List<Contract>> searchContracts({
    int? limit,
    required String query,
    int? offset,
    required List<String> fields,
    String? orderBy,
  }) async {
    final contractsMap = await _mysqlDatabaseRepository.search(
      table: table,
      query: query,
      limit: limit,
      offset: offset,
      fields: fields,
      orderBy: orderBy ?? 'id',
    );

    final List<Contract> contracts = contractsMap.map((contractJson) {
      return Contract.fromFPMap(contractJson);
    }).toList();

    return contracts;
  }

  Future<int?> countContracts({
    Map<String, dynamic>? where,
  }) async {
    final count = countCache ??=
        await _mysqlDatabaseRepository.count(table: table, where: where);
    return count;
  }

  Future<int?> countSearchContracts({
    required String query,
    required List<String> fields,
  }) async {
    final count = await _mysqlDatabaseRepository.countSearch(
        table: table, query: query, fields: fields);
    return count;
  }

  Future<List> getMeterSizes() async {
    final rows = await _mysqlDatabaseRepository.get(
      table: table,
      fields: ['distinct size1'],
      where: {
        'size1': ['<>', '""']
      },
      limit: 100,
    );

    final list = rows.map((row) => row['size1'].toString().trim()).toList();
    return list;
  }

  Future<List> getMeterTypes() async {
    final rows = await _mysqlDatabaseRepository.get(
      table: table,
      fields: ['distinct meter_type'],
      where: {
        'meter_type': ['<>', '""']
      },
      limit: 100,
    );

    final list =
        rows.map((row) => row['meter_type'].toString().trim()).toList();
    return list;
  }
}

const String safeContractNoSql = '''
          SELECT max(contract_no) FROM waterserverkd.contract 
          where contract_no like '0%' or contract_no like '1%' 
          or contract_no like '2%' or contract_no like '3%' 
          or contract_no like '4%' or contract_no like '5%' 
          or contract_no like '6%' or contract_no like '7%' 
          or contract_no like '8%' or contract_no like '9%'
''';
