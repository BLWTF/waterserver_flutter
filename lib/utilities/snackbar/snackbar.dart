import 'package:fluent_ui/fluent_ui.dart';

void showGenericSnackbar({
  required BuildContext context,
  required String message,
  IconData? icon,
  Function()? onDismiss,
}) {
  showSnackbar(
    context,
    Snackbar(
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              icon ?? FluentIcons.info,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 200,
              child: Text(
                message,
              ),
            ),
          ],
        ),
      ),
    ),
    duration: const Duration(seconds: 5),
    alignment: const Alignment(1.0, -0.8),
    onDismiss: onDismiss,
  );
}
