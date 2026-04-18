import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/model/uesr_logout_request_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/model/user_login_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/model/user_me_model.dart';
import 'package:truenorthflutterfrontend/app/unUsedButImp/select_screen.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/view/footer_screen.dart';
import 'package:truenorthflutterfrontend/public/config/deviceConfig.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/service/auth_service.dart';

class LoginControll extends ChangeNotifier {
  UserServicesForApi userServicesForApi = UserServicesForApi();
  bool _isLoading = false;
  get isLoading => _isLoading;
  // / Resultt resultt;
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> userloginWithJwtController(
    String userId,
    String password,
    BuildContext context,
  ) async {
    if (userId.isEmpty || password.isEmpty) {
      ShowTaostMessage.toastMessage(context, "Enter login ID and password");
      return;
    }

    _setLoading(true);

    try {
      /// 1️⃣ Internet check
      final hasInternet = await Deviceconfig.checkInternetConnection();
      if (!hasInternet) {
        ShowTaostMessage.toastMessage(context, "No internet connection");
        return;
      }

      /// 2️⃣ Device info
      final deviceInfo = await Deviceconfig.getDeviceInfo();
      if (deviceInfo.isEmpty) {
        ShowTaostMessage.toastMessage(context, "Failed to get device info");
        return;
      }

      /// 3️⃣ Location
      final position = await Deviceconfig.deteminPosition();
      if (position == null) {
        _setLoading(false);
        _showLocationDialog(context, false);
        ShowTaostMessage.toastMessage(context, "Location permission required");
        return;
      }

      final address = await Deviceconfig.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      /// 4️⃣ Image capture
      final image = await Deviceconfig.pickImage(ImageSource.camera);
      if (image == null) {
        _setLoading(false);
        ShowTaostMessage.toastMessage(context, "Image capture failed");
        return;
      }

      /// 5️⃣ Create request model
      final loginRequest = LoginRequestModel(
        empLoginId: userId,
        empPassword: password,
        device: deviceInfo[0],
        deviceId: deviceInfo[1],
        deviceBrand: deviceInfo[2],
        model: deviceInfo[3],
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
        address: address,
      );
      //  print(loginRequest.toJson());

      /// 6️⃣ API call
      final result = await userServicesForApi.loginWithJwt(
        loginRequest.toJson(),
        image.path,
      );

      // if (!context.mounted) return;

      if (result.isSuccess && result.data != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("access_token", result.data["Access-Token"]);
        await prefs.setString("refresh_token", result.data["Refresh-Token"]);

        ShowTaostMessage.toastMessage(context, "Login Successfull");
        final user = await iamUser();

        if (user == null) {
          ShowTaostMessage.toastMessage(context, "Failed to load user");
          return;
        }

        // 🔹 Save role for app restart
        await prefs.setString("user_role", user.role);
        await prefs.setInt("user_id", user.id);
        await prefs.setString("eid", user.email);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => FooterScreen()));
      }

      if (result.message == "User already logged in on another device") {
        ShowTaostMessage.toastMessage(context, result.message!);
        final logoutRequest = LogoutRequestModel(
          logoutAddress: address,
          logoutDeviceBrand: deviceInfo[2],
          logoutDeviceId: deviceInfo[1],
          logoutLatitude: position.latitude.toString(),
          logoutLongitude: position.longitude.toString(),
          logoutDeviceModel: deviceInfo[3],
          logoutModel: deviceInfo[0],
          empEid: userId,
          logOutExcuse: "New device login",
        );

        await Future.delayed(const Duration(milliseconds: 100));

        showLogoutBox(context, result.message, logoutRequest.toJson(),
            image.path, loginRequest.toJson());

        return;
      }
    } catch (e) {
      ShowTaostMessage.toastMessage(context, "Unexpected error occurred");
    } finally {
      _setLoading(false);
    }
  }

  Future<UsermeModel?> iamUser() async {
    final userOutPout = await UserServicesForApi().loginAfterMeService();

    if (userOutPout.isSuccess) {
      _user = userOutPout.data;
      return _user;
    } else {
      return null;
    }
  }

  void showLogoutBox(BuildContext context, String? message,
      Map<String, dynamic> logout, String path, Map<String, dynamic> login) {
    showDialog(
      context: Navigator.of(context, rootNavigator: true).context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Already Logged In"),
        content: Text(
          message ??
              "You are logged in on another device. Do you want to logout?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              print("force logout working---------------------------------");
              forceLogoutAndLogin(
                context,
                message,
                logout,
                path,
                login,
              );
            },
            child: const Text("Logout & Continue"),
          ),
        ],
      ),
    );
  }

  Future<void> forceLogoutAndLogin(
    BuildContext context,
    String? message,
    Map<String, dynamic> logout,
    String path,
    Map<String, dynamic> login,
  ) async {
    _setLoading(true);

    try {
      final result =
          await userServicesForApi.automaticLogoutService(logout, path, true);

      if (!context.mounted) return;

      if (!result.isSuccess) {
        ShowTaostMessage.toastMessage(
          context,
          result.message ?? "Force logout failed",
        );
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();

      ShowTaostMessage.toastMessage(
        context,
        "Logged out from other device",
      );

      /// 🔁 Retry login
      final loginResult = await userServicesForApi.loginWithJwt(login, path);

      if (!context.mounted) return;

      if (loginResult.isSuccess && loginResult.data != null) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString("access-token", loginResult.data["Access-Token"]);
        await prefs.setString(
            "refresh-token", loginResult.data["Refresh-Token"]);

        final user = await iamUser();
        if (user == null) return;

        await prefs.setString("user_role", user.role);
        await prefs.setInt("user_id", user.id);
        await prefs.setString("eid", user.email);

        _setLoading(false);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => FooterScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      ShowTaostMessage.toastMessage(context, "Unexpected error occurred");
    } finally {
      _setLoading(false);
    }
  }

  // ///logout service for alll............................. when user try to log another device account............
  // Future<void> forceLogoutAndLogin(
  //     BuildContext context,
  //     String? message,
  //     Map<String, dynamic> logout,
  //     String path,
  //     Map<String, dynamic> login) async {
  //   print("1-------------------------------");
  //   _setLoading(true);

  //   try {
  //     final result =
  //         await userServicesForApi.automaticLogoutService(logout, path, true);
  //     print("2------------------------------------------");

  //     if (!result.isSuccess) {
  //     ShowTaostMessage.toastMessage(
  //       context,
  //       result.message ?? "Force logout failed",
  //     );
  //     return;
  //   }
  //     ShowTaostMessage.toastMessage(
  //     context,
  //     "Logged out from other device",
  //   );

  //      final loginResult =
  //       await userServicesForApi.loginWithJwt(login, path);

  //       if (!context.mounted) return;

  //       if (loginResult.isSuccess && loginResult.data != null) {
  //         final prefs = await SharedPreferences.getInstance();
  //         await prefs.setString(
  //             "access-token", loginResult.data["Access-Token"]);
  //         await prefs.setString(
  //             "refresh-token", loginResult.data["Refresh-Token"]);

  //         ShowTaostMessage.toastMessage(context, "Login Successfull");
  //         final user = await iamUser();

  //         if (user == null) {
  //           ShowTaostMessage.toastMessage(context, "Failed to load user");
  //           return;
  //         }

  //         // 🔹 Save role for app restart
  //         await prefs.setString("user_role", user.role);
  //         await prefs.setInt("user_id", user.id);
  //         await prefs.setString("eid", user.email);

  //         // 🔹 Navigate based on role
  //         // Widget nextScreen;

  //         // switch (user.role) {
  //         //   case "TEAM_LEADER":
  //         //     nextScreen = TeamLeaderHomeScreen();
  //         //     break;

  //         //   case "MEMBER":
  //         //     nextScreen = MemberHomeScreen();
  //         //     break;

  //         //   default:
  //         //     nextScreen = ListOfUiScreen();
  //         // }
  //           _setLoading(false);

  //         // Navigator.pushReplacement(
  //         //     context, MaterialPageRoute(builder: (_) => ListOfUiScreen()));
  //          Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (_) => ListOfUiScreen()),
  //       (route) => false,
  //     );
  //       }
  //     } catch (e) {
  //   ShowTaostMessage.toastMessage(context, "Unexpected error occurred");
  // }

  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  void _showLocationDialog(BuildContext context, bool isServiceDialog) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          isServiceDialog
              ? 'Location Services Required'
              : 'Location Permission Required',
        ),
        content: Text(
          isServiceDialog
              ? 'Please enable location services.'
              : 'Please grant location permission.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (isServiceDialog) {
                await Geolocator.openLocationSettings();
              } else {
                await Geolocator.openAppSettings();
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  UsermeModel? _user;

  UsermeModel? get user => _user;

  void setUser(UsermeModel? user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  //-------------------------logout manually---------------------
  bool _isLoggingOut = false;

  bool get isLoggingOut => _isLoggingOut;
  void _setLogout(bool value) {
    _isLoggingOut = value;
    notifyListeners();
  }

  Future<void> logout(
    BuildContext context,
  ) async {
    try {
      _setLogout(true);

      /// 1️⃣ Internet check
      final hasInternet = await Deviceconfig.checkInternetConnection();
      if (!hasInternet) {
        _setLogout(false);
        ShowTaostMessage.toastMessage(context, "No internet connection");
        return;
      }

      /// 2️⃣ Device info
      final deviceInfo = await Deviceconfig.getDeviceInfo();
      if (deviceInfo.isEmpty) {
        _setLogout(false);
        ShowTaostMessage.toastMessage(context, "Failed to get device info");
        return;
      }

      /// 3️⃣ Location
      final position = await Deviceconfig.deteminPosition();
      if (position == null) {
        _setLogout(false);
        _showLocationDialog(context, false);
        ShowTaostMessage.toastMessage(context, "Location permission required");
        return;
      }

      final address = await Deviceconfig.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      /// 4️⃣ Image capture
      final image = await Deviceconfig.pickImage(ImageSource.camera);
      if (image == null) {
        _setLogout(true);
        ShowTaostMessage.toastMessage(context, "Image capture failed");
        return;
      }

      final logoutRequest = LogoutRequestModel(
        logoutAddress: address,
        logoutDeviceBrand: deviceInfo[2],
        logoutDeviceId: deviceInfo[1],
        logoutLatitude: position.latitude.toString(),
        logoutLongitude: position.longitude.toString(),
        logoutDeviceModel: deviceInfo[3],
        logoutModel: deviceInfo[0],
        logOutExcuse: "New device login",
      );
      final out = await TokenService.authorizedPostForLogout(
          logoutRequest.toJson(), image.path, true);
      if (out.statusCode == 200) {
        await TokenService.clearSharredPrefrance();
        Future.delayed(Duration(seconds: 3));
        ShowTaostMessage.toastMessage(context, "LogOut successfully");
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (_) => const SelectScreenForService()),
        // );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const SelectScreenForService(),
          ),
          (route) => false,
        );
      }
      _setLogout(false);

      return;
    } catch (e) {
      ShowTaostMessage.toastMessage(context, "Unexpected error occurred");
    } finally {
      _setLogout(false);
    }
  }

//----------------------------------------------------who is user..........................
  bool _isRole = false;
  bool get isRole => _isRole;
  Future<void> userRole() async {
    final role = await TokenService.getUserRole();
    if (role == "TEAMLEADER") {
      _isRole = true;
      notifyListeners();
    }
  }

  //date 9-4-25 new login implemetted
  bool _isLogin = false;
  bool get isLogin => _isLogin;
  void setLoading(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  // Future<void> loginPerformance(
  //     String loginId, String password, BuildContext context) async {
  //   try {
  //     // Basic validation
  //     if (loginId.isEmpty || password.isEmpty) {
  //       ShowTaostMessage.toastMessage(context, "Please enter ID and password");
  //       return;
  //     }

  //     _isLogin = true;
  //     notifyListeners();

  //     final hasInternet = await Deviceconfig.checkInternetConnection();
  //     if (!hasInternet) {
  //       ShowTaostMessage.toastMessage(context, "No internet connection");
  //       return; // 'finally' will set _isLogin = false
  //     }

  //     final response = await userServicesForApi.checkUserCredentailService(
  //         loginId, password);

  //     if (response.isSuccess) {
  //       // ONLY call this for successful credentials (200/201)
  //       final status = await fatchDeviceAndLocation(context);

  //       if (status == null) return;

  //       // calling here login api
  //       await callLoginApi(context, loginId, password, status);
  //       // _isLogin = false;
  //       // notifyListeners();
  //     } else if (response.isProcess) {
  //       final inProcessdata = response.data;

  //       // Check for 409 Conflict (Already Logged In)
  //       if (inProcessdata["statusCode"] == 409 ||
  //           inProcessdata["message"].toString().contains("already")) {
  //         await showBox(context, loginId, password);
  //       } else {
  //         ShowTaostMessage.toastMessage(context, "${inProcessdata["message"]}");
  //       }
  //     } else {
  //       ShowTaostMessage.toastMessage(
  //           context, "Login failed. Please try again.");
  //     }
  //   } catch (e) {
  //     debugPrint("Login error: $e");
  //     ShowTaostMessage.toastMessage(context, "An unexpected error occurred.");
  //   } finally {
  //     // This runs no matter what happens (Success, Failure, or Error)
  //     // _isLogin = false;
  //     // notifyListeners();
  //     if (_isLogin) {
  //       _isLogin = false;
  //       notifyListeners();
  //     }
  //   }
  // }
  Future<void> loginPerformance(
      String loginId, String password, BuildContext context) async {
    // 🔒 Prevent multiple clicks
    if (_isLogin) return;

    _isLogin = true;
    notifyListeners();

    try {
      // Basic validation
      if (loginId.isEmpty || password.isEmpty) {
        ShowTaostMessage.toastMessage(context, "Please enter ID and password");
        return;
      }

      final hasInternet = await Deviceconfig.checkInternetConnection();
      if (!hasInternet) {
        ShowTaostMessage.toastMessage(context, "No internet connection");
        return;
      }

      final response = await userServicesForApi.checkUserCredentailService(
          loginId, password);

      if (response.isSuccess) {
        final status = await fatchDeviceAndLocation(context);
        if (status == null) return;

        await callLoginApi(context, loginId, password, status);
      } else if (response.isProcess) {
        final inProcessdata = response.data;

        // 🔥 Already logged in case
        if (inProcessdata["statusCode"] == 409 ||
            inProcessdata["message"].toString().contains("already")) {
          // ⚠️ IMPORTANT: DO NOT reset loading here
          await showBox(context, loginId, password);
          return;
        } else {
          ShowTaostMessage.toastMessage(context, "${inProcessdata["message"]}");
        }
      } else {
        ShowTaostMessage.toastMessage(
            context, "Login failed. Please try again.");
      }
    } catch (e) {
      debugPrint("Login error: $e");
      ShowTaostMessage.toastMessage(context, "An unexpected error occurred.");
    }

    // ✅ SINGLE EXIT POINT (VERY IMPORTANT)
    _isLogin = false;
    notifyListeners();
  }

  Future<void> callLoginApi(BuildContext context, String loginId,
      String password, Map<String, dynamic> status) async {
    final loginRequest = LoginRequestModel(
      empLoginId: loginId,
      empPassword: password,
      device: status["device"],
      deviceId: status["deviceId"],
      deviceBrand: status["deviceBrand"],
      model: status["model"],
      latitude: status["latitude"],
      longitude: status["longitude"],
      address: status['address'],
    );
//calling api
    final loginResonse = await userServicesForApi.loginWithJwt(
        loginRequest.toJson(), status["imagePath"]);
    if (loginResonse.isSuccess) {
      //calling me api after successfulll
      final responseMap = loginResonse.data;
      final innerData = responseMap["data"];
      if (innerData == null) {
        ShowTaostMessage.toastMessage(
            context, "Data object missing in response");
        return;
      }
      //save token in sharredPreffrance

      final String? freshToken = innerData["Access-Token"];
      if (freshToken == null) {
        ShowTaostMessage.toastMessage(context, "Token not found in response");
        return;
      }
      await saveTokenInSharredPreffrance(innerData);
      UsermeModel? model = await callmeApi(freshToken);
      if (!context.mounted) return;

      if (model == null) {
        ShowTaostMessage.toastMessage(
            context, "Login succeeded, but user profile failed to load.");
        return;
      }
      //show success message
      ShowTaostMessage.toastMessage(context, "Login Successfull");
      //navigate to home page after sucessfully
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (_) => FooterScreen()));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => FooterScreen()),
        (route) => false,
      );
    } else {
      if (!context.mounted) return;
      ShowTaostMessage.toastMessage(context, "JWT Login Failed");
    }
  }

  Future<void> saveTokenInSharredPreffrance(dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("access_token", data["Access-Token"] ?? " ");
    await prefs.setString("refresh_token", data["Refresh-Token"] ?? " ");
  }

  Future<UsermeModel?> callmeApi(String token) async {
    // Use the service to fetch the result
    final userOutput = await UserServicesForApi().loginAfterMeService2(token);

    if (userOutput.isSuccess) {
      final userData = userOutput.data; // Local variable for safety

      if (userData != null) {
        _user = userData;
        // Save directly using the local variable instead of the bang operator (!)
        await saveUserInfoInSharredPreffrance(userData);
        notifyListeners(); // Ensure the UI updates with the new user data
        return userData;
      }
    }

    return null;
  }

  Future<void> saveUserInfoInSharredPreffrance(UsermeModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_role", user.role);
    await prefs.setInt("user_id", user.id);
    await prefs.setString("eid", user.email);
  }

  Future<bool> callLogOutApi(BuildContext context, String loginId,
      String password, Map<String, dynamic> status) async {
    print("calling logout api---------------------------------------");
    final logoutRequest = LogoutRequestModel(
        logoutAddress: status['address'],
        logoutDeviceBrand: status["deviceBrand"],
        logoutDeviceId: status["deviceId"],
        logoutLatitude: status["latitude"],
        logoutLongitude: status["longitude"],
        logoutDeviceModel: status["model"],
        logoutModel: status["device"],
        empEid: loginId,
        logOutExcuse: "forgot to logout");

    final response = await userServicesForApi.userLogOut(
        logoutRequest.toJson(), status["imagePath"]);
    if (response.isSuccess) {
      ShowTaostMessage.toastMessage(context, "Previous session cleared.");
      clearSharredPrefrance();
      return true;
    } else {
      ShowTaostMessage.toastMessage(
          context, "Logout failed. Please try again.");
      return false;
    }
  }

  Future<void> clearSharredPrefrance() async {
    print("after log out clear sharred preffrance------------");
    await TokenService.clearTokens();
  }

  // Future<void> showBox(
  //     BuildContext context, String loginId, String password) async {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (dialogContext) => AlertDialog(
  //       // Use dialogContext for the UI
  //       title: const Text("Session Active"),
  //       content: const Text(
  //         "Your previous session is still active. Would you like to logout from other devices?",
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(dialogContext);

  //             // ❗ reset state on cancel
  //             _isLogin = false;
  //             notifyListeners();
  //           },
  //           child: const Text("Cancel"),
  //         ),
  //         ElevatedButton(
  //           onPressed: () async {
  //             Navigator.pop(dialogContext);
  //             // 1. Fetch data
  //             // _isLogin = true;
  //             // notifyListeners();

  //             // setLoading(true);
  //             final status = await fatchDeviceAndLocation(context);
  //             if (status == null) {
  //               //  setLoading(false);
  //               _isLogin = false;
  //               notifyListeners();
  //               return;
  //             }
  //             // fatchDeviceAndLocation already showed the toast

  //             // 2. Close dialog and call Logout
  //             // Navigator.pop(dialogContext);
  //             await callLogOutApi(context, loginId, password, status);
  //             // setLoading(false);
  //             _isLogin = false;
  //             notifyListeners();
  //           },
  //           child: const Text("Logout"),
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
  //           onPressed: () async {
  //             Navigator.pop(dialogContext);
  //             // _isLogin = true;
  //             // notifyListeners();
  //             // 1. Fetch data
  //             final status = await fatchDeviceAndLocation(context);
  //             if (status == null) {
  //               _isLogin = false;
  //               notifyListeners();
  //               return;
  //             }

  //             // 2. Close dialog

  //             // 3. First logout, then login
  //             bool logoutSuccess =
  //                 await callLogOutApi(context, loginId, password, status);
  //             if (logoutSuccess) {
  //               await callLoginApi(context, loginId, password, status);
  //             }
  //             //setLoading(false);
  //             _isLogin = false;
  //             notifyListeners();
  //           },
  //           child: const Text("Logout & Login"),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  ////============================================

  // Future<void> showBox(
  //     BuildContext context, String loginId, String password) async {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (dialogContext) => AlertDialog(
  //       title: const Text("Session Active"),
  //       content: const Text(
  //         "Your previous session is still active. Logout from other devices?",
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(dialogContext);

  //             // ❗ reset state on cancel
  //             _isLogin = false;
  //             notifyListeners();
  //           },
  //           child: const Text("Cancel"),
  //         ),

  //         /// 🔴 Logout only
  //         ElevatedButton(
  //           onPressed: () async {
  //             Navigator.pop(dialogContext);

  //             final status = await fatchDeviceAndLocation(context);
  //             if (status == null) {
  //               _isLogin = false;
  //               notifyListeners();
  //               return;
  //             }

  //             await callLogOutApi(context, loginId, password, status);

  //             // ✅ DONE → reset state
  //             _isLogin = false;
  //             notifyListeners();
  //           },
  //           child: const Text("Logout"),
  //         ),

  //         /// 🟢 Logout + Login
  //         ElevatedButton(
  //           onPressed: () async {
  //             Navigator.pop(dialogContext);

  //             final status = await fatchDeviceAndLocation(context);
  //             if (status == null) {
  //               _isLogin = false;
  //               notifyListeners();
  //               return;
  //             }

  //             bool logoutSuccess =
  //                 await callLogOutApi(context, loginId, password, status);

  //             if (logoutSuccess) {
  //               await callLoginApi(context, loginId, password, status);
  //             }

  //             // ✅ FINAL RESET
  //             _isLogin = false;
  //             notifyListeners();
  //           },
  //           child: const Text("Logout & Login"),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //=========================
  Future<void> showBox(
      BuildContext context, String loginId, String password) async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Session Active"),
        content: const Text(
          "Your previous session is still active. Logout from other devices?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, "cancel"),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, "logout"),
            child: const Text("Logout"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, "logout_login"),
            child: const Text("Logout & Login"),
          ),
        ],
      ),
    );

    /// 🔥 HANDLE ALL CASES HERE (INCLUDING BACK BUTTON)
    if (result == null) {
      // 👈 User pressed BACK button
      _isLogin = false;
      notifyListeners();
      return;
    }

    final status = await fatchDeviceAndLocation(context);
    if (status == null) {
      _isLogin = false;
      notifyListeners();
      return;
    }

    if (result == "logout") {
      await callLogOutApi(context, loginId, password, status);
    } else if (result == "logout_login") {
      bool success = await callLogOutApi(context, loginId, password, status);

      if (success) {
        await callLoginApi(context, loginId, password, status);
      }
    }

    /// ✅ FINAL RESET
    _isLogin = false;
    notifyListeners();
  }
  // Future<void> showBox(
  //     BuildContext context, String loginId, String password) async {
  //   return showDialog(
  //     context: Navigator.of(context, rootNavigator: true).context,
  //     barrierDismissible: false,
  //     builder: (_) => AlertDialog(
  //       title: const Text("Already Logged In"),
  //       content: Text(
  //         "your prevoius session  is active do you want to logout?",
  //       ),
  //       actions: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text("Cancel"),
  //               //user cancel
  //             ),
  //             ElevatedButton(
  //               onPressed: () async {
  //                 final status = await fatchDeviceAndLocation(context);
  //                 if (status == null) return Navigator.pop(context);
  //                 callLogOutApi(context, loginId, password, status);
  //               },
  //               child: const Text("Logout"),
  //             ),
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
  //               onPressed: () async {
  //                 final status = await fatchDeviceAndLocation(context);
  //                 if (status == null) return;
  //                 Navigator.pop(context);
  //                 //before calling login need call logout function....
  //                 //call logout api....
  //                 bool logoutSuccess =
  //                     await callLogOutApi(context, loginId, password, status);
  //                 if (logoutSuccess) {
  //                   await callLoginApi(context, loginId, password, status);
  //                 }
  //               },
  //               child: const Text("Logout & login"),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  Future<Map<String, dynamic>?> fatchDeviceAndLocation(
      BuildContext context) async {
    final deviceInfo = await Deviceconfig.getDeviceInfo();
    if (deviceInfo.isEmpty) {
      ShowTaostMessage.toastMessage(context, "Failed to get device info");
      return null;
    }

    /// 3 Location
    final position = await Deviceconfig.deteminPosition();
    if (position == null) {
      // _setLoading(false);
      _showLocationDialog(context, false);
      ShowTaostMessage.toastMessage(context, "Location permission required");
      return null;
    }

    final address = await Deviceconfig.getAddressFromLatLng(
      position.latitude,
      position.longitude,
    );

    /// 4️⃣ Image capture
    final image = await Deviceconfig.pickImage(ImageSource.camera);
    if (image == null) {
      _setLoading(false);
      ShowTaostMessage.toastMessage(context, "Image capture failed");
      return null;
    }

    Map<String, dynamic> data = {
      "device": deviceInfo[0],
      "deviceId": deviceInfo[1],
      "deviceBrand": deviceInfo[2],
      "model": deviceInfo[3],
      "latitude": position.latitude.toString(),
      "longitude": position.longitude.toString(),
      "address": address,
      "imagePath": image.path, // You'll need this for the login API
    };

    return data;
  }
}
