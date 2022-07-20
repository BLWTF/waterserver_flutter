import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/material.dart'
    hide Icon, IconButton, Scrollbar, ListTile;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterserver/contract/contract.dart';

class ContractManagement extends StatelessWidget {
  const ContractManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ContractCubit>(),
      child: const ContractManagementView(),
    );
  }
}

class ContractManagementView extends StatefulWidget {
  const ContractManagementView({Key? key}) : super(key: key);

  @override
  State<ContractManagementView> createState() => _ContractManagementViewState();
}

class _ContractManagementViewState extends State<ContractManagementView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContractCubit, ContractState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ScaffoldPage.scrollable(
          header: PageHeader(
            title: const Text('Contract Management'),
            commandBar: IconButton(
              icon: const Icon(
                FluentIcons.add_friend,
                size: 24.0,
              ),
              onPressed: () {
                // Navigator.push(
                //     context,
                //     FluentPageRoute(
                //       builder: (context) => const ContractCreate(),
                //     ));
              },
            ),
          ),
          children: <Widget>[
            // Column(
            //   children: [
            //     SizedBox(
            //       height: 200,
            //       width: 500,
            //       child: ReorderableListView(
            //         children: const [
            //           ListTile(
            //             key: Key('value1'),
            //             title: Text('data1'),
            //           ),
            //           ListTile(
            //             key: Key('value2'),
            //             title: Text('data2'),
            //           ),
            //           ListTile(
            //             key: Key('value3'),
            //             title: Text('data3'),
            //           ),
            //           ListTile(
            //             key: Key('value4'),
            //             title: Text('data4'),
            //           ),
            //         ],
            //         onReorder: (i, j) {},
            //       ),
            //     ),
            //   ],
            // ),
            AdaptiveScrollbar(
              controller: _scrollController,
              position: ScrollbarPosition.bottom,
              underColor: Colors.blueGrey.withOpacity(0.3),
              sliderDefaultColor: Colors.grey.withOpacity(0.7),
              sliderActiveColor: Colors.grey,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: state.tableData != null
                    ? ContractTable(tableData: state.tableData!)
                    : const Text('No data'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ContractTable extends StatelessWidget {
  final ContractTableData tableData;

  const ContractTable({Key? key, required this.tableData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        ...tableData.columnLabels.map((label) => DataColumn(label: Text(label)))
      ],
      rows: [
        ...tableData.rows.map((row) {
          return DataRow(
            cells: [
              ...row.entries.map((row) => DataCell(Text(row.value))),
            ],
          );
        })
      ],
    );
  }
}
