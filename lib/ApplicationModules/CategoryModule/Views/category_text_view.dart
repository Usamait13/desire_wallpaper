import 'package:flutter/material.dart';

class CategoryTextView extends StatefulWidget {
  final text;
  final color;
  final double? fontSize;
  final fontFamily;
  final fontWeight;

  const CategoryTextView({Key? key,required this.text, this.color, this.fontSize, this.fontFamily, this.fontWeight}) : super(key: key);

  @override
  State<CategoryTextView> createState() => _CategoryTextViewState();
}

class _CategoryTextViewState extends State<CategoryTextView> {
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
