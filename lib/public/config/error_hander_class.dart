

import 'dart:math';

import 'package:flutter/widgets.dart';

class MyErrorsHandler
{


  static Future<void> initialize()async
  {
  // initilizre loggin serverices, crashlytic, or sentry here.. firebase crashtics
  }
  static void onErrorDetails(FlutterErrorDetails details)
  {
    debugPrint("flutter Error:${details.exception}");
  }
  static void onError(Object error,StackTrace stackTrace)
  {
    debugPrint("platform Errror:$e}");
  }
  static void logDartError(Object error,StackTrace stackTrace)
  {
    debugPrint("dart Error:$error\n$stackTrace");
  }
}