import 'dart:developer' show log;

import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterserver/app/app.dart';
import 'package:waterserver/settings/settings.dart';
import 'package:window_manager/window_manager.dart';

const String appTitle = 'WaterServer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  const String appTitle = 'WaterServer';

  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  final settingsProvider = SettingsProvider(
    plugin: await SharedPreferences.getInstance(),
  );

  BlocOverrides.runZoned(
    () => runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: SettingsRepository(settingsProvider: settingsProvider),
          ),
        ],
        child: const App(title: appTitle),
      ),
    ),
    blocObserver: AppObserver(),
  );
}

class AppObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('${bloc.runtimeType}: $change');
  }
}
