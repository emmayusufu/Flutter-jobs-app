import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChipWidget extends StatefulWidget {
  final String label;
  ChipWidget({
    @required this.label
});

  @override
  _ChipWidgetState createState() => _ChipWidgetState();
}

class _ChipWidgetState extends State<ChipWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chip(label: Text(widget.label)),
    );
  }
}
