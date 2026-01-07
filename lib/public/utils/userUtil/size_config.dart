import 'package:flutter/material.dart';

class SizeConFig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }

  // static  buildSizeBoxWithHeigth(double percentage) {
  //   return SizedBox(
  //      height: screenHeight * percentage,
  //   );
  // }
  static SizedBox verticalBox(double percentage) {
    return SizedBox(
      height: screenHeight * percentage,
    );
  }

  // Example 2: Fixed width based on a percentage of screen width
  static SizedBox horizontalBox(double percentage) {
    return SizedBox(
      width: screenWidth * percentage,
    );
  }

  // Optional: Methods to return dimensions directly
  static double get proportionalHeight =>
      screenHeight * 0.1; // Example 10% height
  static double get proportionalWidth => screenWidth * 0.1;

  // Container(
  //             color: Colors.red,
  //             // Use the direct static variable for width
  //             width: ScreenSize.proportionalWidth * 5, // 50% width (0.1 * 5)
  //             height: 100,
  //             child: const Center(child: Text('Box 2')),
  //           )
}
