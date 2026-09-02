import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/admin_shell.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/model/uesr_logout_request_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/model/user_login_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/model/user_me_model.dart';

import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/view/footer_screen.dart';
import 'package:truenorthflutterfrontend/public/config/deviceConfig.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/service/auth_service.dart';
import 'package:truenorthflutterfrontend/service/token/token_factory_storage.dart';
import 'package:truenorthflutterfrontend/service/token/web_token_service.dart';

class LoginControll extends ChangeNotifier {
  UserServicesForApi userServicesForApi = UserServicesForApi();
  //store class for web store
  final WebTokenService _webTokenService = WebTokenService();
  bool _isLoading = false;
  get isLoading => _isLoading;
  // / Resultt resultt;
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  void setLoading(bool value) {
    _isLogin = value;
    notifyListeners();
  }

//USER AND ADMIN LOGIN START---------------------------------------
  Future<void> loginCrentail(
      String loginId, String password, BuildContext context) async {
    //?step1: 🔒 Prevent multiple clicks on login button.........................
    if (_isLogin) return;

    //?step2 Basic validation FIRST.............................
    if (loginId.trim().isEmpty || password.trim().isEmpty) {
      ShowTaostMessage.toastMessage(context, "Please enter ID and password");
      return;
    }
    //?step3: Start loading AFTER validation
    _isLogin = true;
    notifyListeners();

    try {
      //?step4: check internet connection before login.......................
      final hasInternet = await Deviceconfig.checkInternetConnection();
      //?if internet ok move next otherwise show toast message
      if (!hasInternet) {
        ShowTaostMessage.toastMessage(context, "No internet connection");
        return;
      }
      //?step4: check use login credentail means loginid and password...........
      final response = await userServicesForApi.checkUserCredentailService(
          loginId, password);
      if (!context.mounted) return; // guard before any further context use

      if (response.isSuccess) {
        //?step5: "IMP METHOD FOR USE AND ADMIN...IF ADMIN LOGIN IN WEB/CHROME NO NEED TO IMAGE AND DEVICE INFO SO LOCALLLY SET INFFO"
        final platform = getPlatformType();
        //?check platform
        if (platform == PlatformType.web) {
          //?set info for web......locallly using map<String,dynamic>
          final Map<String, dynamic> status = {
            "device": "web",
            "deviceId": "web1",
            "deviceBrand": "Brand",
            "model": "model1",
            "latitude": "0.01.1.1",
            "longitude": "0.0.11.1",
            "address": "admin manully address",
          };
          //?step:6 call login api using callloginApi funcation if  admin on web/chrome

          await callLoginApi(context, loginId, password, status, null);
        } else {
//step:7 here reqruied device_info_and_user_location before login_its_compulsary....
          final status = await fatchDeviceAndLocation(context);
          if (!context.mounted) return;
//return false.............not provided info

          if (status == null) return;
//set image for map method
          String? imagePath = status["imagePath"];
// call same after all info getting
          await callLoginApi(context, loginId, password, status, imagePath);
        }
      } else if (response.isProcess) {
//?step 8: after get login response checked user already login or new lofin
        final inProcessdata = response.data;

//?step:9  Already logged in case show box for logout...........and loutand continue
        if (inProcessdata["statusCode"] == 409 ||
            inProcessdata["message"]
                .toString()
                .toLowerCase()
                .contains("already")) {
          //?call method for open box
          await showBox(context, loginId, password);
          return;
        } else {
          if (context.mounted) {
            ShowTaostMessage.toastMessage(
                context, "${inProcessdata["message"]}");
          }
        }
      } else {
        if (context.mounted) {
          ShowTaostMessage.toastMessage(
              context, "Login failed. Please try again.");
        }
      }
    } catch (e) {
      debugPrint("Login error: $e");

      if (context.mounted) {
        ShowTaostMessage.toastMessage(context, "An unexpected error occurred.");
      }
    } finally {
      // ✅ ALWAYS stop loader
      _isLogin = false;

      notifyListeners();
    }
  }

//? this funcation used to child funcation for calling final login api integration..........
  Future<void> callLoginApi(BuildContext context, String loginId,
      String password, Map<String, dynamic> status,
      [String? imagePath]) async {
//?step:1 set all  variable in loginmodel classs..
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
//?step2:  final login method integration...............
    final loginResonse =
        await userServicesForApi.loginWithJwt(loginRequest.toJson(), imagePath);
//?receive sucessfully response............
    if (!context.mounted) return;
    if (loginResonse.isSuccess) {
      final responseMap = loginResonse.data;
      final innerData = responseMap["data"];
      if (innerData == null) {
        ShowTaostMessage.toastMessage(
            context, "Data object missing in response");
        return;
      }
//?step3: set acess token for call api............

      final String? accessToken = innerData["Access-Token"];
      final String? refreshToken = innerData["Refresh-Token"];
      if (accessToken == null || refreshToken == null) {
        ShowTaostMessage.toastMessage(context, "Token not found in response");
        return;
      }
//?step:4 save token in sharredpreffence

      await TokenFactoryStorage.instance
          .saveTokens(access: accessToken, refresh: refreshToken);
//?step:5 call another api for indentify user some information just like user role and name
      final UsermeModel? model = await callmeApi(accessToken);
      if (!context.mounted) return;

      if (model == null) {
        ShowTaostMessage.toastMessage(
            context, "Login succeeded, but user profile failed to load.");
        return;
      }
      //print("USER ROLE: '${model.role}'");
      // Step 6: Unified Navigation logic according to user roles
      final userRole = model.role.trim().toUpperCase();
      await TokenFactoryStorage.instance.saveUserRole(userRole);
      if (userRole == "ADMIN") {
        ShowTaostMessage.toastMessage(context, "Admin Login Successful");

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => AdminShell()), (route) => false);
        return; // Stop execution
      }
      //show success message
      // Default User Navigation (Non-Admin)
      ShowTaostMessage.toastMessage(context, "Login Successfull");

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => FooterScreen()),
        (route) => false,
      );
    } else {
      // Handle global API network error response
      if (!context.mounted) return;
      ShowTaostMessage.toastMessage(context, "JWT Login Failed");
    }
  }

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
        ],
      ),
    );
    if (!context.mounted) return;

    /// 🔥 HANDLE ALL CASES HERE (INCLUDING BACK BUTTON)
    if (result == null || result == "cancel") {
      // 👈 User pressed BACK button
      _isLogin = false;
      notifyListeners();
      return;
    }
    // Only fetch device/location/camera info once we know the user
    // actually wants to proceed with logout or logout+login.
    final platform = getPlatformType();
    Map<String, dynamic>? status;
    if (platform == PlatformType.web) {
      status = {
        "device": "web",
        "deviceId": "web1",
        "deviceBrand": "Brand",
        "model": "model1",
        "latitude": "0.0",
        "longitude": "0.0",
        "address": "local address",
        "imagePath": null,
      };
    } else {
      status = await fatchDeviceAndLocation(context);
      if (!context.mounted) {
        return;
      }
      if (status == null) {
        _isLogin = false;
        notifyListeners();
        return;
      }
    }

    if (result == "logout") {
      await callLogOutApi(context, loginId, password, status);
    }

    _isLogin = false;
    notifyListeners();
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
  // bool _isLoggingOut = false;

  // bool get isLoggingOut => _isLoggingOut;
  // void _setLogout(bool value) {
  //   _isLoggingOut = value;
  //   notifyListeners();
  // }

  // Future<void> logout(
  //   BuildContext context,
  // ) async {
  //   try {
  //     _setLogout(true);

  //     /// 1️⃣ Internet check
  //     final hasInternet = await Deviceconfig.checkInternetConnection();
  //     if (!hasInternet) {
  //       // _setLogout(false);
  //       // ShowTaostMessage.toastMessage(context, "No internet connection");
  //       if (context.mounted) {
  //         ShowTaostMessage.toastMessage(context, "No internet connection");
  //       }
  //       return;
  //     }
  //     final platform = getPlatformType();
  //     LogoutRequestModel logoutRequest;
  //     String? imagePath;
  //     if (platform == PlatformType.web) {
  //       // Web admin: skip device/location/camera — same pattern as login.
  //       logoutRequest = LogoutRequestModel(
  //         logoutAddress: "local address",
  //         logoutDeviceBrand: "Brand",
  //         logoutDeviceId: "web1",
  //         logoutLatitude: "0.0",
  //         logoutLongitude: "0.0",
  //         logoutDeviceModel: "model1",
  //         logoutModel: "web",
  //         logOutExcuse: "New device login",
  //       );
  //       imagePath = null;
  //     } else {
  //       /// 2️⃣ Device info
  //       final deviceInfo = await Deviceconfig.getDeviceInfo();
  //       if (deviceInfo.isEmpty) {
  //         if (context.mounted) {
  //           ShowTaostMessage.toastMessage(context, "Failed to get device info");
  //         }
  //         return;
  //       }

  //       /// 3️⃣ Location
  //       final position = await Deviceconfig.deteminPosition();
  //       if (!context.mounted) return;
  //       if (position == null) {
  //         // _setLogout(false);
  //         _showLocationDialog(context, false);
  //         ShowTaostMessage.toastMessage(
  //             context, "Location permission required");
  //         return;
  //       }
  //       final address = await Deviceconfig.getAddressFromLatLng(
  //         position.latitude,
  //         position.longitude,
  //       );

  //       /// 4️⃣ Image capture
  //       final image = await Deviceconfig.pickImage(ImageSource.camera);
  //       if (!context.mounted) return;
  //       if (image == null) {
  //         ShowTaostMessage.toastMessage(context, "Image capture failed");
  //         return; // finally resets loader — no need to set it manually here
  //       }
  //       logoutRequest = LogoutRequestModel(
  //         logoutAddress: address,
  //         logoutDeviceBrand: deviceInfo[2],
  //         logoutDeviceId: deviceInfo[1],
  //         logoutLatitude: position.latitude.toString(),
  //         logoutLongitude: position.longitude.toString(),
  //         logoutDeviceModel: deviceInfo[3],
  //         logoutModel: deviceInfo[0],
  //         logOutExcuse: "New device login",
  //       );
  //       imagePath = image.path;
  //       final out = await TokenService.authorizedPostForLogout(
  //           logoutRequest.toJson(), imagePath, true);
  //       if (!context.mounted) return;

  //       if (out.statusCode == 200) {
  //         // Unified clear — works for both mobile (SharedPreferences)
  //         // and web (FlutterSecureStorage) through the factory.

  //         await TokenFactoryStorage.instance.clearTokens();

  //         ShowTaostMessage.toastMessage(context, "LogOut successfully");

  //         Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(
  //             builder: (_) => const SelectScreenForService(),
  //           ),
  //           (route) => false,
  //         );
  //       } else {
  //         // Previously silent — now surfaces the failure
  //         ShowTaostMessage.toastMessage(
  //           context,
  //           "Logout failed (status ${out.statusCode}). Please try again.",
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("Logout error: $e");
  //     if (context.mounted) {
  //       ShowTaostMessage.toastMessage(context, "Unexpected error occurred");
  //     }
  //   } finally {
  //     _setLogout(false);
  //   }
  // }
  // bool _isLoggingOut = false;
  // bool get isLoggingOut => _isLoggingOut;

  // void _setLogout(bool value) {
  //   _isLoggingOut = value;
  //   notifyListeners();
  // }

  // Future<void> logout(BuildContext context) async {
  //   try {
  //     _setLogout(true);

  //     /// 1️⃣ Internet check
  //     final hasInternet = await Deviceconfig.checkInternetConnection();
  //     if (!hasInternet) {
  //       if (context.mounted) {
  //         ShowTaostMessage.toastMessage(context, "No internet connection");
  //       }
  //       return;
  //     }

  //     final platform = getPlatformType();

  //     LogoutRequestModel logoutRequest;
  //     String? imagePath;

  //     if (platform == PlatformType.web) {
  //       // Web admin: skip device/location/camera — same pattern as login.
  //       logoutRequest = LogoutRequestModel(
  //         logoutAddress: "local address",
  //         logoutDeviceBrand: "Brand",
  //         logoutDeviceId: "web1",
  //         logoutLatitude: "0.0",
  //         logoutLongitude: "0.0",
  //         logoutDeviceModel: "model1",
  //         logoutModel: "web",
  //         logOutExcuse: "New device login",
  //       );
  //       imagePath = null;
  //     } else {
  //       /// 2️⃣ Device info
  //       final deviceInfo = await Deviceconfig.getDeviceInfo();
  //       if (deviceInfo.isEmpty) {
  //         if (context.mounted) {
  //           ShowTaostMessage.toastMessage(context, "Failed to get device info");
  //         }
  //         return;
  //       }

  //       /// 3️⃣ Location
  //       final position = await Deviceconfig.deteminPosition();
  //       if (!context.mounted) return;
  //       if (position == null) {
  //         _showLocationDialog(context, false);
  //         ShowTaostMessage.toastMessage(
  //             context, "Location permission required");
  //         return;
  //       }

  //       final address = await Deviceconfig.getAddressFromLatLng(
  //         position.latitude,
  //         position.longitude,
  //       );

  //       /// 4️⃣ Image capture
  //       final image = await Deviceconfig.pickImage(ImageSource.camera);
  //       if (!context.mounted) return;
  //       if (image == null) {
  //         ShowTaostMessage.toastMessage(context, "Image capture failed");
  //         return; // finally resets loader — no need to set it manually here
  //       }

  //       logoutRequest = LogoutRequestModel(
  //         logoutAddress: address,
  //         logoutDeviceBrand: deviceInfo[2],
  //         logoutDeviceId: deviceInfo[1],
  //         logoutLatitude: position.latitude.toString(),
  //         logoutLongitude: position.longitude.toString(),
  //         logoutDeviceModel: deviceInfo[3],
  //         logoutModel: deviceInfo[0],
  //         logOutExcuse: "New device login",
  //       );
  //       imagePath = image.path;
  //     }

  //     final out = await TokenService.authorizedPostForLogout(
  //       logoutRequest.toJson(),
  //       imagePath,
  //       true,
  //     );

  //     if (!context.mounted) return;

  //     if (out.statusCode == 200) {
  //       // Unified clear — works for both mobile (SharedPreferences)
  //       // and web (FlutterSecureStorage) through the factory.
  //       await TokenFactoryStorage.instance.clearTokens();

  //       ShowTaostMessage.toastMessage(context, "Logged out successfully");

  //       Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (_) => const SelectScreenForService()),
  //         (route) => false,
  //       );
  //     } else {
  //       // Previously silent — now surfaces the failure
  //       ShowTaostMessage.toastMessage(
  //         context,
  //         "Logout failed (status ${out.statusCode}). Please try again.",
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint("Logout error: $e");
  //     if (context.mounted) {
  //       ShowTaostMessage.toastMessage(context, "Unexpected error occurred");
  //     }
  //   } finally {
  //     _setLogout(false);
  //   }
  // }

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

  Future<void> saveTokenInSharredPreffrance(dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("access_token", data["Access-Token"] ?? " ");
    await prefs.setString("refresh_token", data["Refresh-Token"] ?? " ");
  }

  Future<UsermeModel?> callmeApi(String token) async {
    // Use the service to fetch the result
    final userOutput = await UserServicesForApi().loginAfterMeService2(token);

    if (userOutput.isSuccess) {
      final userData = userOutput.data;

      if (userData != null) {
        final platform = getPlatformType();

        if (platform == PlatformType.web) {
          //' to ensure Web execution finishes
          await _webTokenService.saveUserInfoInWebStore(userData);
          print("store user info web if platfrom web");
        } else {
          //'else' so mobile storage never triggers on Web
          await saveUserInfoInSharredPreffrance(userData);
        }

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
    debugPrint("calling logout api");
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
    if (!context.mounted) return false;
    if (response.isSuccess) {
      // Unified, awaited clear — works correctly on both mobile and web.
      //await TokenFactoryStorage.instance.clearTokens();
      if (context.mounted) {
        ShowTaostMessage.toastMessage(context, "Previous session cleared.");
      }

      return true;
    } else {
      if (context.mounted) {
        ShowTaostMessage.toastMessage(
            context, "Logout failed. Please try again.");
      }

      return false;
    }
  }

  Future<void> clearSharredPrefrance() async {
    print("after log out clear sharred preffrance------------");
    await TokenService.clearTokens();
  }

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
