part of 'settings.dart';

class SettingsMysql extends StatelessWidget {
  final MysqlSettings mysqlSettings;
  const SettingsMysql({
    Key? key,
    required this.mysqlSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsMysqlForm(mysqlSettings: mysqlSettings);
  }
}

class SettingsMysqlForm extends StatefulWidget {
  final MysqlSettings mysqlSettings;
  final bool standAlone;

  const SettingsMysqlForm({
    super.key,
    required this.mysqlSettings,
    this.standAlone = false,
  });

  @override
  State<SettingsMysqlForm> createState() => _SettingsMysqlFormState();
}

class _SettingsMysqlFormState extends State<SettingsMysqlForm> {
  late final TextEditingController hostController;
  late final TextEditingController portController;
  late final TextEditingController userController;
  late final TextEditingController passwordController;
  late final TextEditingController databaseController;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    hostController = TextEditingController(text: widget.mysqlSettings.host)
      ..addListener(_onUpdateHost);
    portController = TextEditingController(
        text: widget.mysqlSettings.port == null
            ? ''
            : widget.mysqlSettings.port.toString())
      ..addListener(_onUpdatePort);
    userController = TextEditingController(text: widget.mysqlSettings.user)
      ..addListener(_onUpdateUser);
    passwordController =
        TextEditingController(text: widget.mysqlSettings.password)
          ..addListener(_onUpdatePassword);
    databaseController =
        TextEditingController(text: widget.mysqlSettings.database)
          ..addListener(_onUpdateDatabase);
  }

  @override
  void dispose() {
    scrollController.dispose();
    hostController.dispose();
    portController.dispose();
    userController.dispose();
    passwordController.dispose();
    databaseController.dispose();
    super.dispose();
  }

  void _onUpdateHost() {
    context.read<SettingsCubit>().hostUpdated(hostController.text);
  }

  void _onUpdatePort() {
    context.read<SettingsCubit>().portUpdated(portController.text);
  }

  void _onUpdateUser() {
    context.read<SettingsCubit>().userUpdated(userController.text);
  }

  void _onUpdatePassword() {
    context.read<SettingsCubit>().passwordUpdated(passwordController.text);
  }

  void _onUpdateDatabase() {
    context.read<SettingsCubit>().databaseUpdated(databaseController.text);
  }

  void _onSubmit() {
    context.read<SettingsCubit>().mysqlSettingsChanged();
  }

  @override
  Widget build(BuildContext context) {
    final formState = context
        .select((SettingsCubit cubit) => cubit.state.mysqlSettingsFormState);
    if (widget.mysqlSettings.isNotEmpty && formState == null) {
      context
          .read<SettingsCubit>()
          .initMysqlSettingsFormState(widget.mysqlSettings);
    }
    return ScaffoldPage.scrollable(
      header: PageHeader(
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(FluentIcons.database_activity, size: 30),
        ),
        title: const Text('MySQL Database Settings'),
        commandBar: widget.standAlone
            ? null
            : Button(
                child: const Icon(FluentIcons.back),
                onPressed: () {
                  context.read<SettingsCubit>().pageChanged(SettingsPage.main);
                },
              ),
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 200),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextFormBox(
                    header: 'Host:',
                    headerStyle: FluentTheme.of(context)
                        .typography
                        .caption
                        ?.apply(fontSizeFactor: 1.0),
                    placeholder: 'Host',
                    controller: hostController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text) =>
                        formState!.host.invalid ? 'Provide valid host' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormBox(
                    header: 'User:',
                    headerStyle: FluentTheme.of(context)
                        .typography
                        .caption
                        ?.apply(fontSizeFactor: 1.0),
                    placeholder: 'User',
                    controller: userController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text) =>
                        formState!.user.invalid ? 'Provide valid user' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormBox(
                    header: 'Port:',
                    headerStyle: FluentTheme.of(context)
                        .typography
                        .caption
                        ?.apply(fontSizeFactor: 1.0),
                    placeholder: 'Port',
                    controller: portController,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text) =>
                        formState!.port.invalid ? 'Provide valid port' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormBox(
                    header: 'Password:',
                    headerStyle: FluentTheme.of(context)
                        .typography
                        .caption
                        ?.apply(fontSizeFactor: 1.0),
                    placeholder: 'Password',
                    controller: passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text) => formState!.password.invalid
                        ? 'Provide valid password'
                        : null,
                    obscureText: true,
                    obscuringCharacter: '*',
                  ),
                  const SizedBox(height: 15),
                  TextFormBox(
                    header: 'Database:',
                    headerStyle: FluentTheme.of(context)
                        .typography
                        .caption
                        ?.apply(fontSizeFactor: 1.0),
                    placeholder: 'Database',
                    controller: databaseController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text) => formState!.database.invalid
                        ? 'Provide valid database name'
                        : null,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FilledButton(
                        onPressed: formState == null ||
                                formState.status == FormzStatus.invalid
                            ? null
                            : _onSubmit,
                        child: const Text('Connect'),
                      ),
                      Visibility(
                        visible: !widget.standAlone,
                        child: Button(
                          child: const Text('Cancel'),
                          onPressed: () {
                            context
                                .read<SettingsCubit>()
                                .pageChanged(SettingsPage.main);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
