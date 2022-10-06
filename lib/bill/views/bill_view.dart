part of 'bill.dart';

class BillView extends StatefulWidget {
  const BillView({Key? key}) : super(key: key);

  @override
  State<BillView> createState() => _BillViewState();
}

class _BillViewState extends State<BillView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final selectedBill =
        context.select((BillCubit cubit) => cubit.state.selectedBill);
    return ScaffoldPage.scrollable(
      scrollController: _scrollController,
      header: PageHeader(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Bill Management'),
            Text('View'),
          ],
        ),
        commandBar: Button(
          child: const Icon(FluentIcons.back),
          onPressed: () {
            context.read<BillCubit>().pageChanged(BillManagementPage.main);
          },
        ),
      ),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.loose,
              flex: 2,
              child: Builder(builder: (context) {
                final controller =
                    TextEditingController(text: selectedBill?.contractNo);
                return TextBox(
                  outsidePrefix: Text(
                    'Contract No: ',
                    style: FluentTheme.of(context)
                        .typography
                        .caption
                        ?.apply(fontSizeFactor: 1.0),
                  ),
                  controller: controller,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (val) =>
                      context.read<BillCubit>().viewBillFromContractNo(val),
                  suffix: Button(
                    child: const Icon(FluentIcons.search),
                    onPressed: () {
                      controller.text.isNotEmpty
                          ? context
                              .read<BillCubit>()
                              .viewBillFromContractNo(controller.text)
                          : null;
                    },
                  ),
                );
              }),
            ),
            const Flexible(
              fit: FlexFit.loose,
              flex: 4,
              child: SizedBox(),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(),
        ),
        Builder(
          builder: (context) {
            if (selectedBill == null) {
              return const Card(
                child: Text('No Bill Selected'),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: selectedBill.name,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ' (${selectedBill.contractNo})',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 90, 95, 97),
                              ),
                            ),
                          ],
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                FluentPageRoute(builder: (context) {
                              return SingleBillPrintPreview(bill: selectedBill);
                            }));
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    FluentIcons.print,
                                    color: Colors.blue,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' Print Bill',
                                ),
                              ],
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Card(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Last name',
                                    value: selectedBill.lastName!,
                                  ),
                                  Info(
                                    label: 'Middle name',
                                    value: selectedBill.middleName ?? '-',
                                  ),
                                  Info(
                                    label: 'First name',
                                    value: selectedBill.firstName ?? '-',
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Contract',
                                    value: selectedBill.contractNo!,
                                  ),
                                  Info(
                                    label: 'DPC',
                                    value: selectedBill.dpc ?? '',
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Tariff',
                                    value: selectedBill.tariff!,
                                  ),
                                  Info(
                                    label: 'Category',
                                    value:
                                        selectedBill.category!.name.capFirst(),
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Subcategory',
                                    value: selectedBill.subcategory!,
                                  ),
                                  Info(
                                    label: 'Volume',
                                    value:
                                        selectedBill.volume?.toString() ?? '-',
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Rate',
                                    value: selectedBill.rate?.toString() ?? '-',
                                  ),
                                  Info(
                                    label: 'Agreed Volume',
                                    value:
                                        selectedBill.agreedVolume?.toString() ??
                                            '-',
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Consumption Type',
                                    value: selectedBill.consumptionType?.name
                                            .capFirst() ??
                                        '',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              backgroundColor:
                                  const Color.fromARGB(255, 68, 140, 171),
                              child: CustomRow(
                                children: [
                                  Info(
                                    label: 'Opening Balance',
                                    value:
                                        '₦${selectedBill.openingBalance!.format()}',
                                    labelColor: Colors.white,
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Info(
                                    label: 'Closing Balance',
                                    value:
                                        '₦${selectedBill.closingBalance!.format()}',
                                    labelColor: Colors.white,
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Card(
                              backgroundColor: Colors.white,
                              child: Column(
                                children: [
                                  InfoLabel(
                                    label: 'Bill Date',
                                    labelStyle: FluentTheme.of(context)
                                        .typography
                                        .caption
                                        ?.apply(fontSizeFactor: 1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: MonthPicker(
                                        selectedDate: selectedBill.monthEnd!,
                                        onSelected: (value) => context
                                            .read<BillCubit>()
                                            .viewBillFromContractNo(
                                              selectedBill.contractNo!,
                                              value,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              );
            }
          },
        )
      ],
    );
  }
}
