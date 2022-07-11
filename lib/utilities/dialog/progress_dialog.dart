import 'package:fluent_ui/fluent_ui.dart';

showProgressDialog(
  BuildContext context,
  String? message,
  Widget progressBuilder,
) {
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
                    message!,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              progressBuilder,
            ],
          ),
        ),
      );
    },
  );
}
