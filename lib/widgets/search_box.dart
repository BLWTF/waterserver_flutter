import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final Function(String) onChanged;
  final String? query;

  const SearchBox({Key? key, required this.onChanged, this.query})
      : super(key: key);

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late final TextEditingController queryController;
  String? _searchQuery;
  Timer? searchThrottler;

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.query;
    queryController = TextEditingController(text: widget.query)
      ..addListener(_onSearchBoxChange);
  }

  void _onSearchBoxChange() {
    if (queryController.text != _searchQuery) {
      if (searchThrottler != null) {
        searchThrottler!.cancel();
      }
      searchThrottler = Timer(const Duration(seconds: 1), () {
        setState(() {
          _searchQuery = widget.query;
        });
        widget.onChanged(queryController.text);
      });
    }
  }

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: TextField(
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Search contracts',
        ),
        controller: queryController,
      ),
    );
  }
}
