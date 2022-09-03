import 'package:fluent_ui/fluent_ui.dart';

class Info extends StatelessWidget {
  final String label;
  final String value;
  final Color? labelColor;
  final TextStyle? textStyle;

  const Info({
    Key? key,
    required this.label,
    required this.value,
    this.labelColor,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InfoLabel(
        label: label,
        labelStyle: FluentTheme.of(context).typography.caption?.apply(
              fontSizeFactor: 0.9,
              color: labelColor ?? const Color.fromARGB(255, 90, 95, 97),
            ),
        child: Text(
          value,
          style: textStyle,
        ),
      ),
    );
  }
}
