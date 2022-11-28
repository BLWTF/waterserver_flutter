import 'package:waterserver/area/area.dart';
import 'package:waterserver/cache/cache.dart';
import 'package:waterserver/database/database.dart';
import 'package:waterserver/payment/payment.dart';
import 'package:waterserver/tariff/tariff.dart';

class PaymentRepository {
  final MysqlDatabaseRepository _mysqlDatabaseRepository;
  final AreaRepository _areaRepository;
  final TariffRepository _tariffRepository;
  final CacheClient _cache;
  static const paymentsCountCacheKey = '__payment_count_cache_key';
  static const table = 'payments';

  PaymentRepository({
    required mysqlDatabaseRepository,
    required areaRepository,
    required tariffRepository,
    CacheClient? cache,
  })  : _cache = cache ?? CacheClient(),
        _mysqlDatabaseRepository = mysqlDatabaseRepository,
        _tariffRepository = tariffRepository,
        _areaRepository = areaRepository;

  int? get countCache {
    return _cache.read<int>(key: paymentsCountCacheKey);
  }

  set countCache(int? count) {
    if (count != null) {
      _cache.write(key: paymentsCountCacheKey, value: count);
    }
  }

  Future<void> createPayment(Payment payment) async {
    final entryDate = DateTime.now();
    final paymentMap = payment.toFPMap({
      'entryDate': entryDate,
    });
    await _mysqlDatabaseRepository.create(
      table: table,
      fields: paymentMap,
    );
  }

  Future<int> deletePayment(String id) async {
    final deletedId =
        await _mysqlDatabaseRepository.delete(table: table, where: {'id': id});
    return deletedId;
  }

  Future<List<Payment>> getPaymentsByContract(
    String contractNo, [
    Map<String, dynamic>? where,
    int? limit,
    int? offset,
    List<String>? fields,
    String? orderBy,
  ]) async {
    final payments = await getPayments(
      where: {
        Payment.getFPEquivalent('contractNo')!: contractNo,
      }..addAll(where ?? {}),
      limit: limit ?? 1000,
      offset: offset,
      fields: fields,
      orderBy: orderBy,
    );

    return payments;
  }

  Future<List<Payment>> getPayments({
    int? limit,
    Map<String, dynamic>? where,
    int? offset,
    List<String>? fields,
    String? orderBy,
  }) async {
    final paymentsMap = await _mysqlDatabaseRepository.get(
      table: table,
      where: where,
      limit: limit,
      offset: offset,
      fields: fields,
      orderBy: orderBy ?? 'id',
    );
    final List<Payment> payments = paymentsMap.map((paymentMap) {
      return Payment.fromFPMap(paymentMap);
    }).toList();

    return payments;
  }

  Future<Payment> getPayment(String id) async {
    final paymentMap =
        await _mysqlDatabaseRepository.find(table: table, id: id);
    return Payment.fromFPMap(paymentMap as Map<String, dynamic>);
  }

  Future<List<Payment>> searchPayments({
    int? limit,
    required String query,
    int? offset,
    required List<String> fields,
    String? orderBy,
  }) async {
    final paymentsMap = await _mysqlDatabaseRepository.search(
      table: table,
      query: query,
      limit: limit,
      offset: offset,
      fields: fields,
      orderBy: orderBy ?? 'id',
    );

    final List<Payment> payments = paymentsMap.map((paymentMap) {
      return Payment.fromFPMap(paymentMap);
    }).toList();

    return payments;
  }

  Future<int?> countPayments({
    Map<String, dynamic>? where,
  }) async {
    final count = countCache ??=
        await _mysqlDatabaseRepository.count(table: table, where: where);
    return count;
  }

  Future<int?> countSearchPayments({
    required String query,
    required List<String> fields,
  }) async {
    final count = await _mysqlDatabaseRepository.countSearch(
        table: table, query: query, fields: fields);
    return count;
  }

  Future<List<String>> getCashpoints() async {
    final rows = await _mysqlDatabaseRepository.get(
      table: 'cashpoint',
      fields: ['cashpoint'],
    );

    final list = rows.map((row) => row['cashpoint'].toString().trim()).toList();
    return list;
  }
}
