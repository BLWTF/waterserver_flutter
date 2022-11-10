import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:waterserver/database/database.dart';
import 'package:waterserver/payment/payment.dart';
import 'package:waterserver/utilities/generics/number_format.dart';

class PaymentDataSourceAsync extends AsyncDataTableSource {
  final PaymentRepository _paymentRepository;
  final List<String> _columnNames;
  final Function(String) onClickCell;

  PaymentDataSourceAsync({
    required PaymentRepository paymentRepository,
    required List<String> columnNames,
    required this.onClickCell,
    String? searchQuery,
  })  : _paymentRepository = paymentRepository,
        _columnNames = columnNames,
        _searchQuery = searchQuery;

  String? _searchQuery;

  String? get searchQuery => _searchQuery;
  set searchQuery(String? search) {
    _searchQuery = search;
    refreshDatasource();
  }

  String _sortColumn = 'id desc';
  bool _sortAscending = true;

  @override
  Future<AsyncRowsResponse> getRows(int start, int end) async {
    try {
      final fieldsRaw = _columnNames.fold<List<String>>(
        [],
        (previousValue, element) {
          if (Payment.casts.containsKey(element)) {
            return [...previousValue, ...Payment.casts[element]!];
          }
          return [...previousValue, element];
        },
      );
      final fields =
          fieldsRaw.map((field) => Payment.getFPEquivalent(field)!).toList();
      late final int? paymentsCount;
      late final List<Payment> payments;

      if (searchQuery == null || searchQuery!.isEmpty) {
        paymentsCount = await _paymentRepository.countPayments();
        payments = await _paymentRepository.getPayments(
          offset: start,
          limit: end,
          orderBy: _sortColumn,
          fields: fields,
        );
      } else {
        paymentsCount = await _paymentRepository.countSearchPayments(
            fields: fields, query: searchQuery!);
        payments = await _paymentRepository.searchPayments(
            query: searchQuery!, fields: fields, offset: start, limit: end);
      }

      final rows = payments.map(
        (payment) {
          final paymentMap = payment.toMap();
          final paymentMapEntries = _columnNames
              .map(
                (column) =>
                    MapEntry<String, dynamic>(column, paymentMap[column]),
              )
              .toList();
          return Map.fromEntries(paymentMapEntries);
        },
      ).toList();

      final paymentRows = rows.map((row) {
        return DataRow(key: ValueKey<int>(int.parse(row['id'])), cells: [
          ...row.entries
              .where((cell) => cell.key != 'id')
              .fold<List<DataCell>>([], (prev, el) {
            if (el.key == 'id') {
              return prev;
            }
            late final DataCell cell;
            switch (el.key) {
              case 'contractNo':
                cell = DataCell(
                  Text(el.value?.toString() ?? '-'),
                  onTap: () => onClickCell(row['id']),
                );
                break;
              case 'amount':
                cell = DataCell(
                  Text('₦${double.parse(el.value.toString()).format()}'),
                );
                break;
              default:
                cell = DataCell(
                  Text(el.value?.toString() ?? ''),
                );
            }
            return [
              ...prev,
              cell,
            ];
          })
        ]);
      }).toList();

      return AsyncRowsResponse(paymentsCount!, paymentRows);
    } on DatabaseConnectionException catch (e) {
      throw '${e.message}: Connection problem, try later.';
    } on DatabaseIsNotConnectedException catch (_) {
      throw 'Database is not connected';
    }
  }
}

const Map<String, TableColumnMeta> columnsMeta = {
  'contractNo': TableColumnMeta(label: 'Contract No.'),
  'fullName': TableColumnMeta(label: 'Name'),
  'dpc': TableColumnMeta(label: 'DPC'),
  'amount': TableColumnMeta(label: 'Amount'),
  'dateTime': TableColumnMeta(label: 'Date'),
  'receiptNo': TableColumnMeta(label: 'Receipt'),
  'tariff': TableColumnMeta(label: 'Tariff'),
  'district': TableColumnMeta(label: 'District'),
  'zone': TableColumnMeta(label: 'Zone'),
};

class TableColumnMeta {
  final String label;

  const TableColumnMeta({required this.label});
}
