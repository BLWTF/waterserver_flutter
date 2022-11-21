part of 'meter_reading.dart';

class MeterReadingManagementForm extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  MeterReadingManagementForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formState =
        context.select((MeterReadingCubit cubit) => cubit.state.formState);
    if (formState != null) {
      if (formState.billingPeriod.value == null ||
          formState.readingDate.value == null) {
        context
            .read<MeterReadingCubit>()
            .datesDefault(context.read<BillCubit>().state.currentBillDate);
      }
    }
    return ScaffoldPage.scrollable(
      scrollController: _scrollController,
      header: PageHeader(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Meter Reading Management'),
            Text('Form'),
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
                            state: formState?.contractNoDisplay,
                            onSubmit: (_) async => await context
                                .read<MeterReadingCubit>()
                                .findFormContract(),
                            suffix: IconButton(
                              icon: const Icon(FluentIcons.search),
                              onPressed: () async => await context
                                  .read<MeterReadingCubit>()
                                  .findFormContract(),
                            ),
                            onUpdate: (value) => context
                                .read<MeterReadingCubit>()
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
                              placeholder: formState?.lastName.value != null
                                  ? '${formState?.lastName.value} ${formState?.firstName.value}'
                                  : "",
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
                          child: InfoLabel(
                            label: 'Previous Reading',
                            labelStyle: FluentTheme.of(context)
                                .typography
                                .caption
                                ?.apply(fontSizeFactor: 1.0),
                            child: TextBox(
                              enabled: false,
                              placeholder:
                                  formState?.previousReading.value ?? "none",
                            ),
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 4,
                          child: CustomTextFormBox(
                            name: 'Present Reading',
                            state: formState?.presentReading,
                            onUpdate: (value) => context
                                .read<MeterReadingCubit>()
                                .presReadingUpdated(value),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: InfoLabel(
                            label: 'Read Date',
                            labelStyle: FluentTheme.of(context)
                                .typography
                                .caption
                                ?.apply(fontSizeFactor: 1.0),
                            child: DatePicker(
                              selected: formState?.readingDate.value,
                              onChanged: (value) => context
                                  .read<MeterReadingCubit>()
                                  .readingDateUpdated(value),
                            ),
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 4,
                          child: InfoLabel(
                            label: 'Bill Period',
                            labelStyle: FluentTheme.of(context)
                                .typography
                                .caption
                                ?.apply(fontSizeFactor: 1.0),
                            child: MonthPicker(
                              selectedDate: formState?.billingPeriod.value,
                              onSelected: (value) => context
                                  .read<MeterReadingCubit>()
                                  .billingPeriodUpdated(value),
                            ),
                          ),
                        ),
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

  void _submit(BuildContext context, MeterReadingFormState formState) {
    context.read<MeterReadingCubit>().readingUpdated(formState);
  }
}
