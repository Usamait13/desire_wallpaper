import 'package:flutter/material.dart';

class SplashTextView extends StatefulWidget {
  final text;
  final color;
  final double? fontSize;
  final fontFamily;
  final fontWeight;

  const SplashTextView({Key? key,required this.text, this.color, this.fontSize, this.fontFamily, this.fontWeight}) : super(key: key);

  @override
  State<SplashTextView> createState() => _SplashTextViewState();
}

class _SplashTextViewState extends State<SplashTextView> {
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
