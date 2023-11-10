import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/reorder.dart';

class CustomReorderableListView extends StatefulWidget {
  const CustomReorderableListView(
      {super.key, required this.list, this.header, this.controller});
  final List<Widget> list;
  final Widget? header;
  final ScrollController? controller;
  @override
  State<CustomReorderableListView> createState() =>
      _CustomReorderableListViewState();
}

class _CustomReorderableListViewState extends State<CustomReorderableListView> {
  late List<Widget> _items;

  @override
  Widget build(BuildContext context) {
    _items = List.from(widget.list);
    // TODO room for improvement, leveraging the state management

    return Consumer(builder: (context, ref, child) {
      return ReorderableListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollController: widget.controller,
        header: widget.header,
        footer: const SizedBox(height: 100),
        children: _items,
        onReorder: (int oldIndex, int newIndex) {
          // update the UI
          if (oldIndex < newIndex) newIndex -= 1;
          final Widget item = _items.removeAt(oldIndex);
          _items.insert(newIndex, item);

          // update the db
          reorder(ref, oldIndex, newIndex);
        },
      );
    });
  }
}
