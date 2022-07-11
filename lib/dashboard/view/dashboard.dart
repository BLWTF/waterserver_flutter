import 'package:fluent_ui/fluent_ui.dart';
import 'package:waterserver/widgets/page.dart';

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

class Dashboar extends ScrollablePage {
  @override
  Widget buildHeader(BuildContext context) {
    return const PageHeader(
      title: Text('Dashboard'),
    );
  }

  @override
  List<Widget> buildScrollable(BuildContext context) {
    return [];
  }
}
