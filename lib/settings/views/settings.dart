import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:formz/formz.dart';
import 'package:waterserver/app/app.dart';
import 'package:waterserver/home/home.dart';
import 'package:waterserver/settings/settings.dart';
import 'package:waterserver/utilities/generics/cap_first.dart';

part 'settings_main.dart';
part 'settings_mysql.dart';

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
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
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
      },
      builder: (context, state) {
        final AppState appState = context.watch<AppBloc>().state;
        return IndexedStack(
          index: state.page.index,
          children: [
            SettingsMain(appMysqlStatus: appState.mysqlStatus),
            SettingsMysql(mysqlSettings: appState.mysqlSettings),
          ],
        );
      },
    );
  }
}
