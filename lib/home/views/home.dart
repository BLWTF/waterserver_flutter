import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterserver/bill/bill.dart';
import 'package:waterserver/home/home.dart';
import 'package:waterserver/contract/contract.dart';
import 'package:waterserver/dashboard/dashboard.dart';
import 'package:waterserver/settings/settings.dart';
import 'package:waterserver/utilities/dialog/dialog.dart';
import 'package:waterserver/widgets/window_buttons.dart';
import 'package:window_manager/window_manager.dart';

class Home extends StatelessWidget {
  final String title;

  const Home({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(
            settingsRepository: context.read<SettingsRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => ContractCubit(
            contractRepository: context.read<ContractRepository>(),
            billRepository: context.read<BillRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => BillCubit(
            billRepository: context.read<BillRepository>(),
          ),
        ),
      ],
      child: HomeView(title: title),
    );
  }
}

class HomeView extends StatefulWidget {
  final String title;

  const HomeView({Key? key, required this.title}) : super(key: key);

  final List<Widget> pages = const [
    // Dashboard(),
    ContractManagement(),
    BillManagement(),
    Settings(),
  ];

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        switch (state.status) {
          case HomeStatus.clear:
            Navigator.of(context).pop();
            break;
          case HomeStatus.loading:
            showLoadingDialog(context, state.message);
            break;
          case HomeStatus.progress:
            if (state.progress! == 0) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return ContentDialog(
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Row(
                            children: [
                              const Icon(FluentIcons.cloud_download),
                              const SizedBox(width: 5),
                              Text(
                                state.message!,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Builder(
                            builder: (context) {
                              final progress = context.select(
                                  (HomeBloc bloc) => bloc.state.progress);
                              return ProgressBar(value: progress);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            break;
          case HomeStatus.success:
            break;
          case HomeStatus.error:
            showErrorDialog(context, state.message!);
            break;
          default:
            break;
        }
      },
      child: Builder(builder: (context) {
        final index = context.select((HomeBloc bloc) => bloc.state.page).index;
        return NavigationView(
          appBar: NavigationAppBar(
            title: DragToMoveArea(
              child: Align(
                alignment: AlignmentDirectional.center,
                child: Text(widget.title),
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
          pane: NavigationPane(
            displayMode: PaneDisplayMode.auto,
            selected: index,
            onChanged: (i) => context
                .read<HomeBloc>()
                .add(HomePageChanged(HomePage.values[i])),
            size: const NavigationPaneSize(
              openMinWidth: 250.0,
              openMaxWidth: 320.0,
            ),
            indicator: const EndNavigationIndicator(),
            items: <NavigationPaneItem>[
              // PaneItem(
              //   icon: const Icon(FluentIcons.home),
              //   title: const Text('Dashboard'),
              // ),
              PaneItem(
                icon: const Icon(FluentIcons.account_management),
                title: const Text('Contract Management'),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.bill),
                title: const Text('Bill Management'),
              ),
            ],
            footerItems: [
              PaneItem(
                icon: const Icon(FluentIcons.settings),
                title: const Text('Settings'),
              )
            ],
          ),
          content: NavigationBody(
            index: index,
            children: [...widget.pages],
          ),
        );
      }),
    );
  }
}
