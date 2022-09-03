import 'package:data_table_2/data_table_2.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/material.dart';
import 'package:waterserver/contract/model/contract.dart';
import 'package:waterserver/database/database.dart';

import '../repository/contract_repository.dart';

class ContractDataSourceAsync extends AsyncDataTableSource {
  final ContractRepository _contractRepository;
  final List<String> _columnNames;
  final Function(String) onClickCell;

  ContractDataSourceAsync({
    required ContractRepository contractRepository,
    required List<String> columnNames,
    required this.onClickCell,
    String? searchQuery,
  })  : _contractRepository = contractRepository,
        _columnNames = columnNames,
        _searchQuery = searchQuery;

  String? _searchQuery;

  String? get searchQuery => _searchQuery;
  set searchQuery(String? search) {
    _searchQuery = search;
    refreshDatasource();
  }

  String _sortColumn = 'id';
  bool _sortAscending = true;

  @override
  Future<AsyncRowsResponse> getRows(int start, int end) async {
    try {
      final fieldsRaw = _columnNames.fold<List<String>>(
        [],
        (previousValue, element) {
          if (Contract.casts.containsKey(element)) {
            return [...previousValue, ...Contract.casts[element]!];
          }
          return [...previousValue, element];
        },
      );

      final fields =
          fieldsRaw.map((field) => Contract.getFPEquivalent(field)!).toList();
      late final int? contractsCount;
      late final List<Contract> contracts;

      if (searchQuery == null || searchQuery!.isEmpty) {
        contractsCount = await _contractRepository.countContracts();
        contracts = await _contractRepository.getContracts(
          offset: start,
          limit: end,
          orderBy: _sortColumn,
          fields: fields,
        );
      } else {
        contractsCount = await _contractRepository.countSearchContracts(
            fields: fields, query: searchQuery!);
        contracts = await _contractRepository.searchContracts(
            query: searchQuery!, fields: fields, offset: start, limit: end);
      }

      final rows = contracts.map(
        (contract) {
          final contractMap = contract.toMap();
          final contractMapEntries = _columnNames
              .map(
                (column) =>
                    MapEntry<String, dynamic>(column, contractMap[column]),
              )
              .toList();
          return Map.fromEntries(contractMapEntries);
        },
      ).toList();

      final contractRows = rows.map((row) {
        return DataRow(key: ValueKey<int>(int.parse(row['id'])), cells: [
          ...row.entries
              .where((cell) => cell.key != 'id')
              .fold<List<DataCell>>([], (prev, el) {
            if (el.key == 'id') {
              return prev;
            }
            return [
              ...prev,
              DataCell(
                Text(el.value?.toString() ?? ''),
                onTap: el.key == 'contractNo'
                    ? () => onClickCell(row['id'])
                    : null,
              )
            ];
          })
        ]);
      }).toList();

      return AsyncRowsResponse(contractsCount!, contractRows);
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
};

class TableColumnMeta {
  final String label;

  const TableColumnMeta({required this.label});
}
