import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/controller/adminController/admin_dashBoard_provider.dart';
import 'package:truenorthflutterfrontend/app/controller/teamLeaderController/teamLeaderCon.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/login_provider.dart';
import 'package:truenorthflutterfrontend/app/controller/user_home_layout_controller/homeLayoutController.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/controller/attendanceController.dart';

import 'package:truenorthflutterfrontend/app/view/adminView/admin_splash_screen.dart';
import 'package:truenorthflutterfrontend/app/controller/user_home_layout_controller/loading_screen.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/login_controller_provider.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/app/controller/userController/user_project_provider.dart';

import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/public/config/themdata.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => UserDashboardProvider()),
        ChangeNotifierProvider(create: (_) => AdminDashboardProvider()),
        ChangeNotifierProvider(create: (_) => UserProjectProvider()),
        ChangeNotifierProvider(create: (_) => LoginControll()),
        ChangeNotifierProvider(create: (_) => TeamleaderControllerPro()),
        ChangeNotifierProvider(create: (_) => Homelayoutcontroller()),
        ChangeNotifierProvider(create: (_) => Attendancecontroller())
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
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    SizeConFig.init(context);
    final platform = getPlatformType();
//comment 23-3-26
    // return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     theme: MyAppTheme.lightTheme,
    //     darkTheme: MyAppTheme.darkTheme,
    //     home: platform == PlatformType.web
    //         ? AdminSplashScreen()
    //         : SplashScreen());
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: MyAppTheme.lightTheme,
        darkTheme: MyAppTheme.darkTheme,
        home: platform == PlatformType.web
            ? AdminSplashScreen()
            : LoadingScreen());
  }
}
