import 'package:fluent_ui/fluent_ui.dart';

void showLoadingDialog(
  BuildContext context,
  String? message,
) {
  showDialog(
    context: context,
    builder: (context) {
      return ContentDialog(
        content: RepaintBoundary(
          child: Row(
            children: [
              Text(message ?? 'Please wait...'),
              const SizedBox(width: 20.0),
              const SizedBox(
                width: 15.0,
              ),
              const ProgressRing(),
            ],
          ),
        ),
      );
    },
  );
}
