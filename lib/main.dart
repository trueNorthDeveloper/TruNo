import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/controller/admin_dashBoard_provider.dart';
import 'package:truenorthflutterfrontend/app/managerApplication/controller/teamLeaderCon.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/controller/expenseController.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/controller/login_provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/controller/logout_provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/controller/homeLayoutController.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAttendanceAndLeaveModule/controller/attendanceController.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/view/loading_screen.dart';
import 'package:truenorthflutterfrontend/app/unUsedButImp/login_controller_provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/controller/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/controller/user_project_provider.dart';
import 'package:truenorthflutterfrontend/public/config/themdata.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

final RouteObserver<PageRoute> appRouteObserver = RouteObserver<PageRoute>();

/// -----------------------------------------------------------------------
/// RESPONSIVE ADMIN PORTAL LAYOUT
/// -----------------------------------------------------------------------
/// Web (wide screen)  -> Fixed left sidebar + top app bar
/// Mobile (narrow)     -> Drawer + bottom navigation bar
///
/// Breakpoint logic lives in one place (Breakpoints class) so you can
/// tune it later without touching the layout widgets.
///
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
        ChangeNotifierProvider(create: (_) => Attendancecontroller()),
        ChangeNotifierProvider(create: (_) => Expensecontroller()),
        ChangeNotifierProvider(create: (_) => LogoutProvider())
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
  Widget build(BuildContext context) {
    SizeConFig.init(context);
    //final platform = getPlatformType();
//commeted for admin poral
    // return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     theme: MyAppTheme.lightTheme,
    //     darkTheme: MyAppTheme.darkTheme,
    //     home: platform == PlatformType.web
    //         ? AdminSplashScreen()
    //         : LoadingScreen());

    ///check user are admin or not........................
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: MyAppTheme.lightTheme,
        darkTheme: MyAppTheme.darkTheme,
        // home: platform == PlatformType.web
        //     ? AdminSplashScreen()
        //     : LoadingScreen());
        // home: AdminShell());
         home: LoadingScreen());
       // home: AdminShell());
  }
}
