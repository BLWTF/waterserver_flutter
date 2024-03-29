part of 'bill.dart';

class BillManagementMain extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  BillManagementMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billState = context.watch<BillCubit>().state;
    return StreamBuilder<DateTime?>(
      stream: context.read<BillCubit>().billDate,
      builder: (context, snapshot) {
        late final DateTime? billDate;
        if (snapshot.hasData) {
          billDate = snapshot.data;
        } else {
          billDate = billState.billDate;
        }
        return ScaffoldPage.scrollable(
          scrollController: _scrollController,
          header: PageHeader(
            title: const Text('Bill Management'),
            commandBar: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Row(
                    children: [
                      if (billState.billDate != billState.currentBillDate) ...[
                        Tooltip(
                          message: 'Reset to current bill date',
                          child: IconButton(
                            icon: const Icon(FluentIcons.refresh),
                            onPressed: () =>
                                context.read<BillCubit>().billDateReset(),
                          ),
                        )
                      ],
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 200,
                          child: Builder(builder: (context) {
                            if (billDate == null) {
                              return const Text('Loading...');
                            }
                            return MonthPicker(
                                selectedDate: billDate,
                                onSelected: (dateTime) => context
                                    .read<BillCubit>()
                                    .billDateChanged(dateTime));
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                CommandBar(
                  overflowBehavior: CommandBarOverflowBehavior.noWrap,
                  primaryItems: [
                    CommandBarBuilderItem(
                      builder: (context, mode, w) => Tooltip(
                        message: "Select for printing",
                        child: w,
                      ),
                      wrappedItem: CommandBarButton(
                        icon: const Icon(FluentIcons.print),
                        label: const Text('Print'),
                        onPressed: () => context
                            .read<BillCubit>()
                            .pageChanged(BillManagementPage.print),
                      ),
                    ),
                    CommandBarBuilderItem(
                      builder: (context, mode, w) => Tooltip(
                        message: "Search & view by contract no.",
                        child: w,
                      ),
                      wrappedItem: CommandBarButton(
                        icon: const Icon(FluentIcons.search),
                        label: const Text('View'),
                        onPressed: () => context
                            .read<BillCubit>()
                            .pageChanged(BillManagementPage.view),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          children: <Widget>[
            if (billDate != null) ...[
              SizedBox(
                height: 500,
                child: BillTable(
                  billRepository: context.read<BillRepository>(),
                  columnNames: billState.columns,
                  searchQuery: billState.tableSearchQuery,
                  currentDate: billDate,
                  onClickBill: (id) {
                    context.read<BillCubit>().viewBillFromId(id);
                  },
                  onSearch: (query) {
                    context.read<BillCubit>().tableSearch(query);
                  },
                ),
              )
            ],
          ],
        );
      },
    );
  }
}
