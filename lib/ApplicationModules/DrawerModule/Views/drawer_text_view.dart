import 'package:flutter/material.dart';

class DrawerTextView extends StatefulWidget {
  final text;
  final color;
  final double? fontSize;
  final fontFamily;
  final fontWeight;

  const DrawerTextView({Key? key,required this.text, this.color, this.fontSize, this.fontFamily, this.fontWeight}) : super(key: key);

  @override
  State<DrawerTextView> createState() => _DrawerTextViewState();
}

class _DrawerTextViewState extends State<DrawerTextView> {
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
