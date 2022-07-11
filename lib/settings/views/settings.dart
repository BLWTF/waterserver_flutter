import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterserver/home/home.dart';
import 'package:waterserver/settings/settings.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<SettingsCubit>(),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Settings'),
      ),
      children: [
        BlocConsumer<SettingsCubit, SettingsState>(
          listener: ((context, state) {
            switch (state.status) {
              case HomeStatus.clear:
                context.read<HomeBloc>().add(HomeStatusCleared());
                break;
              case HomeStatus.loading:
                context.read<HomeBloc>().add(HomeStatusLoaded(state.message!));
                break;
              case HomeStatus.progress:
                context.read<HomeBloc>().add(HomeStatusProgressed(
                    message: state.message!, progress: state.progress!));
                break;
              case HomeStatus.success:
                break;
              case HomeStatus.error:
                context.read<HomeBloc>().add(HomeStatusError(state.message!));
                break;
              default:
                break;
            }
          }),
          builder: (context, state) {
            final List updateDescription = state.appLatestVersionInfo != null
                ? state.appLatestVersionInfo!['description']
                : [];

            return Column(
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
              ],
            );
          },
        ),
      ],
    );
  }
}
