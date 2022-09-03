part of 'contract.dart';

class ContractManagementMain extends StatefulWidget {
  const ContractManagementMain({Key? key}) : super(key: key);

  @override
  State<ContractManagementMain> createState() => _ContractManagementMainState();
}

class _ContractManagementMainState extends State<ContractManagementMain> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final contractState = context.read<ContractCubit>().state;
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
          width: 500,
          child: ContractTable(
            contractRepository: context.read<ContractRepository>(),
            columnNames: contractState.columns,
            searchQuery: contractState.tableSearchQuery,
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
