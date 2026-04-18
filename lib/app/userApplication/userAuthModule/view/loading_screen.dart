import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/view/footer_screen.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/controller/homeLayoutController.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/view/versionDownload_screen.dart';
import 'package:truenorthflutterfrontend/app/unUsedButImp/select_screen.dart';
import 'package:truenorthflutterfrontend/public/config/api_const.dart';
import 'package:truenorthflutterfrontend/public/config/deviceConfig.dart';
import 'package:truenorthflutterfrontend/public/config/downlaod_latest_version.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/app_image.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';
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

    _checkAutoLogin();
  }

//server api url from git
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

//   Future<void> _checkAutoLogin() async {
//     try {
// //Step1: Get refresh token
//       String? refreshToken = await TokenService.getRefreshToken();

// //step2: Check internet
//       bool hasInternet = await Deviceconfig.checkInternetConnection();
//       if (!mounted) return;

// //step3:OFFLINE FLOW (User logged in) if user login but internet close in case user push home page
//       if (!hasInternet && refreshToken != null && refreshToken.isNotEmpty) {
//         ShowTaostMessage.toastMessage(context, "Offline mode");

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => FooterScreen()),
//         );
//         return;
//       }

//       // 4️⃣ ONLINE FLOW → check update
//       bool isUpdating = await DownloadLatestVersionOfApp();
//       if (isUpdating) return;

//       // 5️⃣ Load API URL
//       String? rokurl = await getApiUrl();
//       if (!mounted) return;
//       if (rokurl != null) {
//         Apiconstants.url = rokurl;
//         TokenService.url = rokurl;
//       }
//       print("token not refresh----------------------");
//        if (!mounted) return;
//       // 6️⃣ Refresh token if exists
//       if (refreshToken != null && refreshToken.isNotEmpty) {
//         bool refreshed = await TokenService.getRefreshAccessToken();
//         if (!mounted) return;
//         if (refreshed) {
//           print("token refresing--------------------------------------");
//           final controller =
//               Provider.of<Homelayoutcontroller>(context, listen: false);

// // 2. Reset the index to 0
//           controller.resetState();

// // 3. Perform the navigation
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => FooterScreen()),
//           );
//           return;
//         }
//       }

//       _goToLogin();
//     } catch (e) {
//       debugPrint("Auto-login error: $e");
//       _goToLogin();
//     }
//   }
  Future<void> _checkAutoLogin() async {
    try {
      // 1. Fetch token early
      print("step1----------------------------------------------------------");
      final String? refreshToken = await TokenService.getRefreshToken();
      final bool hasToken =
          refreshToken != null && refreshToken.trim().isNotEmpty;

      // 2. Check internet
      print("step2----------------------------------------------------------");
      bool hasInternet = await Deviceconfig.checkInternetConnection();

      // Always check mounted after an await before using 'context'
      // if (!mounted) return;

      // 3. OFFLINE FLOW
      if (!hasInternet && hasToken) {
        ShowTaostMessage.toastMessage(context, "Offline mode");
        _navigateToHome();
        return;
      }
      print("step3----------------------------------------------------------");

      // 4. ONLINE FLOW - App Updates
      // Ensure this doesn't hang indefinitely
      bool isUpdating = await DownloadLatestVersionOfApp();
      print("step4----------------------------------------------------------");
      if (isUpdating) return;

      // 5. Load & Set API URL
      String? rokurl = await getApiUrl();
      if (rokurl != null && rokurl.isNotEmpty) {
        Apiconstants.url = rokurl;
        TokenService.url = rokurl;
      }
      print("step5----------------------------------------------------------");

      // 6. TOKEN REFRESH LOGIC
      if (hasToken) {
        bool refreshed = await TokenService.getRefreshAccessToken();

        // if (!mounted) return;

        if (refreshed) {
          // Use the controller to reset state
          Provider.of<Homelayoutcontroller>(context, listen: false)
              .resetState();
          _navigateToHome();
          return;
        } else {
          // IMPORTANT: If refresh fails online, the token is likely invalid/expired.
          // You should probably clear the storage here.
          await TokenService.clearTokens();
        }
      }
      print("step6----------------------------------------------------------");

      _goToLogin();
    } catch (e) {
      debugPrint("Auto-login error: $e");
      if (mounted) _goToLogin();
    }
  }

  void _navigateToHome() {
    // if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const FooterScreen()),
    );
  }

  void _goToLogin() {
    Future.delayed(const Duration(seconds: 2), () {
      // This check is mandatory here!
      // It checks if the widget is still in the tree after the 2-second wait.
      //if (!mounted) return;

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
//   @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: AnimatedSplashScreen.withScreenFunction( // 1. Use function mode
//       duration: 3000,
//       splashIconSize: 300,
//       splash: _buildSplashUI(), // Move your Column logic here to keep build clean

//       // 2. This function determines where to go AFTER the animation
//       screenFunction: () async {
//         return await _decideNextScreen();
//       },

//       splashTransition: SplashTransition.fadeTransition,
//       pageTransitionType: PageTransitionType.rightToLeftWithFade,
//       backgroundColor: Colors.white,
//     ),
//   );
// }
// Future<Widget> _decideNextScreen() async {
//   try {
//     // Run your existing auto-login logic here
//     String? refreshToken = await TokenService.getRefreshToken();
//     bool hasInternet = await Deviceconfig.checkInternetConnection();

//     if (hasInternet && refreshToken != null && refreshToken.isNotEmpty) {
//       bool refreshed = await TokenService.getRefreshAccessToken();
//       if (refreshed) {
//         // Reset your provider state here if needed
//         // Note: Use 'context' carefully here; AnimatedSplashScreen
//         // usually provides safe timing for this.
//         return const FooterScreen();
//       }
//     }

//     // If anything fails, clear tokens and go to Login
//     await TokenService.clearTokens();
//     return const SelectScreenForService();
//   } catch (e) {
//     debugPrint("Splash Decision Error: $e");
//     return const SelectScreenForService();
//   }
// }
// Widget _buildSplashUI() {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Container(
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 20,
//               spreadRadius: 5,
//             ),
//           ],
//         ),
//         child: CircleAvatar(
//           radius: 80.0,
//           backgroundColor: Colors.white,
//           child: ClipOval(
//             child: Image.asset(Appimage.splash, fit: BoxFit.cover),
//           ),
//         ),
//       ),
//       const SizedBox(height: 20),
//       const Text("TruNo", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
//     ],
//   );
// }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: AnimatedSplashScreen(
  //       duration: 3000,
  //       splashIconSize: 300, // Increased size to allow for text below the logo
  //       splash: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Container(
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               boxShadow: [
  //                 BoxShadow(
  //                   // ignore: deprecated_member_use
  //                   color: Colors.black.withOpacity(0.1),
  //                   blurRadius: 20,
  //                   spreadRadius: 5,
  //                 ),
  //               ],
  //             ),
  //             child: CircleAvatar(
  //               radius: 80.0,
  //               backgroundColor: Colors.white,
  //               child: ClipOval(
  //                 child: Image.asset(
  //                   Appimage.splash,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //           //App Name / Tagline
  //           const Text(
  //             "TruNo",
  //             style: TextStyle(
  //               fontSize: 24,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.blueAccent,
  //               letterSpacing: 1.5,
  //             ),
  //           ),
  //         ],
  //       ),
  //       nextScreen: const FooterScreen(),
  //       splashTransition: SplashTransition
  //           .fadeTransition, // Rotation can be dizzying, Fade is smoother
  //       //  splashTransition: SplashTransition
  //       //     .rotationTransition,
  //       pageTransitionType:
  //           PageTransitionType.rightToLeftWithFade, // Modern feel
  //       backgroundColor: Colors.white,
  //     ),
  //   );
  // }
}
