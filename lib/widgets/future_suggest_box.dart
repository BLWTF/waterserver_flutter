import 'package:fluent_ui/fluent_ui.dart';

class FutureSuggestBox extends StatefulWidget {
  final Future<List> future;
  final String? value;
  final String label;
  final Function(String) onUpdate;

  const FutureSuggestBox({
    super.key,
    required this.future,
    required this.value,
    required this.label,
    required this.onUpdate,
  });

  @override
  State<FutureSuggestBox> createState() => _FutureSuggestBoxState();
}

class _FutureSuggestBoxState extends State<FutureSuggestBox> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value)
      ..addListener(_listener);
  }

  void _listener() {
    widget.onUpdate(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: widget.future,
      builder: (context, snapshot) {
        List items = [];
        if (snapshot.hasData) {
          items = snapshot.data!.map((e) => e.toString()).toList();
        }
        return InfoLabel(
          label: widget.label,
          labelStyle: FluentTheme.of(context)
              .typography
              .caption
              ?.apply(fontSizeFactor: 1.0),
          child: AutoSuggestBox(
            placeholder: '${widget.label}s',
            controller: _controller,
            items: items
                .map((e) => AutoSuggestBoxItem(
                      value: e.toString(),
                      label: e.toString(),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}

extension IsEmptyOrNull on String? {
  bool isEmptyOrNull() {
    if (this == null) {
      return true;
    }

    return this!.isEmpty;
  }
}
