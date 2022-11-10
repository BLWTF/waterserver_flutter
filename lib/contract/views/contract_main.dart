part of 'contract.dart';

class ContractManagementMain extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  ContractManagementMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ContractCubit>().state;
    return ScaffoldPage.scrollable(
      scrollController: _scrollController,
      header: PageHeader(
        title: const Text('Contract Management'),
        commandBar: CommandBar(
          overflowBehavior: CommandBarOverflowBehavior.noWrap,
          primaryItems: [
            CommandBarBuilderItem(
              builder: (context, mode, w) => Tooltip(
                message: "Create new contract",
                child: w,
              ),
              wrappedItem: CommandBarButton(
                icon: const Icon(FluentIcons.add_friend),
                label: const Text('New'),
                onPressed: () {
                  context.read<ContractCubit>().viewNewContractPage();
                },
              ),
            ),
            CommandBarBuilderItem(
              builder: (context, mode, w) => Tooltip(
                message: "View contract",
                child: w,
              ),
              wrappedItem: CommandBarButton(
                icon: const Icon(FluentIcons.profile_search),
                label: const Text('View'),
                onPressed: () {
                  context
                      .read<ContractCubit>()
                      .pageChanged(ContractManagementPage.view);
                },
              ),
            ),
          ],
        ),
      ),
      children: <Widget>[
        SizedBox(
          height: 500,
          child: ContractTable(
            contractRepository: context.read<ContractRepository>(),
            columnNames: state.columns,
            searchQuery: state.tableSearchQuery,
            onClickContract: (id) =>
                context.read<ContractCubit>().viewContractFromId(id),
            onSearch: (query) =>
                context.read<ContractCubit>().tableSearch(query),
          ),
        ),
      ],
    );
  }
}
