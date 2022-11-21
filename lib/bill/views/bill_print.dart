part of 'bill.dart';

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
          final printSession =
              context.select((BillCubit cubit) => cubit.state.printSession);
          if (printSession == null) {
            return const SelectPrint();
          } else {
            return PrintInfo(printSession: printSession);
          }
        })
      ],
    );
  }
}

class PrintInfo extends StatefulWidget {
  final PrintSession printSession;

  const PrintInfo({super.key, required this.printSession});

  @override
  State<PrintInfo> createState() => _PrintInfoState();
}

class _PrintInfoState extends State<PrintInfo> {
  bool loadingProceed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PrintInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final sessionCompleted =
          context.read<BillCubit>().state.printSession!.sessionsCompleted;
      final printingNumber =
          context.read<BillCubit>().state.printSession!.printingNumber;
      final range =
          '${(sessionCompleted * printingNumber) + 1}__${(sessionCompleted + 1) * printingNumber}';
      final areaType = context.read<BillCubit>().state.billPrintBy;
      final areas =
          context.read<BillCubit>().state.selectedPrintByAreas.fold<String>(
                '',
                (p, e) => (p.isEmpty ? e.code : "${p}_${e.code}"),
              );
      final name = '${areaType!.name}-$areas-$range';
      final bills =
          context.read<BillCubit>().state.printSession?.currentPrintBills;
      if (bills != null && bills.isNotEmpty) {
        final printDialog = await showPrintDialog(context, bills, name);

        if (printDialog != null && printDialog) {
          await context.read<BillCubit>().proceedPrintSession(true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRow(
          children: [
            InfoLabel(
              label: 'Printed:',
              labelStyle: FluentTheme.of(context)
                  .typography
                  .caption
                  ?.apply(fontSizeFactor: 1.3),
              child: Text(
                  '${widget.printSession.numberPrinted.toString()}/${widget.printSession.billsCount.toString()}'),
            ),
          ],
        ),
        if (widget.printSession.billsCount > 50) ...[
          CustomRow(
            children: [
              InfoLabel(
                label: 'Batch print',
                labelStyle: FluentTheme.of(context)
                    .typography
                    .caption
                    ?.apply(fontSizeFactor: 1.3),
                child: ComboBox<int>(
                  placeholder: const Text('Print batches'),
                  items: [50, 100, 200, 500]
                      .map((e) => ComboBoxItem<int>(
                            value: e,
                            child: Text(e.toString()),
                          ))
                      .toList(),
                  value: widget.printSession.printingNumber,
                  onChanged: (value) => {},
                ),
              ),
            ],
          ),
          CustomRow(
            children: [
              InfoLabel(
                label: 'No. of print sessions:',
                labelStyle: FluentTheme.of(context)
                    .typography
                    .caption
                    ?.apply(fontSizeFactor: 1.3),
                child: Text(
                    '${widget.printSession.sessionsCompleted.toString()}/${widget.printSession.sessions.toString()}'),
              ),
            ],
          )
        ],
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              Button(
                child: const Text('Cancel'),
                onPressed: () {
                  context.read<BillCubit>().cancelPrintSession();
                },
              ),
              const SizedBox(
                width: 10,
              ),
              FilledButton(
                onPressed: loadingProceed
                    ? null
                    : () async {
                        setState(() {
                          loadingProceed = true;
                        });
                        await context.read<BillCubit>().proceedPrintSession();
                        setState(() {
                          loadingProceed = false;
                        });
                      },
                child: Builder(builder: (context) {
                  if (loadingProceed) {
                    return const SizedBox(
                        width: 16,
                        height: 16,
                        child: mt.CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ));
                  } else {
                    return const Text('Proceed');
                  }
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SelectPrint extends StatefulWidget {
  const SelectPrint({super.key});

  @override
  State<SelectPrint> createState() => _SelectPrintState();
}

class _SelectPrintState extends State<SelectPrint> {
  bool loadingPrintBy = false;
  bool loadingPrint = false;
  List<Area> searchedAreas = [];

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final printBillDate =
          context.select((BillCubit cubit) => cubit.state.printBillDate);
      final billDate =
          context.select((BillCubit cubit) => cubit.state.billDate);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoLabel(
            label: 'Billing Period',
            child: MonthPicker(
                selectedDate: printBillDate ?? billDate,
                onSelected: (date) async {
                  context.read<BillCubit>().updatePrintBillDate(date);
                  await context.read<BillCubit>().updateBillPrintBy(null, date);
                }),
          ),
          const SizedBox(height: 30),
          InfoLabel(
            label: 'Print by',
            child: Builder(builder: (context) {
              final printBy =
                  context.select((BillCubit cubit) => cubit.state.billPrintBy);
              return ComboBox<String>(
                value: printBy?.name,
                items: AreaType.values.map((e) {
                  return ComboBoxItem<String>(
                    value: e.name,
                    child: Text(e.name.capFirst()),
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
                              AreaType.values
                                  .firstWhere((e) => e.name == value!),
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
              final printByAreas =
                  context.select((BillCubit cubit) => cubit.state.printByAreas);
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
                              'Search ${context.read<BillCubit>().state.billPrintBy?.name}s',
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
                          selected: printByAreas.length ==
                              context.select((BillCubit cubit) =>
                                  cubit.state.selectedPrintByAreas.length),
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
                .select((BillCubit cubit) => cubit.state.selectedPrintByAreas)
                .isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: FilledButton(
                onPressed: loadingPrint
                    ? null
                    : () async {
                        setState(() {
                          loadingPrint = true;
                        });
                        await context.read<BillCubit>().printSessionInfo();
                        setState(() {
                          loadingPrint = false;
                        });
                        // showPrintDialog(context, bills);
                      },
                child: Builder(builder: (context) {
                  if (loadingPrint) {
                    return const SizedBox(
                        width: 16,
                        height: 16,
                        child: mt.CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ));
                  } else {
                    return const Text('Print');
                  }
                }),
              ),
            ),
          ),
        ],
      );
    });
  }
}
