import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterserver/app/app.dart';
import 'package:waterserver/bill/bill.dart';
import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/database/database.dart';
import 'package:waterserver/area/area.dart';
import 'package:waterserver/home/home.dart';
import 'package:waterserver/settings/settings.dart';
import 'package:waterserver/tariff/tariff.dart';
import 'package:waterserver/utilities/utilities.dart';

class App extends StatelessWidget {
  final String title;
  final SettingsRepository _settingsRepository;
  final MysqlDatabaseRepository _mysqlDatabaseRepository;

  const App({
    Key? key,
    required this.title,
    required settingsRepository,
    required mysqlDatabaseRepository,
  })  : _settingsRepository = settingsRepository,
        _mysqlDatabaseRepository = mysqlDatabaseRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _settingsRepository,
        ),
        RepositoryProvider<MysqlDatabaseRepository>.value(
          value: _mysqlDatabaseRepository,
        ),
        RepositoryProvider<AreaRepository>(
          create: (_) => AreaRepository(
            mysqlDatabaseRepository: _mysqlDatabaseRepository,
          ),
        ),
        RepositoryProvider<TariffRepository>(
          create: (_) => TariffRepository(
            mysqlDatabaseRepository: _mysqlDatabaseRepository,
          ),
        ),
        RepositoryProvider<ContractRepository>(
          create: (_) => ContractRepository(
            mysqlDatabaseRepository: _mysqlDatabaseRepository,
          ),
        ),
        RepositoryProvider<BillRepository>(
          create: (_) => BillRepository(
            mysqlDatabaseRepository: _mysqlDatabaseRepository,
          ),
        ),
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          settingsRepository: _settingsRepository,
          databaseRepository: _mysqlDatabaseRepository,
        ),
        child: AppView(title: title),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  final String title;

  const AppView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: title,
      debugShowCheckedModeBanner: false,
      home: BlocConsumer<AppBloc, AppState>(
        listener: (context, state) async {
          if (state.message != null) {
            showGenericSnackbar(context: context, message: state.message!);
          }

          if (state.errorMessage != null) {
            showGenericSnackbar(
              context: context,
              message: state.errorMessage!,
            );
          }
        },
        builder: (context, state) => Home(title: title),
      ),
    );
  }
}
