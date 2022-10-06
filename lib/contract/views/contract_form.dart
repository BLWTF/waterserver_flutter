part of 'contract.dart';

class ContractManagementForm extends StatefulWidget {
  const ContractManagementForm({Key? key}) : super(key: key);

  @override
  State<ContractManagementForm> createState() => _ContractManagementFormState();
}

class _ContractManagementFormState extends State<ContractManagementForm> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void _submit(ContractFormState formState) {
    if (formState.id.pure) {
      context.read<ContractCubit>().contractCreated(formState);
    } else {
      context.read<ContractCubit>().contractUpdated(formState);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState =
        context.select((ContractCubit cubit) => cubit.state.formState);
    return ScaffoldPage.scrollable(
      scrollController: _scrollController,
      header: PageHeader(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Contract Management'),
            Text('Form'),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextBox(
                          name: 'Last name',
                          state: formState?.lastName,
                          onUpdate: (value) => context
                              .read<ContractCubit>()
                              .lastNameUpdated(value),
                        ),
                      ),
                      Expanded(
                        child: CustomTextBox(
                          name: 'Middle name',
                          state: formState?.middleName,
                          onUpdate: (value) => context
                              .read<ContractCubit>()
                              .middleNameUpdated(value),
                        ),
                      ),
                      Expanded(
                        child: CustomTextBox(
                          name: 'First name',
                          state: formState?.firstName,
                          onUpdate: (value) => context
                              .read<ContractCubit>()
                              .firstNameUpdated(value),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextBox(
                          name: 'Connection Address',
                          state: formState?.connectionAddress,
                          suffix: IconButton(
                            icon: const Icon(FluentIcons.insert_columns_right),
                            onPressed: () =>
                                context.read<ContractCubit>().copyAddresses(),
                          ),
                          multiline: true,
                          onUpdate: (value) => context
                              .read<ContractCubit>()
                              .connectionAddressUpdated(value),
                        ),
                      ),
                      Expanded(
                        child: CustomTextBox(
                          name: 'Billing Address',
                          state: formState?.billingAddress,
                          multiline: true,
                          onUpdate: (value) => context
                              .read<ContractCubit>()
                              .billingAddressUpdated(value),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextBox(
                          name: 'Phone',
                          state: formState?.phone,
                          onUpdate: (value) =>
                              context.read<ContractCubit>().phoneUpdated(value),
                        ),
                      ),
                      Expanded(
                        child: CustomTextBox(
                          name: 'Email',
                          state: formState?.email,
                          onUpdate: (value) =>
                              context.read<ContractCubit>().emailUpdated(value),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tariff and Billing',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: FutureBuilder<List<Tariff>>(
                          future: context.read<TariffRepository>().getTariffs(),
                          builder: (context, snapshot) {
                            List items = ['none'];
                            List tariffs = [];
                            String? value = 'none';
                            if (snapshot.hasData) {
                              items = snapshot.data!
                                  .map((tariff) => tariff.name)
                                  .toList()
                                ..add('none');
                              tariffs = snapshot.data!;
                              value = formState?.tariff.value.isNotEmpty == true
                                  ? formState?.tariff.value
                                  : value;
                              // if (value != 'none') {
                              //   context.read<ContractCubit>().tariffUpdated(
                              //       tariffs.firstWhere(
                              //           (tariff) => tariff.name == value));
                              // }
                            }
                            return Container(
                              color: formState?.tariff.invalid == true
                                  ? Colors.red
                                  : null,
                              padding: const EdgeInsets.all(1),
                              child: InfoLabel(
                                label: 'Tariff',
                                labelStyle: FluentTheme.of(context)
                                    .typography
                                    .caption
                                    ?.apply(fontSizeFactor: 1.0),
                                child: ComboBox<String>(
                                  placeholder: const Text('Tariffs'),
                                  value: value,
                                  items: items
                                      .map((item) => ComboBoxItem<String>(
                                            value: item,
                                            child: Text(item),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    context.read<ContractCubit>().tariffUpdated(
                                        tariffs.firstWhere(
                                            (tariff) => tariff.name == value));
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InfoLabel(
                          label: 'Category',
                          labelStyle: FluentTheme.of(context)
                              .typography
                              .caption
                              ?.apply(fontSizeFactor: 1.0),
                          child: TextBox(
                            enabled: false,
                            placeholder: formState?.category.value ?? "none",
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InfoLabel(
                          label: 'Subcategory',
                          labelStyle: FluentTheme.of(context)
                              .typography
                              .caption
                              ?.apply(fontSizeFactor: 1.0),
                          child: TextBox(
                            enabled: false,
                            placeholder: formState?.subcategory.value ?? "none",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: InfoLabel(
                          label: 'Volume',
                          labelStyle: FluentTheme.of(context)
                              .typography
                              .caption
                              ?.apply(fontSizeFactor: 1.0),
                          child: TextBox(
                            enabled: false,
                            placeholder:
                                formState?.volume.value.toString() ?? "none",
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InfoLabel(
                          label: 'Limit',
                          labelStyle: FluentTheme.of(context)
                              .typography
                              .caption
                              ?.apply(fontSizeFactor: 1.0),
                          child: TextBox(
                            enabled: false,
                            placeholder:
                                formState?.limit.value.toString() ?? "none",
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InfoLabel(
                          label: 'Rate',
                          labelStyle: FluentTheme.of(context)
                              .typography
                              .caption
                              ?.apply(fontSizeFactor: 1.0),
                          child: TextBox(
                            enabled: false,
                            placeholder:
                                formState?.rate.value.toString() ?? "none",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: InfoLabel(
                          label: 'Agreed Volume',
                          labelStyle: FluentTheme.of(context)
                              .typography
                              .caption
                              ?.apply(fontSizeFactor: 1.0),
                          child: TextBox(
                            enabled: false,
                            placeholder:
                                formState?.agreedVolume.value.toString() ??
                                    "none",
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InfoLabel(
                          label: 'Consumption Type',
                          labelStyle: FluentTheme.of(context)
                              .typography
                              .caption
                              ?.apply(fontSizeFactor: 1.0),
                          child: TextBox(
                            enabled: false,
                            placeholder:
                                formState?.consumptionType.value ?? "none",
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            if (formState?.consumptionType.value!.toLowerCase() ==
                'metered') ...[
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Meter',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: CustomTextBox(
                              name: 'Meter No.',
                              state: formState?.meterNo,
                              onUpdate: (value) => context
                                  .read<ContractCubit>()
                                  .meterNoUpdated(value),
                            ),
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder<List>(
                            future: context
                                .read<ContractRepository>()
                                .getMeterSizes(),
                            builder: (context, snapshot) {
                              final controller = TextEditingController(
                                  text: formState?.meterSize.value);
                              List items = [];
                              if (snapshot.hasData) {
                                items = snapshot.data!
                                    .map((e) => e.toString())
                                    .toList();
                              }
                              return InfoLabel(
                                label: 'Meter Size',
                                labelStyle: FluentTheme.of(context)
                                    .typography
                                    .caption
                                    ?.apply(fontSizeFactor: 1.0),
                                child: AutoSuggestBox(
                                  placeholder: 'Meter Sizes',
                                  controller: controller,
                                  onChanged: (text, reason) => context
                                      .read<ContractCubit>()
                                      .meterSizeUpdated(text),
                                  items: items
                                      .map((e) => AutoSuggestBoxItem(
                                          value: e.toString(),
                                          label: e.toString()))
                                      .toList(),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder<List>(
                            future: context
                                .read<ContractRepository>()
                                .getMeterTypes(),
                            builder: (context, snapshot) {
                              final controller = TextEditingController(
                                  text: formState?.meterType.value);
                              List items = [];
                              if (snapshot.hasData) {
                                items = snapshot.data!
                                    .map((e) => e.toString())
                                    .toList();
                              }
                              return InfoLabel(
                                label: 'Meter Types',
                                labelStyle: FluentTheme.of(context)
                                    .typography
                                    .caption
                                    ?.apply(fontSizeFactor: 1.0),
                                child: AutoSuggestBox(
                                  placeholder: 'Meter Types',
                                  controller: controller,
                                  onChanged: (text, reason) => context
                                      .read<ContractCubit>()
                                      .meterTypeUpdated(text),
                                  items: items
                                      .map((e) => AutoSuggestBoxItem(
                                          value: e.toString(),
                                          label: e.toString()))
                                      .toList(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Area',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: FutureBuilder<List<District>>(
                          future: context.read<AreaRepository>().getDistricts(),
                          builder: (context, snapshot) {
                            List items = ['none'];
                            List districts = [];
                            if (snapshot.hasData) {
                              items = snapshot.data!
                                  .map((district) => district.code)
                                  .toList()
                                ..add('none');
                              districts = snapshot.data!;
                            }
                            Map<String, String> districtLookup =
                                Map.fromEntries(districts
                                    .fold<List<MapEntry<String, String>>>(
                                        [],
                                        (prev, el) => [
                                              ...prev,
                                              MapEntry(el.code.toString(),
                                                  el.description.toString())
                                            ]).toList());
                            return Container(
                              color: formState?.district.invalid == true
                                  ? Colors.red
                                  : null,
                              padding: const EdgeInsets.all(1),
                              child: InfoLabel(
                                label: 'District',
                                labelStyle: FluentTheme.of(context)
                                    .typography
                                    .caption
                                    ?.apply(fontSizeFactor: 1.0),
                                child: ComboBox<String>(
                                  placeholder: const Text('districts'),
                                  value:
                                      items.contains(formState?.district.value)
                                          ? formState?.district.value
                                          : 'none',
                                  items: items
                                      .map((item) => ComboBoxItem<String>(
                                            value: item,
                                            child: item == 'none'
                                                ? Text(item)
                                                : Text(
                                                    '$item (${districtLookup[item]})'),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != 'none') {
                                      context
                                          .read<ContractCubit>()
                                          .districtUpdated(value!);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InfoLabel(
                          label: 'Zone',
                          labelStyle: FluentTheme.of(context)
                              .typography
                              .caption
                              ?.apply(fontSizeFactor: 1.0),
                          child: Builder(builder: (context) {
                            if (formState?.district.value == null ||
                                formState?.district.value.isEmpty == true) {
                              return const TextBox(
                                enabled: false,
                                placeholder: 'Zone: none',
                              );
                            }
                            return FutureBuilder<List<Zone>>(
                              future: context
                                  .read<AreaRepository>()
                                  .getZones(formState!.district.value),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('Loading...');
                                }

                                List items = ['none'];
                                List zones = [];
                                String value = 'none';

                                if (snapshot.hasData) {
                                  items = snapshot.data!
                                      .map((zone) => zone.code)
                                      .toList()
                                    ..add('none');
                                  zones = snapshot.data!;

                                  // in case zone is nonexistent
                                  if (items.contains(formState.zone.value)) {
                                    value = formState.zone.value;
                                  } else if (formState.zone.value.isNotEmpty) {
                                    items.add(formState.zone.value
                                        .getAreaCode(AreaType.zone)!);
                                    value = formState.zone.value
                                        .getAreaCode(AreaType.zone)!;
                                  }
                                }
                                Map<String, String> zoneLookup =
                                    Map.fromEntries(zones
                                        .fold<List<MapEntry<String, String>>>(
                                            [],
                                            (prev, el) => [
                                                  ...prev,
                                                  MapEntry(el.code.toString(),
                                                      el.description.toString())
                                                ]).toList());
                                return Container(
                                  color: formState.zone.invalid
                                      ? Colors.red
                                      : null,
                                  padding: const EdgeInsets.all(1),
                                  child: ComboBox<String>(
                                    placeholder: const Text('zones'),
                                    value: value,
                                    items: items
                                        .map((item) => ComboBoxItem<String>(
                                              value: item,
                                              child: item == 'none'
                                                  ? Text(item)
                                                  : Text(
                                                      '$item (${zoneLookup[item]})'),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      if (value != 'none') {
                                        context
                                            .read<ContractCubit>()
                                            .zoneUpdated(value!);
                                      }
                                    },
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: InfoLabel(
                          label: 'Subzone',
                          labelStyle: FluentTheme.of(context)
                              .typography
                              .caption
                              ?.apply(fontSizeFactor: 1.0),
                          child: Builder(builder: (context) {
                            if (formState?.district.value == null ||
                                formState?.zone.value == null ||
                                formState?.district.value.isEmpty == true ||
                                formState?.zone.value.isEmpty == true) {
                              return const TextBox(
                                enabled: false,
                                placeholder: 'Subzone: none',
                              );
                            }
                            return FutureBuilder<List<Subzone>>(
                              future: context
                                  .read<AreaRepository>()
                                  .getSubzones(formState!.zone.value),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('Loading...');
                                }
                                List items = ['none'];
                                List subzones = [];
                                String value = 'none';
                                if (snapshot.hasData) {
                                  items = snapshot.data!
                                      .map((subzone) => subzone.code)
                                      .toList()
                                    ..add('none');
                                  subzones = snapshot.data!;

                                  // in case subzone is nonexistent
                                  if (items.contains(formState.subzone.value)) {
                                    value = formState.subzone.value;
                                  } else if (formState
                                      .subzone.value.isNotEmpty) {
                                    items.add(formState.subzone.value
                                        .getAreaCode(AreaType.subzone)!);
                                    value = formState.subzone.value
                                        .getAreaCode(AreaType.subzone)!;
                                  }
                                }
                                Map<String, String> subzoneLookup =
                                    Map.fromEntries(subzones
                                        .fold<List<MapEntry<String, String>>>(
                                            [],
                                            (prev, el) => [
                                                  ...prev,
                                                  MapEntry(
                                                    el.code.toString(),
                                                    el.description.toString(),
                                                  )
                                                ]).toList());
                                return Container(
                                  color: formState.subzone.invalid
                                      ? Colors.red
                                      : null,
                                  padding: const EdgeInsets.all(1),
                                  child: ComboBox<String>(
                                    placeholder: const Text('subzones'),
                                    value: value,
                                    items: items
                                        .map((item) => ComboBoxItem<String>(
                                              value: item,
                                              child: item == 'none'
                                                  ? Text(item)
                                                  : Text(
                                                      '$item (${subzoneLookup[item]})'),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      if (value != 'none') {
                                        context
                                            .read<ContractCubit>()
                                            .subzoneUpdated(value!);
                                      }
                                    },
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InfoLabel(
                          label: 'Round',
                          labelStyle: FluentTheme.of(context)
                              .typography
                              .caption
                              ?.apply(fontSizeFactor: 1.0),
                          child: Builder(builder: (context) {
                            if (formState?.district.value == null ||
                                formState?.zone.value == null ||
                                formState?.subzone.value == null ||
                                formState?.district.value.isEmpty == true ||
                                formState?.zone.value.isEmpty == true ||
                                formState?.subzone.value.isEmpty == true) {
                              return const TextBox(
                                enabled: false,
                                placeholder: 'Round: none',
                              );
                            }
                            return FutureBuilder<List<Round>>(
                              future: context
                                  .read<AreaRepository>()
                                  .getRounds(formState!.subzone.value),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('Loading...');
                                }
                                List items = ['none'];
                                List rounds = [];
                                String value = 'none';
                                if (snapshot.hasData) {
                                  items = snapshot.data!
                                      .map((round) => round.code)
                                      .toList()
                                    ..add('none');
                                  rounds = snapshot.data!;

                                  // in case round is nonexistent
                                  if (items.contains(formState.round.value)) {
                                    value = formState.round.value;
                                  } else if (formState.round.value.isNotEmpty) {
                                    items.add(formState.round.value
                                        .getAreaCode(AreaType.round)!);
                                    value = formState.round.value
                                        .getAreaCode(AreaType.round)!;
                                  }
                                }
                                Map<String, String> roundLookup =
                                    Map.fromEntries(rounds
                                        .fold<List<MapEntry<String, String>>>(
                                            [],
                                            (prev, el) => [
                                                  ...prev,
                                                  MapEntry(
                                                    el.code.toString(),
                                                    el.description.toString(),
                                                  )
                                                ]).toList());
                                return Container(
                                  color: formState.round.invalid
                                      ? Colors.red
                                      : null,
                                  padding: const EdgeInsets.all(1),
                                  child: ComboBox<String>(
                                    placeholder: const Text('rounds'),
                                    value: value,
                                    items: items
                                        .map((item) => ComboBoxItem<String>(
                                              value: item,
                                              child: item == 'none'
                                                  ? Text(item)
                                                  : Text(
                                                      '$item (${roundLookup[item]})'),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      if (value != 'none') {
                                        context
                                            .read<ContractCubit>()
                                            .roundUpdated(value!);
                                      }
                                    },
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  )
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
                      _submit(formState);
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
}

class CustomTextBox extends StatefulWidget {
  final String name;
  final FormzInput? state;
  final Function(String) onUpdate;
  final bool multiline;
  final TextInputType? inputType;
  final Widget? suffix;

  const CustomTextBox({
    Key? key,
    required this.name,
    this.state,
    required this.onUpdate,
    this.multiline = false,
    this.inputType,
    this.suffix,
  }) : super(key: key);

  @override
  State<CustomTextBox> createState() => _CustomTextBoxState();
}

class _CustomTextBoxState extends State<CustomTextBox> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.state?.value)
      ..addListener(_listener);
  }

  void _listener() {
    widget.onUpdate(_textEditingController.text);
  }

  @override
  void didUpdateWidget(covariant CustomTextBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    final String? value = widget.state?.value;
    _textEditingController.text = value ?? '';
    if (value != null) {
      _textEditingController.selection = TextSelection(
        baseOffset: value.length,
        extentOffset: value.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormBox(
      suffix: widget.suffix,
      header: widget.name.capFirst(),
      headerStyle: FluentTheme.of(context)
          .typography
          .caption
          ?.apply(fontSizeFactor: 1.0),
      placeholder: widget.name.capFirst(),
      controller: _textEditingController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: widget.multiline ? null : 1,
      validator: (text) => !widget.state!.pure && widget.state!.invalid
          ? 'Provide valid ${widget.name}'
          : null,
    );
  }
}

extension IsEmptyOrNull on String? {
  bool isEmptyOrNull() {
    if (this == null) {
      return true;
    }

    return this!.isEmpty;
  }
}
