import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/admin_shell.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/view/footer_screen.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/controller/homeLayoutController.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/view/versionDownload_screen.dart';
import 'package:truenorthflutterfrontend/app/unUsedButImp/select_screen.dart';
import 'package:truenorthflutterfrontend/public/config/api_const.dart';
import 'package:truenorthflutterfrontend/public/config/break_points.dart';
import 'package:truenorthflutterfrontend/public/config/deviceConfig.dart';
import 'package:truenorthflutterfrontend/public/config/downlaod_latest_version.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/api_result.dart';

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
        print("Base URL fetched successfully.");
        final jsonRespones = jsonDecode(ngrokResponse.body);
        return jsonRespones['base_url'];
      } else {
        print("Failed to fetch URL. Status code: ${ngrokResponse.statusCode}");
        return null;
      }
    } on SocketException catch (e) {
      // Specifically catch and print network socket exceptions
      debugPrint("Network SocketException in getApiUrl: ${e.message}");
      return null;
    } catch (e) {
      // Catch any other unexpected errors (JSON parsing errors, etc.)
      debugPrint("Unexpected URL fetching issue: $e");
      return null;
    }
  }

  Future<void> _checkAutoLogin() async {
    try {
      //store class for web store call class
      //final WebTokenService _webTokenService = WebTokenService();
      // Step 1: resolve API base URL (with fallback)
      String? rokurl = await getApiUrl();
      if (rokurl != null && rokurl.isNotEmpty) {
        Apiconstants.url = rokurl;
        TokenService.url = rokurl;
        debugPrint("API URL updated to: $rokurl");
      } else {
        // FALLBACK: Assign a hardcoded default URL if the Gist fetch fails or if offline
        Apiconstants.url = "https://your-fallback-api.com";
        TokenService.url = "https://your-fallback-api.com";
        debugPrint("Gist failed. Using fallback URL: ${Apiconstants.url}");
      }
      // Step 2/3: force-update check runs regardless of login state,
      // but only makes sense if we're online.
      bool hasInternet = await Deviceconfig.checkInternetConnection();
      if (hasInternet) {
        final bool isUpdating = await _checkForUpdate();
        {
          if (isUpdating) return; // user is on the update screen, stop here
        }
      }
      if (!mounted) return;
      // Step 4: single read, correct storage picked automatically
      final String? refreshToken = await TokenService.getRefreshToken();
      final String? role = await TokenService.getUserRole();
      final bool hasToken =
          refreshToken != null && refreshToken.trim().isNotEmpty;

      // final String? refreshToken = await TokenService.getRefreshToken();
      // final String? role = await TokenService.getUserRole();
      // final bool hasToken =
      //     refreshToken != null && refreshToken.trim().isNotEmpty;
      debugPrint("token exists: $hasToken, role: $role");
      // Step 5: no valid session -> straight to login

      if (!hasToken || role == null || role.trim().isEmpty) {
        _goToLogin();
        return;
      }

      // Step 6: offline flow — trust cached role, skip refresh entirely
      if (!hasInternet) {
        if (mounted) {
          ShowTaostMessage.toastMessage(context, "Offline mode");
          _navigateToHome(role);
        }

        return;
      }

      // Step 7: online + has token -> attempt to refresh access token.

      Result<String> result;

      try {
        result = await TokenService.getRefreshAccessToken();
      } catch (e) {
        // Belt-and-suspenders: TokenService already catches internally,
        // but if something unexpected still throws, don't crash the app —
        // treat it as a network issue rather than an invalid session.
        debugPrint("Unexpected refresh token error: $e");
        result = Result.failure(ApiError.network);
      }
      if (!mounted) return;
      if (result.isSuccess) {
        Provider.of<Homelayoutcontroller>(context, listen: false).resetState();
        _navigateToHome(role);
        return;
      }
      // Only a genuinely rejected/expired token should clear the session.
      // Network/server/parsing issues should NOT log the user out.
      if (result.error == ApiError.invalidData) {
        debugPrint("Session invalid — clearing SharedPreferences");
        await TokenService.clearTokens();
        _goToLogin();
      } else {
        debugPrint(
            "Refresh failed due to ${result.error} — continuing offline");
        ShowTaostMessage.toastMessage(
            context, "Connection issue — continuing offline");
        _navigateToHome(role);
      }

      // _goToLogin();
    } catch (e) {
      debugPrint("Auto-login error: $e");
      if (mounted) _goToLogin();
    }
  }

  void _navigateToHome(String role) {
    if (!mounted) return;
    if (role.trim().toUpperCase() == "ADMIN") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const AdminShell()));
      return;
    }
//this route for normal user..........
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const FooterScreen()),
    );
  }

  void _goToLogin() {
    if (!mounted) return;
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return; // Check again after the 2-second delay
      // This check is mandatory here!
      // It checks if the widget is still in the tree after the 2-second wait.
      //if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SelectScreenForService()),
      );
    });
  }

  Future<bool> _checkForUpdate() async {
    final bool updateAvailable =
        await DownlaodLatestVersion.getUpdate() ?? false;
    if (updateAvailable && mounted) {
      final bool userWantsToUpdateLater = await showUpdateDialog(context);
      if (!userWantsToUpdateLater && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VersiondownloadScreen(),
          ),
        );
        return true; // update flow started, stop auto-login here
      }
    }
    return false; // no update, or user chose to continue without updating
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
    // 1. Initialize configuration inside build to handle real-time window resizing

    SizeConFig.init(context);

    // 2. Check responsiveness state using your BreakPoint rules
    final bool useWebView = BreakPoint.isWeb(SizeConFig.screenWidth);

    // 3. Declare image constraints based on layout strategy
    // Web gets static clean dimensions, Mobile uses fluid percentages
    final double computedWidth =
        useWebView ? 400.0 : (SizeConFig.screenWidth * 0.80);
    final double computedHeight =
        useWebView ? 400.0 : (SizeConFig.screenHeight * 0.50);

    return Scaffold(
      backgroundColor: Colors.white, // Standard clean background
      body: SafeArea(
        child: Center(
          child: Container(
            height: double.infinity,
            width: useWebView ? 500.0 : double.infinity,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Vertically centers content safely
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 15),
                  //  height: computedHeight,
                  //width: computedWidth,
                  height: useWebView ? 350.0 : (SizeConFig.screenHeight * 0.35),
                  width: useWebView ? 350.0 : (SizeConFig.screenWidth * 0.70),
                  child: Image.asset(
                    Appimage.splash,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  // Example usage of your SizeConFig vertical spacing box (5% of screen height)
                ),
                SizeConFig.verticalBox(0.05),
                const Text("Loading your workspace...",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
