import 'package:fluent_ui/fluent_ui.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>(
    {required BuildContext context,
    required Widget title,
    required Widget content,
    required DialogOptionBuilder optionsBuilder}) {
  final options = optionsBuilder();

  return showDialog<T>(
    context: context,
    builder: (context) {
      return ContentDialog(
        title: title,
        content: content,
        actions: options.keys.map((optionTitle) {
          final T value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}


// SingleChildScrollView(
//           child: ListBody(
//             children: [
//               Text(content),
//               const SizedBox(
//                 height: 5,
//               ),
//               ...list!
//                   .map((text) => Row(
//                         children: [
//                           Container(
//                             width: 4,
//                             height: 4,
//                             decoration: BoxDecoration(
//                                 color: Colors.grey,
//                                 borderRadius: BorderRadius.circular(20)),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             text,
//                             style: const TextStyle(
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ))
//                   .toList(),
//             ],
//           ),
//         ),