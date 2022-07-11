import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Colors;
import 'package:flutter/material.dart' hide Icon, IconButton, Scrollbar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterserver/app/bloc/app_bloc.dart';
import 'package:waterserver/widgets/window.dart';
import 'package:window_manager/window_manager.dart';

class ContractManagement extends StatefulWidget {
  const ContractManagement({Key? key}) : super(key: key);

  @override
  State<ContractManagement> createState() => _ContractManagementState();
}

class _ContractManagementState extends State<ContractManagement> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
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
            AdaptiveScrollbar(
              controller: _scrollController,
              position: ScrollbarPosition.bottom,
              underColor: Colors.blueGrey.withOpacity(0.3),
              sliderDefaultColor: Colors.grey.withOpacity(0.7),
              sliderActiveColor: Colors.grey,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Contract No.')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('DPC')),
                    DataColumn(label: Text('Address')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Tariff')),
                    DataColumn(label: Text('District')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('000232')),
                        DataCell(Text('Ahmad Umar')),
                        DataCell(Text('01-43-444')),
                        DataCell(Text('Zaria Local Government')),
                        DataCell(Text('Commercial')),
                        DataCell(Text('COM-01')),
                        DataCell(Text('01')),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ContractCreate extends StatelessWidget {
  const ContractCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTitle = context.read<AppBloc>().state.appTitle;
    return NavigationView(
      appBar: NavigationAppBar(
        title: DragToMoveArea(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(appTitle),
          ),
        ),
        leading: IconButton(
          icon: const Icon(FluentIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: Row(
          children: const [
            Spacer(),
            WindowButtons(),
          ],
        ),
      ),
      content: IconButton(
        icon: const Icon(FluentIcons.back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
