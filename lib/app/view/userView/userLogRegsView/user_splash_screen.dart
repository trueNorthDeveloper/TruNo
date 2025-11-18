import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userHomeView/user_list_of_screen.dart';

import 'package:truenorthflutterfrontend/app/controller/userController/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userHomeView/versionDownload_screen.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userLogRegsView/select_screen.dart';
import 'package:truenorthflutterfrontend/public/config/downlaod_latest_version.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/app_image.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkAutoLogin();
  }
//DONT TRY TO DELETE THIS FUNCTION------------------------------------------------------------

  // Future<void> _checkAutoLogin() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final id = prefs.getString('empId');
  //     final empName = prefs.getString('empName');

  //     if (id != null && empName != null) {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         if (!mounted) return;
  //         Provider.of<UserDashboardProvider>(context, listen: false)
  //             .changePostion(0);
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (_) => ListOfUiScreen()),
  //         );
  //       });
  //     } else {
  //       Future.delayed(const Duration(seconds: 3), () {
  //         if (!mounted) return;
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (_) => const SelectScreenForService()),
  //         );
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint("Auto-login error: $e");
  //   }
  // }

  //
  Future<void> _checkAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('empId');
      final empName = prefs.getString('empName');

      bool? updateAvailable = await DownlaodLatestVersion.getUpdate();

      if (updateAvailable == true) {
        bool shouldContinue = await showUpdateDialog(context);

        if (!shouldContinue) {
          // User chooses to logout for update
          print("User chooses to update; stopping auto-login.");
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VersiondownloadScreen(),
              ));

          return; // Stop the process here
        }

        print("User wants to continue without updating.");
      }

      if (id != null && empName != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Provider.of<UserDashboardProvider>(context, listen: false)
              .changePostion(0);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ListOfUiScreen()),
          );
        });
      } else {
        Future.delayed(const Duration(seconds: 3), () {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SelectScreenForService()),
          );
        });
      }
    } catch (e) {
      debugPrint("Auto-login error: $e");
    }
  }

//show updating linear  bar
  Widget showDownloadBar(BuildContext context) {
    return Column(
      children: [
        const Text("A new version is available. Please update to continue."),
        const SizedBox(height: 20),
        LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          backgroundColor: Colors.grey[300],
        ),
      ],
    );
  }

  Future<bool> showUpdateDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Update Available"),
            content: const Text(
                "A new version of the app is available. Do you want to continue without updating?"),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // USER WANTS TO UPDATE → STOP LOGIN
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Update"),
                  ),

                  // USER CONTINUES WITHOUT UPDATE
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Continue"),
                  ),
                ],
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConFig.init(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: SizeConFig.screenHeight * 50 / 100,
            width: SizeConFig.screenWidth * 80 / 100,
            //  height: 50,
            child: Image.asset(Appimage.splash, fit: BoxFit.fill),
            // child:Text("splash screen"),
          ),
        ),
      ),
    );
  }
}
