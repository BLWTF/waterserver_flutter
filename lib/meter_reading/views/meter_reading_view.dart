part of 'meter_reading.dart';

class MeterReadingView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  MeterReadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedReading = context
        .select((MeterReadingCubit cubit) => cubit.state.selectedReading);

    return ScaffoldPage.scrollable(
      scrollController: _scrollController,
      header: PageHeader(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Meter Reading Management'),
            Text('View'),
          ],
        ),
        commandBar: Button(
          child: const Icon(FluentIcons.back),
          onPressed: () {
            context
                .read<MeterReadingCubit>()
                .pageChanged(MeterReadingManagementPage.main);
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
                    TextEditingController(text: selectedReading?.contractNo);
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
                      .read<MeterReadingCubit>()
                      .viewReadingFromContractNo(val),
                  suffix: Button(
                    child: const Icon(FluentIcons.search),
                    onPressed: () {
                      controller.text.isNotEmpty
                          ? context
                              .read<MeterReadingCubit>()
                              .viewReadingFromContractNo(controller.text)
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
            if (selectedReading == null) {
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
                              text: selectedReading.name,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ' (${selectedReading.contractNo})',
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
                            WidgetSpan(
                              child: Icon(
                                FluentIcons.edit_contact,
                                color: Colors.blue,
                              ),
                            ),
                            TextSpan(
                              text: ' Edit Reading',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context
                                      .read<MeterReadingCubit>()
                                      .viewUpdateForm(selectedReading);
                                },
                            ),
                          ],
                          style: TextStyle(
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
                                    value: selectedReading.lastName!,
                                  ),
                                  Info(
                                    label: 'First name',
                                    value: selectedReading.firstName ?? '-',
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Contract',
                                    value: selectedReading.contractNo!,
                                  ),
                                  Info(
                                    label: 'DPC',
                                    value: selectedReading.dpc ?? '',
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Address',
                                    value: selectedReading.address!,
                                  ),
                                  Info(
                                    label: 'District',
                                    value: selectedReading.district ?? '',
                                  ),
                                ],
                              ),
                              CustomRow(
                                children: [
                                  Info(
                                    label: 'Billing Period',
                                    value:
                                        '${selectedReading.billingMonth!.toString()}-${selectedReading.billingYear!.toString()}',
                                  ),
                                  Info(
                                    label: 'Reading Date',
                                    value: selectedReading.readingDate
                                            ?.toString() ??
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
                                    label: 'Previous',
                                    value: '${selectedReading.previousReading}',
                                    labelColor: Colors.white,
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Info(
                                    label: 'Present',
                                    value: '${selectedReading.presentReading}',
                                    labelColor: Colors.white,
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              );
            }
          },
        )
      ],
    );
  }
}
