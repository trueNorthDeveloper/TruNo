import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userLogRegModel/uesr_logout_request_model.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userLogRegModel/user_login_model.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userLogRegModel/user_me_model.dart';
import 'package:truenorthflutterfrontend/app/view/userView/userLogRegsView/select_screen.dart';
import 'package:truenorthflutterfrontend/app/controller/user_home_layout_controller/footer_screen.dart';
import 'package:truenorthflutterfrontend/public/config/deviceConfig.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';
import 'package:truenorthflutterfrontend/service/userServices/user_services_for_api.dart';

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

      if (!context.mounted) return;

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
        TokenService.clearSharredPrefrance();
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
}
