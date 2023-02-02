import 'package:fluent_ui/fluent_ui.dart';

import 'generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: const Text("Logout"),
    content: const Text("Are you sure you want to logout?"),
    optionsBuilder: () => {
      "Yes": true,
      "No": false,
    },
  ).then((value) => value ?? false);
}
