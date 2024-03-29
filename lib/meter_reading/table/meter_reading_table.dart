import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:waterserver/meter_reading/meter_reading.dart';
import 'package:waterserver/meter_reading/table/meter_reading_data_source.dart';

class MeterReadingTable extends StatefulWidget {
  final MeterReadingRepository _meterReadingRepository;
  final List<String> columnNames;
  final String? searchQuery;
  final Function(String) onSearch;
  final Function(String) onClickReading;

  const MeterReadingTable({
    super.key,
    required MeterReadingRepository meterReadingRepository,
    required this.columnNames,
    this.searchQuery,
    required this.onSearch,
    required this.onClickReading,
  }) : _meterReadingRepository = meterReadingRepository;

  @override
  State<MeterReadingTable> createState() => _MeterReadingTableState();
}

class _MeterReadingTableState extends State<MeterReadingTable> {
  MeterReadingDataSourceAsync? _meterReadingDataSource;

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  final PaginatorController _paginatorController = PaginatorController();

  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.searchQuery;
    _meterReadingDataSource = MeterReadingDataSourceAsync(
      meterReadingRepository: widget._meterReadingRepository,
      columnNames: widget.columnNames,
      onClickCell: widget.onClickReading,
      searchQuery: _searchQuery,
    );
  }

  @override
  void didUpdateWidget(covariant MeterReadingTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _meterReadingDataSource?.refreshDatasource();
  }

  @override
  void dispose() {
    _paginatorController.dispose();
    _meterReadingDataSource?.dispose();
    super.dispose();
  }

  set searchQuery(String? query) {
    _searchQuery = query;
    widget.onSearch(query!);
  }

  List<DataColumn> get _columns {
    return widget.columnNames
        .where((columnName) => columnName != 'id')
        .map<DataColumn>((columnName) {
      return DataColumn(
        label: Text(columnsMeta[columnName]!.label),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AsyncPaginatedDataTable2(
        wrapInCard: false,
        minWidth: 700,
        showFirstLastButtons: true,
        horizontalMargin: 20,
        checkboxHorizontalMargin: 12,
        columnSpacing: 0,
        columns: _columns,
        controller: _paginatorController,
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            _SearchBox(
                query: _searchQuery,
                onChanged: (search) {
                  setState(() {
                    searchQuery = search;
                    _meterReadingDataSource!.searchQuery = search;
                  });
                }),
          ],
        ),
        source: _meterReadingDataSource!,
        rowsPerPage: _rowsPerPage,
        onRowsPerPageChanged: (value) {
          // No need to wrap into setState, it will be called inside the widget
          // and trigger rebuild
          //setState(() {
          _rowsPerPage = value!;
          //});
        },
        empty: Center(
            child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.grey[200],
                child: const Text('No data'))),
        errorBuilder: (e) => _ErrorAndRetry(
            e.toString(), () => _meterReadingDataSource!.refreshDatasource()),
      ),
    );
  }
}

class _SearchBox extends StatefulWidget {
  final Function(String) onChanged;
  final String? query;

  const _SearchBox({Key? key, required this.onChanged, this.query})
      : super(key: key);

  @override
  State<_SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<_SearchBox> {
  late final TextEditingController queryController;
  Timer? searchThrottler;

  @override
  void initState() {
    super.initState();
    queryController = TextEditingController(text: widget.query)
      ..addListener(_onSearchBoxChange);
  }

  void _onSearchBoxChange() {
    if (queryController.text != widget.query) {
      if (searchThrottler != null) {
        searchThrottler!.cancel();
      }
      searchThrottler = Timer(const Duration(milliseconds: 900), () {
        widget.onChanged(queryController.text);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: TextField(
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Search readings',
          suffixIcon: widget.query.toString().isNotEmpty
              ? IconButton(
                  splashRadius: 1,
                  iconSize: 16,
                  padding: const EdgeInsets.only(top: 20),
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    queryController.text = '';
                  },
                )
              : null,
        ),
        controller: queryController,
      ),
    );
  }
}

class _ErrorAndRetry extends StatelessWidget {
  const _ErrorAndRetry(this.errorMessage, this.retry);

  final String errorMessage;
  final void Function() retry;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
            padding: const EdgeInsets.all(10),
            height: 70,
            color: Colors.red,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Oops! $errorMessage',
                      style: const TextStyle(color: Colors.white)),
                  TextButton(
                      onPressed: retry,
                      child:
                          Row(mainAxisSize: MainAxisSize.min, children: const [
                        Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        Text('Retry', style: TextStyle(color: Colors.white))
                      ]))
                ])),
      );
}
