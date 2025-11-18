import 'package:flutter/material.dart';

class MyAppTheme {
  static final lightTheme = ThemeData(
    // brightness: Brightness.light,
    // primaryColor: Colors.blue,
    // scaffoldBackgroundColor: const Color.fromARGB(255, 190, 74, 74),
    // colorScheme: ColorScheme.light(
    //   primary: const Color.fromARGB(255, 62, 128, 183),
    //   secondary: Colors.orange,
    //   background: Colors.white,
    //   onBackground: Colors.black,
    // ),
    // textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
      brightness: Brightness.light,
    primaryColor: const Color(0xFF4285F4), // Google Blue
    scaffoldBackgroundColor: const Color(0xFFF5F7FA), // soft and modern
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4285F4),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF4285F4),
      secondary: Color(0xFFFFA726),
      surface: Color(0xFFF5F7FA),
      onSurface: Colors.black87,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
      titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.tealAccent,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.dark(
      primary: Colors.tealAccent,
      secondary: Colors.amberAccent,
     surface: Color(0xFF121212),
     onSurface: Colors.white,
    
    ),
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
  );
}
