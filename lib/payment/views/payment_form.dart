part of 'payment.dart';

class PaymentManagementForm extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  PaymentManagementForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formState =
        context.select((PaymentCubit cubit) => cubit.state.formState);
    if (formState?.billPeriod.value == null ||
        formState?.dateTime.value == null) {
      context
          .read<PaymentCubit>()
          .datesDefault(context.read<BillCubit>().state.currentBillDate);
    }
    return ScaffoldPage.scrollable(
      scrollController: _scrollController,
      header: PageHeader(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Payment Management'),
            Text('Form'),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextFormBox(
                            name: 'Contract No',
                            state: formState?.contractNo,
                            onSubmit: (_) async => await context
                                .read<PaymentCubit>()
                                .findFormContract(),
                            suffix: IconButton(
                              icon: const Icon(FluentIcons.search),
                              onPressed: () async => await context
                                  .read<PaymentCubit>()
                                  .findFormContract(),
                            ),
                            onUpdate: (value) => context
                                .read<PaymentCubit>()
                                .contractNoUpdated(value),
                          ),
                        ),
                        Expanded(
                          child: InfoLabel(
                            label: 'Full name',
                            labelStyle: FluentTheme.of(context)
                                .typography
                                .caption
                                ?.apply(fontSizeFactor: 1.0),
                            child: TextBox(
                              enabled: false,
                              placeholder: formState?.fullName.value ?? "",
                            ),
                          ),
                        ),
                        Expanded(
                          child: InfoLabel(
                            label: 'DPC',
                            labelStyle: FluentTheme.of(context)
                                .typography
                                .caption
                                ?.apply(fontSizeFactor: 1.0),
                            child: TextBox(
                              enabled: false,
                              placeholder: formState?.dpc.value ?? "",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: CustomTextFormBox(
                            name: 'Amount',
                            state: formState?.amount,
                            onUpdate: (value) => context
                                .read<PaymentCubit>()
                                .amountUpdated(value),
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 4,
                          child: InfoLabel(
                            label: 'Date',
                            labelStyle: FluentTheme.of(context)
                                .typography
                                .caption
                                ?.apply(fontSizeFactor: 1.0),
                            child: DatePicker(
                              selected: formState?.dateTime.value,
                              onChanged: (value) => context
                                  .read<PaymentCubit>()
                                  .dateUpdated(value),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: InfoLabel(
                          label: 'Bill Period',
                          labelStyle: FluentTheme.of(context)
                              .typography
                              .caption
                              ?.apply(fontSizeFactor: 1.0),
                          child: MonthPicker(
                            selectedDate: formState?.billPeriod.value,
                            onSelected: (value) => context
                                .read<PaymentCubit>()
                                .billingPeriodUpdated(value),
                          ),
                        )),
                        Expanded(
                          child: CustomTextFormBox(
                            name: 'Receipt no.',
                            state: formState?.receiptNo,
                            onUpdate: (value) => context
                                .read<PaymentCubit>()
                                .receiptNoUpdated(value),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FilledButton(
              onPressed: formState == null || formState.status.isInvalid
                  ? null
                  : () {
                      _submit(context, formState);
                    },
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text('Submit'),
              ),
            ),
          ],
        )
      ],
    );
  }

  void _submit(BuildContext context, PaymentFormState formState) {
    if (formState.id.pure) {
      context.read<PaymentCubit>().paymentCreated(formState);
    } else {
      // context.read<PaymentCubit>().paymentUpdated(formState);
    }
  }
}
