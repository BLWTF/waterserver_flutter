import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterserver/app/app.dart';
import 'package:waterserver/authentication/bloc/authentication_bloc.dart';
import 'package:waterserver/authentication/repository/authentication_repository.dart';
import 'package:waterserver/authentication/views/login.dart';
import 'package:waterserver/bill/bill.dart';
import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/database/database.dart';
import 'package:waterserver/area/area.dart';
import 'package:waterserver/home/home.dart';
import 'package:waterserver/meter_reading/repository/meter_reading_repository.dart';
import 'package:waterserver/payment/payment.dart';
import 'package:waterserver/settings/settings.dart';
import 'package:waterserver/tariff/tariff.dart';
import 'package:waterserver/user/repository/user_repository.dart';
import 'package:waterserver/utilities/utilities.dart';
import 'package:waterserver/widgets/window_buttons.dart';
import 'package:window_manager/window_manager.dart';

class App extends StatelessWidget {
  final String title;
  final SettingsRepository _settingsRepository;
  final MysqlDatabaseRepository _mysqlDatabaseRepository;
  final UserRepository _userRepository;

  const App({
    Key? key,
    required this.title,
    required SettingsRepository settingsRepository,
    required MysqlDatabaseRepository mysqlDatabaseRepository,
    required UserRepository userRepository,
  })  : _settingsRepository = settingsRepository,
        _mysqlDatabaseRepository = mysqlDatabaseRepository,
        _userRepository = userRepository,
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
        RepositoryProvider<UserRepository>.value(
          value: _userRepository,
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
      ],
      child: Builder(builder: (context) {
        return AppEssentials(title: title);
      }),
    );
  }
}

class AppEssentials extends StatelessWidget {
  final String title;

  const AppEssentials({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationRepository>(
            create: (_) => AuthenticationRepository(
              mysqlDatabaseRepository:
                  RepositoryProvider.of<MysqlDatabaseRepository>(context),
              userRepository: RepositoryProvider.of<UserRepository>(context),
            ),
          ),
          RepositoryProvider<ContractRepository>(
            create: (_) => ContractRepository(
              mysqlDatabaseRepository:
                  RepositoryProvider.of<MysqlDatabaseRepository>(context),
              areaRepository: RepositoryProvider.of<AreaRepository>(context),
              tariffRepository:
                  RepositoryProvider.of<TariffRepository>(context),
            ),
          ),
          RepositoryProvider<BillRepository>(
            create: (_) => BillRepository(
              mysqlDatabaseRepository:
                  RepositoryProvider.of<MysqlDatabaseRepository>(context),
              areaRepository: RepositoryProvider.of<AreaRepository>(context),
              tariffRepository:
                  RepositoryProvider.of<TariffRepository>(context),
            ),
          ),
          RepositoryProvider<PaymentRepository>(
            create: (_) => PaymentRepository(
              mysqlDatabaseRepository:
                  RepositoryProvider.of<MysqlDatabaseRepository>(context),
              areaRepository: RepositoryProvider.of<AreaRepository>(context),
              tariffRepository:
                  RepositoryProvider.of<TariffRepository>(context),
            ),
          ),
          RepositoryProvider<MeterReadingRepository>(
            create: (_) => MeterReadingRepository(
              mysqlDatabaseRepository:
                  RepositoryProvider.of<MysqlDatabaseRepository>(context),
              tariffRepository:
                  RepositoryProvider.of<TariffRepository>(context),
            ),
          ),
        ],
        child: BlocProvider(
          create: (_) => AppBloc(
            settingsRepository:
                RepositoryProvider.of<SettingsRepository>(context),
            databaseRepository:
                RepositoryProvider.of<MysqlDatabaseRepository>(context),
          ),
          child: BlocProvider(
            create: (context) => AuthenticationBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
            ),
            child: AppView(title: title),
          ),
        ));
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
        builder: (context, state) {
          if (state.mysqlSettings.isEmpty) {
            return BlocProvider(
              create: (context) => SettingsCubit(
                  settingsRepository:
                      RepositoryProvider.of<SettingsRepository>(context)),
              child: AppMysqlOnboard(),
            );
          } else {
            return AppAuthentication(title: title);
          }
        },
      ),
    );
  }
}

class AppMysqlOnboard extends StatelessWidget {
  const AppMysqlOnboard({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationView(
        appBar: NavigationAppBar(
          title: const DragToMoveArea(
            child: Align(
              alignment: AlignmentDirectional.center,
              child: Text("Login"),
            ),
          ),
          leading: const Icon(FluentIcons.home),
          actions: Row(
            children: const [
              Spacer(),
              WindowButtons(),
            ],
          ),
        ),
        content: SettingsMysqlForm(
          mysqlSettings: context.read<AppBloc>().state.mysqlSettings,
          standAlone: true,
        ));
  }
}

class AppAuthentication extends StatelessWidget {
  final String title;

  const AppAuthentication({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      switch (state.status) {
        case AuthenticationStatus.unknown:
          return Container();
        case AuthenticationStatus.authenticated:
          return Home(title: title);
        case AuthenticationStatus.unauthenticated:
          return const Login();
      }
    });
  }
}
