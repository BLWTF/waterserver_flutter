import 'package:fluent_ui/fluent_ui.dart';
import 'package:waterserver/widgets/window_buttons.dart';
import 'package:window_manager/window_manager.dart';

class WindowPage extends StatelessWidget {
  final String title;
  final Widget content;
  final NavigationPane? pane;
  final Widget? leading;

  const WindowPage({
    Key? key,
    required this.title,
    required this.content,
    this.pane,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: DragToMoveArea(
          child: Align(
            alignment: AlignmentDirectional.center,
            child: Text(title),
          ),
        ),
        leading: leading ??
            IconButton(
              icon: const Icon(FluentIcons.back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
        actions: Row(
          children: const [
            Spacer(),
            WindowButtons(),
          ],
        ),
      ),
      pane: pane,
      content: content,
    );
  }
}
