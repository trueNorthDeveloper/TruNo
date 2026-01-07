import 'package:flutter/material.dart';

class BuildCustomText extends StatelessWidget {
  final String data;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;

  const BuildCustomText({
    Key? key,
    required this.data,
    this.color = Colors.black, // Default color
    this.fontSize = 16.0,      // Default size
    this.fontWeight = FontWeight.normal, // Default weight
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
