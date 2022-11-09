part of 'bill.dart';

const List<String> printByOptions = ['district', 'zone', 'subzone', 'rounds'];

class BillPrint extends StatefulWidget {
  final ScrollController scrollController = ScrollController();
  BillPrint({super.key});

  @override
  State<BillPrint> createState() => _BillPrintState();
}

class _BillPrintState extends State<BillPrint> {
  bool loadingPrintBy = false;
  List<Area> searchedAreas = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      scrollController: widget.scrollController,
      header: PageHeader(
        title: const Text('Bill Printing'),
        commandBar: Button(
          child: const Icon(FluentIcons.back),
          onPressed: () {
            context.read<BillCubit>().pageChanged(BillManagementPage.main);
          },
        ),
      ),
      children: [
        Builder(builder: (context) {
          final printBillDate =
              context.select((BillCubit cubit) => cubit.state.printBillDate);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoLabel(
                label: 'Billing Period',
                child: MonthPicker(
                    selectedDate: printBillDate ??
                        context.read<BillCubit>().state.billDate ??
                        DateTime.now(),
                    onSelected: (date) async {
                      context.read<BillCubit>().updatePrintBillDate(date);
                      await context
                          .read<BillCubit>()
                          .updateBillPrintBy(null, date);
                    }),
              ),
              const SizedBox(height: 30),
              InfoLabel(
                label: 'Print by',
                child: Builder(builder: (context) {
                  final printBy = context
                      .select((BillCubit cubit) => cubit.state.billPrintBy);
                  return ComboBox<String>(
                    value: printBy,
                    items: printByOptions.map((e) {
                      return ComboBoxItem<String>(
                        value: e,
                        child: Text(e.capFirst()),
                      );
                    }).toList(),
                    placeholder: const Text('None selected'),
                    icon: loadingPrintBy
                        ? const SizedBox(
                            width: 64,
                            height: 16,
                            child: mt.LinearProgressIndicator())
                        : const Icon(FluentIcons.chevron_down),
                    onChanged: !loadingPrintBy
                        ? (value) async {
                            setState(() {
                              loadingPrintBy = true;
                            });
                            await context.read<BillCubit>().updateBillPrintBy(
                                  value!,
                                  printBillDate ??
                                      context.read<BillCubit>().state.billDate!,
                                );
                            setState(() {
                              loadingPrintBy = false;
                            });
                          }
                        : null,
                  );
                }),
              ),
              const SizedBox(height: 30),
              Builder(
                builder: (context) {
                  final printByAreas = context
                      .select((BillCubit cubit) => cubit.state.printByAreas);
                  if (printByAreas == null) {
                    return const SizedBox.shrink();
                  }
                  return InfoLabel(
                    label: 'Select area',
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: Colors.black,
                        width: 0.5,
                      )),
                      child: SizedBox(
                        height: 200,
                        width: 250,
                        child: Column(
                          children: [
                            TextBox(
                              placeholder:
                                  'Search ${context.read<BillCubit>().state.billPrintBy}s',
                              onChanged: (value) => setState(() {
                                searchedAreas = printByAreas
                                    .where((area) => area
                                        .toString()
                                        .toLowerCase()
                                        .contains(value))
                                    .toList();
                              }),
                            ),
                            ListTile.selectable(
                              title: const Text('Select all'),
                              selectionMode: ListTileSelectionMode.multiple,
                              selected: context
                                  .read<BillCubit>()
                                  .isAllAreasSelected(),
                              onSelectionChange: (selected) {
                                if (selected) {
                                  context.read<BillCubit>().selectAllAreas();
                                } else {
                                  context.read<BillCubit>().deselectAllAreas();
                                }
                              },
                            ),
                            Expanded(
                              child: BlocBuilder<BillCubit, BillState>(
                                builder: (context, state) {
                                  final selectedPrintByAreas = context.select(
                                      (BillCubit cubit) =>
                                          cubit.state.selectedPrintByAreas);
                                  final listViewList = searchedAreas.isEmpty
                                      ? printByAreas
                                      : searchedAreas;
                                  return ListView.builder(
                                    itemCount: listViewList.length,
                                    itemBuilder: (context, index) {
                                      final area = listViewList[index];
                                      return ListTile.selectable(
                                        title: Text('$area'),
                                        selectionMode:
                                            ListTileSelectionMode.multiple,
                                        selected:
                                            selectedPrintByAreas.contains(area),
                                        onSelectionChange: (selected) {
                                          if (selected) {
                                            context
                                                .read<BillCubit>()
                                                .selectArea(area);
                                          } else {
                                            context
                                                .read<BillCubit>()
                                                .deselectArea(area);
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Visibility(
                visible: context
                    .read<BillCubit>()
                    .state
                    .selectedPrintByAreas
                    .isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: FilledButton(
                    child: const Text('Print'),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          );
        })
      ],
    );
  }
}
