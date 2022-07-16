import 'package:fluent_ui/fluent_ui.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Dashboard'),
      ),
      children: const [],
    );
  }
}
