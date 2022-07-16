part of 'settings.dart';

class SettingsMain extends StatefulWidget {
  final AppMysqlStatus appMysqlStatus;

  const SettingsMain({Key? key, required this.appMysqlStatus})
      : super(key: key);

  @override
  State<SettingsMain> createState() => _SettingsMainState();
}

class _SettingsMainState extends State<SettingsMain> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final List updateDescription = state.appLatestVersionInfo != null
            ? state.appLatestVersionInfo!['description']
            : [];

        return ScaffoldPage.scrollable(
          scrollController: _scrollController,
          header: const PageHeader(
            title: Text('Settings'),
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.appLatestVersionInfo == null) ...[
                  Row(
                    children: [
                      const Icon(
                        FluentIcons.info,
                        size: 25.0,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        'Current Version is ${state.currentVersion}',
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Button(
                    onPressed: () {
                      context.read<SettingsCubit>().checkForUpdates();
                    },
                    child: const Text('Check for Updates'),
                  ),
                ],
                if (state.appLatestVersionInfo != null &&
                    state.appLatestVersionInfo!['version'] ==
                        state.currentVersion) ...[
                  Row(
                    children: const [
                      Icon(
                        FluentIcons.upgrade_analysis,
                        size: 25.0,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'You are using the latest version.',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [Text('Version: ${state.currentVersion}')],
                  ),
                  const SizedBox(height: 10.0),
                  Button(
                    onPressed: () {
                      context.read<SettingsCubit>().checkForUpdates();
                    },
                    child: const Text('Check for Updates'),
                  ),
                ],
                if (state.appLatestVersionInfo != null &&
                    state.appLatestVersionInfo!['version']! >
                        state.currentVersion!) ...[
                  Row(
                    children: const [
                      Icon(
                        FluentIcons.update_restore,
                        size: 25.0,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'New Version Available',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What's new in ${state.appLatestVersionInfo!['version']}:",
                      ),
                      ...updateDescription.map((description) {
                        return Row(
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(description)
                          ],
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  FilledButton(
                    onPressed: () {
                      context.read<SettingsCubit>().downloadNewVersion(
                          state.appLatestVersionInfo!['windows_file_name']);
                    },
                    child: const Text('Download and Install Update'),
                  ),
                ],
                const SizedBox(
                  height: 20,
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: const Icon(FluentIcons.linked_database),
                  title: const Text('MySQL Database Settings'),
                  subtitle: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.appMysqlStatus.name.capFirst(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const TextSpan(text: '   '),
                        TextSpan(
                          text: 'Change settings',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.normal,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context
                                  .read<SettingsCubit>()
                                  .pageChanged(SettingsPage.mysql);
                            },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
