import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Color buttonColor;
  final VoidCallback onPressed;
  final double borderRadius;
  final double elevation;
  final double padding;
  final double fontSize;
  final Color textColor;
  final FontWeight fontWeight;
  final double width;
  final double height;
  final double borderWidth;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.buttonColor,
    required this.borderRadius,
    required this.elevation,
    required this.padding,
    required this.fontSize,
    required this.textColor,
    required this.fontWeight,
    required this.width,
    required this.height,
    required this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: textColor, width: borderWidth),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
