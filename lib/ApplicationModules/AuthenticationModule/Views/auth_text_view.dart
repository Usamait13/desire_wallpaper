import 'package:flutter/material.dart';

class AuthTextView extends StatefulWidget {
  final text;
  final color;
  final double? fontSize;
  final fontFamily;
  final fontWeight;

  const AuthTextView({Key? key,required this.text, this.color, this.fontSize, this.fontFamily, this.fontWeight}) : super(key: key);

  @override
  State<AuthTextView> createState() => _AuthTextViewState();
}

class _AuthTextViewState extends State<AuthTextView> {
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
