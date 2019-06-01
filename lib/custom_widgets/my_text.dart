import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String content;
  final Color color;
  final double size;
  final bool isBold;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign align;

  MyText({
    this.content,
    this.color,
    this.align,
    this.size,
    this.isBold = false,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: align ?? TextAlign.start,
    );
  }
}
