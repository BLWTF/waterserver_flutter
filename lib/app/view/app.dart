import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterserver/app/app.dart';
import 'package:waterserver/contract/repository/contract_repository.dart';
import 'package:waterserver/database/database.dart';
import 'package:waterserver/home/home.dart';
import 'package:waterserver/settings/settings.dart';
import 'package:waterserver/utilities/utilities.dart';

class App extends StatelessWidget {
  final String title;
  final SettingsRepository _settingsRepository;

  const App({
    Key? key,
    required this.title,
    required settingsRepository,
  })  : _settingsRepository = settingsRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final MysqlDatabaseRepository mysqlDatabaseRepository =
        MysqlDatabaseRepository(databaseProvider: MysqlUtilService());
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _settingsRepository,
        ),
        RepositoryProvider<MysqlDatabaseRepository>.value(
          value: mysqlDatabaseRepository,
        ),
        RepositoryProvider<ContractRepository>(
          create: (_) => ContractRepository(
            mysqlDatabaseRepository: mysqlDatabaseRepository,
          ),
        )
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          settingsRepository: _settingsRepository,
          databaseRepository: mysqlDatabaseRepository,
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
