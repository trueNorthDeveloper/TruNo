import 'dart:convert';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/controller/user_home_layout_controller/footer_screen.dart';
import 'package:truenorthflutterfrontend/app/controller/user_home_layout_controller/homeLayoutController.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userHomeView/versionDownload_screen.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userLogRegsView/select_screen.dart';
import 'package:truenorthflutterfrontend/public/config/api_const.dart';
import 'package:truenorthflutterfrontend/public/config/deviceConfig.dart';
import 'package:truenorthflutterfrontend/public/config/downlaod_latest_version.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/app_image.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 3), () {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (_) => const FooterScreen()),
    //   );
    // });
    //? for autologin
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAutoLogin();
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

  Future<void> _checkAutoLogin() async {
    try {
//end 24-03-26...........
//Step1: Get refresh token
      String? refreshToken = await TokenService.getRefreshToken();

//step2: Check internet
      bool hasInternet = await Deviceconfig.checkInternetConnection();
      if (!mounted) return;

//step3:OFFLINE FLOW (User logged in) if user login but internet close in case user push home page
      if (!hasInternet && refreshToken != null && refreshToken.isNotEmpty) {
        ShowTaostMessage.toastMessage(context, "Offline mode");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => FooterScreen()),
        );
        return;
      }

      // 4️⃣ ONLINE FLOW → check update
      bool isUpdating = await DownloadLatestVersionOfApp();
      if (isUpdating) return;

      // 5️⃣ Load API URL
      String? rokurl = await getApiUrl();
      if (!mounted) return;
      if (rokurl != null) {
        Apiconstants.url = rokurl;
        TokenService.url = rokurl;
      }

      // 6️⃣ Refresh token if exists
      if (refreshToken != null && refreshToken.isNotEmpty) {
        bool refreshed = await TokenService.getRefreshAccessToken();
        if (!mounted) return;
        if (refreshed) {
          final controller =
              Provider.of<Homelayoutcontroller>(context, listen: false);

// 2. Reset the index to 0
          controller.resetState();

// 3. Perform the navigation
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => FooterScreen()),
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

  void _goToLogin() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SelectScreenForService()),
      );
    });
  }

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
    return Scaffold(
      body: AnimatedSplashScreen(
        duration: 3000,
        splashIconSize: 300, // Increased size to allow for text below the logo
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 80.0,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    Appimage.splash,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            //App Name / Tagline
            const Text(
              "TruNo",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        nextScreen: const FooterScreen(),
        splashTransition: SplashTransition
            .fadeTransition, // Rotation can be dizzying, Fade is smoother
        //  splashTransition: SplashTransition
        //     .rotationTransition,
        pageTransitionType:
            PageTransitionType.rightToLeftWithFade, // Modern feel
        backgroundColor: Colors.white,
      ),
    );
  }
}
