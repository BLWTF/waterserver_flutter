part of 'contract.dart';

class ContractView extends StatefulWidget {
  const ContractView({Key? key}) : super(key: key);

  @override
  State<ContractView> createState() => _ContractViewState();
}

class _ContractViewState extends State<ContractView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final selectedContract =
        context.select((ContractCubit cubit) => cubit.state.selectedContract);
    return ScaffoldPage.scrollable(
      scrollController: _scrollController,
      header: PageHeader(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Contract Management'),
            Text('View'),
          ],
        ),
        commandBar: Button(
          child: const Icon(FluentIcons.back),
          onPressed: () {
            context
                .read<ContractCubit>()
                .pageChanged(ContractManagementPage.main);
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
                    TextEditingController(text: selectedContract?.contractNo);
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
                  onSubmitted: (val) => context
                      .read<ContractCubit>()
                      .viewContractFromContractNo(val),
                  suffix: Button(
                    child: const Icon(FluentIcons.search),
                    onPressed: () {
                      controller.text.isNotEmpty
                          ? context
                              .read<ContractCubit>()
                              .viewContractFromContractNo(controller.text)
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
            if (selectedContract == null) {
              return const Card(
                child: Text('No Contract Selected'),
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
                              text: selectedContract.name,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ' (${selectedContract.contractNo})',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 90, 95, 97),
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const WidgetSpan(
                              child: Icon(
                                FluentIcons.edit_contact,
                                color: Colors.blue,
                              ),
                            ),
                            TextSpan(
                              text: ' Edit Contract',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context
                                      .read<ContractCubit>()
                                      .viewEditFormContract();
                                },
                            ),
                          ],
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(
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
                                    value: selectedContract.lastName!,
                                  ),
                                  Info(
                                    label: 'Middle name',
                                    value: selectedContract.middleName ?? '-',
                                  ),
                                  Info(
                                    label: 'First name',
                                    value: selectedContract.firstName ?? '-',
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Contract',
                                    value: selectedContract.contractNo!,
                                  ),
                                  Info(
                                    label: 'DPC',
                                    value: selectedContract.dpc ?? '',
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Phone',
                                    value: selectedContract.phone ?? '',
                                  ),
                                  Info(
                                    label: 'Email',
                                    value: selectedContract.email ?? '',
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Billing Address',
                                    value:
                                        selectedContract.billingAddress ?? '',
                                  ),
                                  Info(
                                    label: 'Connection Address',
                                    value: selectedContract.connectionAddress ??
                                        '',
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(),
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Tariff',
                                    value: selectedContract.tariff!,
                                  ),
                                  Info(
                                    label: 'Category',
                                    value: selectedContract.category!.name
                                        .capFirst(),
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Subcategory',
                                    value: selectedContract.subcategory!,
                                  ),
                                  Info(
                                    label: 'Volume',
                                    value:
                                        selectedContract.volume?.toString() ??
                                            '-',
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Rate',
                                    value: selectedContract.rate?.toString() ??
                                        '-',
                                  ),
                                  Info(
                                    label: 'Agreed Volume',
                                    value: selectedContract.agreedVolume
                                            ?.toString() ??
                                        '-',
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Consumption Type',
                                    value: selectedContract
                                        .consumptionType!.name
                                        .capFirst(),
                                  ),
                                ],
                              ),
                              if (selectedContract.metered!) ...[
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(),
                                ),
                                CustomRow(
                                  children: [
                                    Info(
                                      label: 'Meter No.',
                                      value: selectedContract.meterNo!,
                                    ),
                                    Info(
                                      label: 'Meter Size',
                                      value: selectedContract.meterSize!,
                                    ),
                                  ],
                                ),
                                CustomRow(
                                  children: [
                                    Info(
                                      label: 'Meter Type',
                                      value: selectedContract.meterType ?? '',
                                    ),
                                  ],
                                ),
                              ],
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(),
                              ),
                              CustomRow(
                                children: [
                                  FutureBuilder<List<District>>(
                                    future: context
                                        .read<AreaRepository>()
                                        .getDistricts(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          selectedContract.district
                                              .toString()
                                              .isNotEmpty) {
                                        final district = snapshot.data!
                                            .firstWhere((el) =>
                                                el.code ==
                                                selectedContract.district!
                                                    .trim());
                                        return Info(
                                          label: 'District',
                                          value: district.toString(),
                                        );
                                      }
                                      return Info(
                                        label: 'District',
                                        value: selectedContract.district!,
                                      );
                                    },
                                  ),
                                  Info(
                                    label: 'Zone',
                                    value: selectedContract.zone!,
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Subzone',
                                    value: selectedContract.subzone!,
                                  ),
                                  Info(
                                    label: 'Round',
                                    value: selectedContract.round!,
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Folio',
                                    value: selectedContract.folio ?? '',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // const Flexible(
                      //   flex: 2,
                      //   child: SizedBox(),
                      // )
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
