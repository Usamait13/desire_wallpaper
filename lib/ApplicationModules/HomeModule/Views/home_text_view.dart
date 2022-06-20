import 'package:flutter/material.dart';

class HomeTextView extends StatefulWidget {
  final text;
  final color;
  final double? fontSize;
  final fontFamily;
  final fontWeight;

  const HomeTextView({Key? key,required this.text, this.color, this.fontSize, this.fontFamily, this.fontWeight}) : super(key: key);

  @override
  State<HomeTextView> createState() => _HomeTextViewState();
}

class _HomeTextViewState extends State<HomeTextView> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        color: widget.color,
        fontSize: widget.fontSize,
        fontFamily: widget.fontFamily,
        fontWeight: widget.fontWeight,
      ),
      overflow: TextOverflow.visible,
    );
  }
}
