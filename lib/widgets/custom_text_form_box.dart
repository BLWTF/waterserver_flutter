import 'package:fluent_ui/fluent_ui.dart';
import 'package:formz/formz.dart';
import 'package:waterserver/utilities/generics/cap_first.dart';

class CustomTextFormBox extends StatefulWidget {
  final String name;
  final FormzInput? state;
  final Function(String) onUpdate;
  final Function(String)? onSubmit;
  final bool multiline;
  final Widget? suffix;

  const CustomTextFormBox({
    Key? key,
    required this.name,
    this.state,
    required this.onUpdate,
    this.onSubmit,
    this.multiline = false,
    this.suffix,
  }) : super(key: key);

  @override
  State<CustomTextFormBox> createState() => _CustomTextFormBoxState();
}

class _CustomTextFormBoxState extends State<CustomTextFormBox> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.state?.value)
      ..addListener(_listener);
  }

  void _listener() {
    widget.onUpdate(_textEditingController.text);
  }

  @override
  void didUpdateWidget(covariant CustomTextFormBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    final String? value = widget.state?.value;
    _textEditingController.text = value ?? '';

    if (value != null) {
      _textEditingController.selection = TextSelection(
        baseOffset: value.length,
        extentOffset: value.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormBox(
      suffix: widget.suffix,
      header: widget.name.capFirst(),
      headerStyle: FluentTheme.of(context)
          .typography
          .caption
          ?.apply(fontSizeFactor: 1.0),
      placeholder: widget.name.capFirst(),
      controller: _textEditingController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: widget.multiline ? null : 1,
      onFieldSubmitted: (value) {
        widget.onSubmit != null ? widget.onSubmit!(value) : null;
      },
      validator: (_) => !widget.state!.pure && widget.state!.invalid
          ? 'Provide valid ${widget.name}'
          : null,
    );
  }
}

enum InputType { string, number }
