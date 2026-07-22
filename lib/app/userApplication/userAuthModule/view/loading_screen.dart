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
}
