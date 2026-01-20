import 'package:flutter/material.dart';

class BuildCustomText extends StatelessWidget {
  final String data;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const BuildCustomText({
    Key? key,
    required this.data,
    this.color = Colors.black, // Default color
    this.fontSize = 16.0,      // Default size
    this.fontWeight = FontWeight.normal,
    this.textAlign=TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow:TextOverflow.ellipsis,
      textAlign: textAlign,
      data,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        
        
      ),
    );
  }
}
