import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:waterserver/bill/bill.dart';
import 'package:waterserver/database/database.dart';
import 'package:waterserver/utilities/generics/number_format.dart';

class BillDataSourceAsync extends AsyncDataTableSource {
  final BillRepository _billRepository;
  final List<String> _columnNames;
  final Function(String) onClickCell;
  final DateTime currentDate;

  BillDataSourceAsync({
    required BillRepository billRepository,
    required List<String> columnNames,
    required this.onClickCell,
    required this.currentDate,
    String? searchQuery,
  })  : _billRepository = billRepository,
        _columnNames = columnNames,
        _searchQuery = searchQuery;

  String? _searchQuery;

  String? get searchQuery => _searchQuery;
  set searchQuery(String? search) {
    _searchQuery = search;
    refreshDatasource();
  }

  String _sortColumn = Bill.getFPEquivalent('id')!;
  bool _sortAscending = true;

  @override
  Future<AsyncRowsResponse> getRows(int start, int end) async {
    try {
      final fieldsRaw = _columnNames.fold<List<String>>(
        [],
        (previousValue, element) {
          if (Bill.casts.containsKey(element)) {
            return [...previousValue, ...Bill.casts[element]!];
          }
          return [...previousValue, element];
        },
      );

      final fields =
          fieldsRaw.map((field) => Bill.getFPEquivalent(field)!).toList();
      late final int? billsCount;
      late final List<Bill> bills;

      if (searchQuery == null || searchQuery!.isEmpty) {
        billsCount = await _billRepository.countBills(billDate: currentDate);
        bills = await _billRepository.getBills(
          offset: start,
          limit: end,
          orderBy: _sortColumn,
          fields: fields,
          billDate: currentDate,
        );
      } else {
        billsCount = await _billRepository.countSearchBills(
          fields: fields,
          query: searchQuery!,
          billDate: currentDate,
        );
        bills = await _billRepository.searchBills(
          query: searchQuery!,
          fields: fields,
          offset: start,
          limit: end,
          billDate: currentDate,
        );
      }

      final rows = bills.map(
        (bill) {
          final billMap = bill.toMap();
          final billMapEntries = _columnNames
              .map(
                (column) => MapEntry<String, dynamic>(column, billMap[column]),
              )
              .toList();
          return Map.fromEntries(billMapEntries);
        },
      ).toList();

      final billRows = rows.map((row) {
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
                  Text(el.value?.toString() ?? ''),
                  onTap: () => onClickCell(row['id']),
                );
                break;
              case 'openingBalance':
              case 'closingBalance':
                cell = DataCell(
                  Text('₦${double.parse(el.value.toString()).format()}'),
                );
                break;
              case 'monthEnd':
                cell = DataCell(
                  Text(el.value.toString().split(' ').first),
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

      return AsyncRowsResponse(billsCount!, billRows);
    } on DatabaseConnectionException catch (e) {
      throw '${e.message}: Connection problem, try later.';
    } on DatabaseIsNotConnectedException catch (_) {
      throw 'Database is not connected';
    }
  }
}

const Map<String, TableColumnMeta> columnsMeta = {
  'contractNo': TableColumnMeta(label: 'Contract No.'),
  'name': TableColumnMeta(label: 'Name'),
  'dpc': TableColumnMeta(label: 'DPC'),
  'openingBalance': TableColumnMeta(label: 'Opening'),
  'closingBalance': TableColumnMeta(label: 'Closing'),
  'connectionAddress': TableColumnMeta(label: 'Address'),
  'category': TableColumnMeta(label: 'Category'),
  'tariff': TableColumnMeta(label: 'Tariff'),
  'meter': TableColumnMeta(label: 'Meter'),
  'meterNo': TableColumnMeta(label: 'Meter No.'),
  'meterType': TableColumnMeta(label: 'Meter Type'),
  'meterSize': TableColumnMeta(label: 'Meter Size'),
  'area': TableColumnMeta(label: 'Area Code'),
  'district': TableColumnMeta(label: 'District'),
  'zone': TableColumnMeta(label: 'Zone'),
  'subzone': TableColumnMeta(label: 'Subzone'),
  'round': TableColumnMeta(label: 'Round'),
  'monthEnd': TableColumnMeta(label: 'Bill Date'),
};

class TableColumnMeta {
  final String label;

  const TableColumnMeta({required this.label});
}
