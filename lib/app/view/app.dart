import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterserver/app/app.dart';
import 'package:waterserver/home/home.dart';

class App extends StatelessWidget {
  final String title;

  const App({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(),
      child: AppView(title: title),
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
      home: Home(title: title),
    );
  }
}
