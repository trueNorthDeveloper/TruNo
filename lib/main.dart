import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/controller/adminController/admin_dashBoard_provider.dart';

import 'package:truenorthflutterfrontend/app/view/adminView/admin_splash_screen.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userLogRegsView/user_splash_screen.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/login_controller_provider.dart';

import 'package:truenorthflutterfrontend/app/controller/userController/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/user_project_provider.dart';
import 'package:truenorthflutterfrontend/public/config/api_const.dart';
import 'package:truenorthflutterfrontend/public/config/downlaod_latest_version.dart';

import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/public/config/themdata.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => UserDashboardProvider()),
        ChangeNotifierProvider(create: (_) => AdminDashboardProvider()),
        ChangeNotifierProvider(create: (_) => UserProjectProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final platform = getPlatformType();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: MyAppTheme.lightTheme,
        darkTheme: MyAppTheme.darkTheme,
        home: platform == PlatformType.web
            ? AdminSplashScreen()
            : SplashScreen());
    // :UserPermissionHandlerState());
  }
}
  // Future<String?> apiUrlFun() async {
  //   final url =
  //       'https://gist.githubusercontent.com/trueNorthDeveloper/c9d91e97283633a0cf102ad349f771ce/raw/api-config.json';
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //    var baseUrl =json['base_url'];
  //    print(baseUrl);
  //    Apiconstants.url=baseUrl;

  //     return json['base_url'];
  //   } else {
  //     return null;
  //   }
  // }