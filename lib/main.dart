import 'dart:developer' show log;

import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterserver/app/app.dart';
import 'package:waterserver/database/database.dart';
import 'package:waterserver/settings/settings.dart';
import 'package:waterserver/user/repository/user_repository.dart';
import 'package:window_manager/window_manager.dart';

const String appTitle = 'WaterServer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

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

  const secureStorage = FlutterSecureStorage();

  final settingsRepository =
      SettingsRepository(settingsProvider: settingsProvider);

  final mysqlDatabaseRepository =
      MysqlDatabaseRepository(databaseProvider: MysqlUtilService());

  final userRepository = UserRepository(secureStorage: secureStorage);

  BlocOverrides.runZoned(
    () => runApp(
      App(
        title: appTitle,
        settingsRepository: settingsRepository,
        mysqlDatabaseRepository: mysqlDatabaseRepository,
        userRepository: userRepository,
      ),
    ),
    blocObserver: AppObserver(),
  );
}

class AppObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('${bloc.runtimeType} $change');
  }
}
