import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

import 'package:truenorthflutterfrontend/app/unUsedButImp/user_list_of_screen.dart';

import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/controller/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/view/versionDownload_screen.dart';
import 'package:truenorthflutterfrontend/app/unUsedButImp/select_screen.dart';
import 'package:truenorthflutterfrontend/public/config/api_const.dart';
import 'package:truenorthflutterfrontend/public/config/deviceConfig.dart';
import 'package:truenorthflutterfrontend/public/config/downlaod_latest_version.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/app_image.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //BOTH COMMENTED
   
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAutoLogin();
    });
  }
  

  void _goToLogin() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SelectScreenForService()),
      );
    });
  }

  Future<String?> getApiUrl() async {
    final url =
        "https://gist.githubusercontent.com/trueNorthDeveloper/c9d91e97283633a0cf102ad349f771ce/raw/api-config.json?timestamp=${DateTime.now().millisecondsSinceEpoch}";

    try {
      final ngrokResponse = await http.get(Uri.parse(url));
      if (ngrokResponse.statusCode == 200) {
        final jsonRespones = jsonDecode(ngrokResponse.body);
        return jsonRespones['base_url'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

//download latest version if user exit or not.............
  Future<bool> DownloadLatestVersionOfApp() async {
    bool connection = await Deviceconfig.checkInternetConnection();

    // 🔇 Silent fail on no internet (offline flow handles this)
    if (!connection) {
      return false;
    }

    bool updateAvailable = await DownlaodLatestVersion.getUpdate() ?? false;

    if (updateAvailable && mounted) {
      bool shouldContinue = await showUpdateDialog(context);

      if (!shouldContinue && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VersiondownloadScreen(),
          ),
        );
        return true; // Update flow started
      }
    }

    return false; // No update or user skipped
  }

  Future<void> _checkAutoLogin() async {
    try {
//end 23-12-25...........
// 1️⃣ Get refresh token
      String? refreshToken = await TokenService.getRefreshToken();
      print("refresn token get-----------------");
      print(refreshToken);

      // 2️⃣ Check internet
      bool hasInternet = await Deviceconfig.checkInternetConnection();
      print("internet ok==========================");
      print(hasInternet);

      // 3️⃣ OFFLINE FLOW (User logged in)
      if (!hasInternet && refreshToken != null && refreshToken.isNotEmpty) {
        ShowTaostMessage.toastMessage(context, "Offline mode");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ListOfUiScreen()),
        );
        return;
      }

      // 4️⃣ ONLINE FLOW → check update
      bool isUpdating = await DownloadLatestVersionOfApp();
      if (isUpdating) return;

      // 5️⃣ Load API URL
      String? rokurl = await getApiUrl();
      if (rokurl != null) {
        Apiconstants.url = rokurl;
        TokenService.url = rokurl;
      }

      // 6️⃣ Refresh token if exists
      if (refreshToken != null &&
          refreshToken.isNotEmpty) {
        bool refreshed = await TokenService.getRefreshAccessToken();

        if (refreshed) {
          Provider.of<UserDashboardProvider>(context, listen: false)
              .changePostion(0);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ListOfUiScreen()),
          );
          return;
        }
      }

      // 7️⃣ No token → Login
      _goToLogin();
    } catch (e) {
      debugPrint("Auto-login error: $e");
      _goToLogin();
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

//NEW CODE AUTOLOGIN COMMENTED DATE 23-12-2025-----------------------------------------------------------------------  
  // Future<void> _checkAutoLogin() async {
  //   try {
  //     String? accessToken = await TokenService.getAccessToken();
  //     String? refreshToken = await TokenService.getRefreshToken();
      
  //     String? rokurl = await getApiUrl();

  //     if (rokurl != null) {
  //       Apiconstants.url = rokurl;
  //       TokenService.url = rokurl;
  //     }

  //     bool? updateAvailable = await DownlaodLatestVersion.getUpdate();

  //     if (updateAvailable == true) {
  //       bool shouldContinue = await showUpdateDialog(context);

  //       if (!shouldContinue) {
  //         // User chooses to logout for update
  //         print("User chooses to update; stopping auto-login.");
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => VersiondownloadScreen(),
  //             ));

  //         return;
  //       }
  //     }
  //     if (accessToken == null && refreshToken == null) {
  //       _goToLogin;
  //     }
  //     bool isRefreshed = await TokenService.getRefreshAccessToken();
  //     if (isRefreshed) {
  //       Provider.of<UserDashboardProvider>(context, listen: false)
  //           .changePostion(0);

  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (_) => ListOfUiScreen()),
  //       );
  //     } else {
  //       // refresh failed → token expired → auto logout
  //       // await TokenService.clearTokens();
  //       _goToLogin();
  //     }
  //   } catch (e) {
  //     debugPrint("Auto-login error: $e");
  //     _goToLogin();
  //   }
  // }
