part of 'contract_cubit.dart';

class ContractState extends Equatable {
  final ContractTableData? tableData;
  final List<String> columns;

  static const List<String> defaultTableColumns = [
    'contractNo',
    'name',
    'dpc',
    'connectionAddress',
    'category',
    'tariff',
  ];

  const ContractState({
    this.tableData,
    this.columns = defaultTableColumns,
  });

  ContractState copyWith({
    ContractTableData? tableData,
  }) =>
      ContractState(
        tableData: tableData ?? this.tableData,
      );

  @override
  List<Object?> get props => [tableData];
}

class ContractTableData extends Equatable {
  final List<String> columns;
  final List<Contract> contracts;
  late final List<String> columnLabels;
  late final List<Map<String, dynamic>> rows;

  static const Map<String, TableColumnMeta> columnsMeta = {
    'contractNo': TableColumnMeta(label: 'Contract No'),
    'name': TableColumnMeta(label: 'Name'),
    'dpc': TableColumnMeta(label: 'DPC'),
    'connectionAddress': TableColumnMeta(label: 'Address'),
    'category': TableColumnMeta(label: 'Category'),
    'tariff': TableColumnMeta(label: 'Tariff'),
    'district': TableColumnMeta(label: 'District'),
  };

  ContractTableData({
    required this.columns,
    required this.contracts,
  }) {
    _parseColumnLabels();

    _parseRows();
  }

  void _parseColumnLabels() => columnLabels =
      columns.map((column) => columnsMeta[column]!.label).toList();

  void _parseRows() => rows = contracts.map(
        (contract) {
          final contractMap = contract.toMap();
          final contractMapEntries = columns
              .map(
                (column) =>
                    MapEntry<String, dynamic>(column, contractMap[column]),
              )
              .toList();
          return Map.fromEntries(contractMapEntries);
        },
      ).toList();

  @override
  List<Object?> get props => [columnLabels, columns, rows];
}

class TableColumnMeta {
  final String label;

  const TableColumnMeta({required this.label});
}
