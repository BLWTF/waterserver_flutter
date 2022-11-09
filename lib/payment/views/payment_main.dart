part of 'payment.dart';

class PaymentManagementMain extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  PaymentManagementMain({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      scrollController: _scrollController,
      header: PageHeader(
        title: const Text('Payment Management'),
        commandBar: CommandBar(
          overflowBehavior: CommandBarOverflowBehavior.noWrap,
          primaryItems: [
            CommandBarBuilderItem(
                builder: (context, displayMode, w) => Tooltip(
                      message: "Enter new payment",
                      child: w,
                    ),
                wrappedItem: CommandBarButton(
                    icon: const Icon(FluentIcons.circle_addition),
                    label: const Text('New'),
                    onPressed: () {
                      context
                          .read<PaymentCubit>()
                          .pageChanged(PaymentManagementPage.form);
                    }))
          ],
        ),
      ),
      children: [
        Builder(builder: (context) {
          final state = context.watch<PaymentCubit>().state;

          return SizedBox(
            height: 500,
            child: PaymentTable(
              paymentRepository: context.read<PaymentRepository>(),
              columnNames: state.columns,
              searchQuery: state.tableSearchQuery,
              onClickPayment: (id) => print('as $id'),
              onSearch: (query) =>
                  context.read<PaymentCubit>().tableSearch(query),
            ),
          );
        })
      ],
    );
  }
}
