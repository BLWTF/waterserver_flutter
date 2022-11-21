part of 'meter_reading.dart';

class MeterReadingManagementMain extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  MeterReadingManagementMain({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MeterReadingCubit>().state;
    return ScaffoldPage.scrollable(
      scrollController: _scrollController,
      header: PageHeader(
        title: const Text('Meter Reading Management'),
        commandBar: CommandBar(
          overflowBehavior: CommandBarOverflowBehavior.noWrap,
          primaryItems: [
            CommandBarBuilderItem(
              builder: (context, mode, w) => Tooltip(
                message: "Create new reading",
                child: w,
              ),
              wrappedItem: CommandBarButton(
                icon: const Icon(FluentIcons.circle_addition),
                label: const Text('New'),
                onPressed: () {
                  context.read<MeterReadingCubit>().viewFormPage();
                },
              ),
            ),
            CommandBarBuilderItem(
              builder: (context, mode, w) => Tooltip(
                message: "View reading",
                child: w,
              ),
              wrappedItem: CommandBarButton(
                icon: const Icon(FluentIcons.profile_search),
                label: const Text('View'),
                onPressed: () {
                  context
                      .read<MeterReadingCubit>()
                      .pageChanged(MeterReadingManagementPage.view);
                },
              ),
            ),
          ],
        ),
      ),
      children: [
        SizedBox(
          height: 500,
          child: MeterReadingTable(
            meterReadingRepository: context.read<MeterReadingRepository>(),
            columnNames: state.columns,
            searchQuery: state.tableSearchQuery,
            onClickReading: (id) =>
                context.read<MeterReadingCubit>().viewReadingFromId(id),
            onSearch: (query) => {},
            // context.read<ContractCubit>().tableSearch(query),
          ),
        ),
      ],
    );
  }
}
