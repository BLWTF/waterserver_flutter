part of 'settings.dart';

class SettingsMysql extends StatefulWidget {
  final MysqlSettings mysqlSettings;

  const SettingsMysql({Key? key, required this.mysqlSettings})
      : super(key: key);

  @override
  State<SettingsMysql> createState() => _SettingsMysqlState();
}

class _SettingsMysqlState extends State<SettingsMysql> {
  late final TextEditingController _hostController;
  late final TextEditingController _portController;
  late final TextEditingController _userController;
  late final TextEditingController _passwordController;
  late final TextEditingController _databaseController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _hostController = TextEditingController(text: widget.mysqlSettings.host)
      ..addListener(_onUpdateHost);
    _portController = TextEditingController(
        text: widget.mysqlSettings.port == null
            ? ''
            : widget.mysqlSettings.port.toString())
      ..addListener(_onUpdatePort);
    _userController = TextEditingController(text: widget.mysqlSettings.user)
      ..addListener(_onUpdateUser);
    _passwordController =
        TextEditingController(text: widget.mysqlSettings.password)
          ..addListener(_onUpdatePassword);
    _databaseController =
        TextEditingController(text: widget.mysqlSettings.database)
          ..addListener(_onUpdateDatabase);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    _databaseController.dispose();
    super.dispose();
  }

  void _onUpdateHost() {
    context.read<SettingsCubit>().hostUpdated(_hostController.text);
  }

  void _onUpdatePort() {
    context.read<SettingsCubit>().portUpdated(_portController.text);
  }

  void _onUpdateUser() {
    context.read<SettingsCubit>().userUpdated(_userController.text);
  }

  void _onUpdatePassword() {
    context.read<SettingsCubit>().passwordUpdated(_passwordController.text);
  }

  void _onUpdateDatabase() {
    context.read<SettingsCubit>().databaseUpdated(_databaseController.text);
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
        commandBar: Button(
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
                    controller: _hostController,
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
                    controller: _userController,
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
                    controller: _portController,
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
                    controller: _passwordController,
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
                    controller: _databaseController,
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
                      Button(
                        child: const Text('Cancel'),
                        onPressed: () {
                          context
                              .read<SettingsCubit>()
                              .pageChanged(SettingsPage.main);
                        },
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
