part of 'contract.dart';

class ContractManagementForm extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  ContractManagementForm({Key? key}) : super(key: key);

  void _submit(BuildContext context, ContractFormState formState) {
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextFormBox(
                            name: 'Last name',
                            state: formState?.lastName,
                            onUpdate: (value) => context
                                .read<ContractCubit>()
                                .lastNameUpdated(value),
                          ),
                        ),
                        Expanded(
                          child: CustomTextFormBox(
                            name: 'Middle name',
                            state: formState?.middleName,
                            onUpdate: (value) => context
                                .read<ContractCubit>()
                                .middleNameUpdated(value),
                          ),
                        ),
                        Expanded(
                          child: CustomTextFormBox(
                            name: 'First name',
                            state: formState?.firstName,
                            onUpdate: (value) => context
                                .read<ContractCubit>()
                                .firstNameUpdated(value),
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
                          child: CustomTextFormBox(
                            name: 'Connection Address',
                            state: formState?.connectionAddress,
                            suffix: IconButton(
                              icon:
                                  const Icon(FluentIcons.insert_columns_right),
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
                          child: CustomTextFormBox(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextFormBox(
                            name: 'Phone',
                            state: formState?.phone,
                            onUpdate: (value) => context
                                .read<ContractCubit>()
                                .phoneUpdated(value),
                          ),
                        ),
                        Expanded(
                          child: CustomTextFormBox(
                            name: 'Email',
                            state: formState?.email,
                            onUpdate: (value) => context
                                .read<ContractCubit>()
                                .emailUpdated(value),
                          ),
                        ),
                      ],
                    ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: FutureBuilder<List<Tariff>>(
                            future:
                                context.read<TariffRepository>().getTariffs(),
                            builder: (context, snapshot) {
                              List items = [];
                              List tariffs = [];
                              String? value;
                              if (snapshot.hasData) {
                                items = snapshot.data!
                                    .map((tariff) => tariff.name)
                                    .toList();
                                tariffs = snapshot.data!;
                                value =
                                    formState?.tariff.value.isNotEmpty == true
                                        ? formState?.tariff.value
                                        : value;
                              }
                              return Container(
                                color: formState?.tariff.invalid == true
                                    ? Colors.red
                                    : null,
                                child: InfoLabel(
                                  label: 'Tariff',
                                  labelStyle: FluentTheme.of(context)
                                      .typography
                                      .caption
                                      ?.apply(fontSizeFactor: 1.0),
                                  child: ComboBox<String>(
                                    isExpanded: true,
                                    placeholder: const Text('Tariffs'),
                                    value: value,
                                    items: items
                                        .map((item) => ComboBoxItem<String>(
                                              value: item,
                                              child: Text(item),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      context
                                          .read<ContractCubit>()
                                          .tariffUpdated(tariffs.firstWhere(
                                              (tariff) =>
                                                  tariff.name == value));
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
                              placeholder:
                                  formState?.subcategory.value ?? "none",
                            ),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
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
                    ),
                  )
                ],
              ),
            ),
            if (formState?.consumptionType.value!.toLowerCase() == 'metered')
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
                          child: CustomTextFormBox(
                            name: 'Meter No.',
                            state: formState?.meterNo,
                            onUpdate: (value) => context
                                .read<ContractCubit>()
                                .meterNoUpdated(value),
                          ),
                        ),
                        Expanded(
                          child: _FutureSuggestBox(
                            future: context
                                .read<ContractRepository>()
                                .getMeterSizes(),
                            value: formState?.meterSize.value,
                            label: 'Meter Size',
                            onUpdate: (text) => context
                                .read<ContractCubit>()
                                .meterSizeUpdated(text),
                          ),
                        ),
                        Expanded(
                          child: _FutureSuggestBox(
                            future: context
                                .read<ContractRepository>()
                                .getMeterTypes(),
                            value: formState?.meterType.value,
                            label: 'Meter Type',
                            onUpdate: (text) => context
                                .read<ContractCubit>()
                                .meterTypeUpdated(text),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: FutureBuilder<List<District>>(
                            future:
                                context.read<AreaRepository>().getDistricts(),
                            builder: (context, snapshot) {
                              List? items;
                              List districts = [];
                              if (snapshot.hasData) {
                                items = snapshot.data!
                                    .map((district) => district.code)
                                    .toList();
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
                                child: InfoLabel(
                                  label: 'District',
                                  labelStyle: FluentTheme.of(context)
                                      .typography
                                      .caption
                                      ?.apply(fontSizeFactor: 1.0),
                                  child: ComboBox<String>(
                                    isExpanded: true,
                                    placeholder: const Text('Districts'),
                                    value: formState?.district.value,
                                    items: items
                                        ?.map((item) => ComboBoxItem<String>(
                                              value: item,
                                              child: Text(
                                                '$item (${districtLookup[item]})',
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        context
                                            .read<ContractCubit>()
                                            .districtUpdated(value);
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
                                  placeholder: 'Zones: None',
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

                                  List items = [];
                                  List zones = [];
                                  String value = 'none';

                                  if (snapshot.hasData) {
                                    items = snapshot.data!
                                        .map((zone) => zone.code)
                                        .toList();
                                    zones = snapshot.data!;

                                    // in case zone is nonexistent
                                    if (items.contains(formState.zone.value)) {
                                      value = formState.zone.value;
                                    } else if (formState
                                        .zone.value.isNotEmpty) {
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
                                                    MapEntry(
                                                        el.code.toString(),
                                                        el.description
                                                            .toString())
                                                  ]).toList());
                                  return Container(
                                    color: formState.zone.invalid
                                        ? Colors.red
                                        : null,
                                    padding: const EdgeInsets.all(1),
                                    child: ComboBox<String>(
                                      isExpanded: true,
                                      placeholder: const Text('Zones'),
                                      value: value,
                                      items: items
                                          .map((item) => ComboBoxItem<String>(
                                                value: item,
                                                child: Text(
                                                    '$item (${zoneLookup[item]})'),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          context
                                              .read<ContractCubit>()
                                              .zoneUpdated(value);
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
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
                                  placeholder: 'Subzones: None',
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
                                  List items = [];
                                  List subzones = [];
                                  String? value;
                                  if (snapshot.hasData) {
                                    items = snapshot.data!
                                        .map((subzone) => subzone.code)
                                        .toList();
                                    subzones = snapshot.data!;

                                    // in case subzone is nonexistent
                                    if (items
                                        .contains(formState.subzone.value)) {
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
                                      isExpanded: true,
                                      placeholder: const Text('Subzones'),
                                      value: value,
                                      items: items
                                          .map((item) => ComboBoxItem<String>(
                                                value: item,
                                                child: Text(
                                                    '$item (${subzoneLookup[item]})'),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          context
                                              .read<ContractCubit>()
                                              .subzoneUpdated(value);
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
                                  List items = [];
                                  List rounds = [];
                                  String? value;
                                  if (snapshot.hasData) {
                                    items = snapshot.data!
                                        .map((round) => round.code)
                                        .toList();
                                    rounds = snapshot.data!;

                                    // in case round is nonexistent
                                    if (items.contains(formState.round.value)) {
                                      value = formState.round.value;
                                    } else if (formState
                                        .round.value.isNotEmpty) {
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
                                      isExpanded: true,
                                      placeholder: const Text('Rounds'),
                                      value: value,
                                      items: items
                                          .map((item) => ComboBoxItem<String>(
                                                value: item,
                                                child: Text(
                                                    '$item (${roundLookup[item]})'),
                                              ))
                                          .toList(),
                                      onChanged: (value) async {
                                        if (value != null) {
                                          await context
                                              .read<ContractCubit>()
                                              .roundUpdated(value);
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
                  ),
                  Visibility(
                    visible: formState?.round.value.isNotEmpty ?? false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextFormBox(
                            name: 'Folio',
                            state: formState?.folio,
                            onUpdate: (value) => context
                                .read<ContractCubit>()
                                .folioUpdated(value),
                          ),
                        ),
                        const Spacer(flex: 2),
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
}

class _FutureSuggestBox extends StatefulWidget {
  final Future<List> future;
  final String? value;
  final String label;
  final Function(String) onUpdate;

  const _FutureSuggestBox({
    super.key,
    required this.future,
    required this.value,
    required this.label,
    required this.onUpdate,
  });

  @override
  State<_FutureSuggestBox> createState() => __FutureSuggestBoxState();
}

class __FutureSuggestBoxState extends State<_FutureSuggestBox> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value)
      ..addListener(_listener);
  }

  void _listener() {
    widget.onUpdate(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: widget.future,
      builder: (context, snapshot) {
        List items = [];
        if (snapshot.hasData) {
          items = snapshot.data!.map((e) => e.toString()).toList();
        }
        return InfoLabel(
          label: widget.label,
          labelStyle: FluentTheme.of(context)
              .typography
              .caption
              ?.apply(fontSizeFactor: 1.0),
          child: AutoSuggestBox(
            placeholder: '${widget.label}s',
            controller: _controller,
            items: items
                .map((e) => AutoSuggestBoxItem(
                    value: e.toString(), label: e.toString()))
                .toList(),
          ),
        );
      },
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
