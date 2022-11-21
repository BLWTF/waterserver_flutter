import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:waterserver/database/database.dart';
import 'package:waterserver/meter_reading/meter_reading.dart';

class MeterReadingDataSourceAsync extends AsyncDataTableSource {
  final MeterReadingRepository _meterReadingRepository;
  final List<String> _columnNames;
  final Function(String) onClickCell;

  MeterReadingDataSourceAsync({
    required MeterReadingRepository meterReadingRepository,
    required List<String> columnNames,
    required this.onClickCell,
    String? searchQuery,
  })  : _meterReadingRepository = meterReadingRepository,
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
          if (MeterReading.casts.containsKey(element)) {
            return [...previousValue, ...MeterReading.casts[element]!];
          }
          return [...previousValue, element];
        },
      );

      final fields = fieldsRaw
          .map((field) => MeterReading.getFPEquivalent(field)!)
          .toList();
      late final int? readingsCount;
      late final List<MeterReading> readings;

      if (searchQuery == null || searchQuery!.isEmpty) {
        readingsCount = await _meterReadingRepository.countReadings();
        readings = await _meterReadingRepository.getReadings(
          offset: start,
          limit: end,
          orderBy: _sortColumn,
          fields: fields,
        );
      } else {
        readingsCount = await _meterReadingRepository.countSearchReadings(
            fields: fields, query: searchQuery!);
        readings = await _meterReadingRepository.searchReadings(
            query: searchQuery!, fields: fields, offset: start, limit: end);
      }

      final rows = readings.map(
        (reading) {
          final readingMap = reading.toMap();
          final readingMapEntries = _columnNames
              .map(
                (column) =>
                    MapEntry<String, dynamic>(column, readingMap[column]),
              )
              .toList();
          return Map.fromEntries(readingMapEntries);
        },
      ).toList();

      final readingRows = rows.map((row) {
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

      return AsyncRowsResponse(readingsCount!, readingRows);
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
  'previousReading': TableColumnMeta(label: 'Prev. Reading'),
  'presentReading': TableColumnMeta(label: 'Pres. Reading'),
  'readingDate': TableColumnMeta(label: 'Date'),
  'address': TableColumnMeta(label: 'Address'),
  'category': TableColumnMeta(label: 'Category'),
  'tariff': TableColumnMeta(label: 'Tariff'),
  'meter': TableColumnMeta(label: 'Meter'),
  'meterNo': TableColumnMeta(label: 'Meter No.'),
  'meterType': TableColumnMeta(label: 'Meter Type'),
  'meterSize': TableColumnMeta(label: 'Meter Size'),
  'area': TableColumnMeta(label: 'Area Code'),
  'district': TableColumnMeta(label: 'District'),
  'zone': TableColumnMeta(label: 'Zone'),
};

class TableColumnMeta {
  final String label;

  const TableColumnMeta({required this.label});
}
