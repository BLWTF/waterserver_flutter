part of 'payment.dart';

class PaymentView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      scrollController: _scrollController,
      header: PageHeader(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Payment Management'),
            Text('View'),
          ],
        ),
        commandBar: Button(
          child: const Icon(FluentIcons.back),
          onPressed: () {
            context
                .read<PaymentCubit>()
                .pageChanged(PaymentManagementPage.main);
          },
        ),
      ),
      children: [
        Builder(
          builder: (context) {
            final selectedPayment = context
                .select((PaymentCubit cubit) => cubit.state.selectedPayment);
            if (selectedPayment == null) {
              return const SizedBox.shrink();
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 2,
                    child: Column(
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
                                    text:
                                        '₦${selectedPayment.amount?.format()} by ${selectedPayment.fullName}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' (${selectedPayment.contractNo})',
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
                                      color: Colors.red,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Delete',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context
                                            .read<PaymentCubit>()
                                            .deletePayment(selectedPayment.id!);
                                      },
                                  ),
                                ],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
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
                                          value: selectedPayment.fullName!,
                                        ),
                                        Info(
                                          label: 'Contract No.',
                                          value: selectedPayment.contractNo!,
                                        ),
                                        Info(
                                          label: 'DPC',
                                          value: selectedPayment.dpc!,
                                        ),
                                      ],
                                    ),
                                    CustomRow(
                                      children: [
                                        Info(
                                          label: 'Payment Date',
                                          value:
                                              selectedPayment.dateTime != null
                                                  ? selectedPayment.dateTime!
                                                      .toDateString()
                                                  : '-',
                                        ),
                                        Info(
                                          label: 'Entry Date',
                                          value:
                                              selectedPayment.entryDate != null
                                                  ? selectedPayment.entryDate!
                                                      .toDateString()
                                                  : '-',
                                        ),
                                      ],
                                    ),
                                    CustomRow(
                                      children: [
                                        Info(
                                          label: 'Receipt No.',
                                          value:
                                              selectedPayment.receiptNo ?? '-',
                                        ),
                                        Info(
                                          label: 'RCB No.',
                                          value: selectedPayment.rcbNo ?? '-',
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
                                          label: 'Amount',
                                          value:
                                              '₦${selectedPayment.amount!.format()}',
                                          labelColor: Colors.white,
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
