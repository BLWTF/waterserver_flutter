import 'package:fluent_ui/fluent_ui.dart';
import 'package:waterserver/utilities/dialog/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
      context: context,
      title: Row(
        children: const [
          Icon(
            FluentIcons.error,
            size: 30.0,
          ),
          SizedBox(
            width: 20,
          ),
          Text('Error'),
        ],
      ),
      content: Text(text),
      optionsBuilder: () => {
            "OK": null,
          });
}
