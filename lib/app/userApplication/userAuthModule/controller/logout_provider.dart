import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:truenorthflutterfrontend/app/unUsedButImp/select_screen.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/model/uesr_logout_request_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/service/auth_service.dart';
import 'package:truenorthflutterfrontend/public/config/deviceConfig.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';
import 'package:truenorthflutterfrontend/service/token/token_factory_storage.dart';
import 'package:truenorthflutterfrontend/service/token/web_token_service.dart';

class LogoutProvider extends ChangeNotifier {
  UserServicesForApi userServicesForApi = UserServicesForApi();
  //store class for web store
  final WebTokenService _webTokenService = WebTokenService();
  bool _isLoggingOut = false;
  bool get isLoggingOut => _isLoggingOut;

  void _setLogout(bool value) {
    _isLoggingOut = value;
    notifyListeners();
  }

//NEW LOG_OUT_CODE.........
  Future<void> logout(BuildContext context) async {
    try {
      _setLogout(true);

      /// 1️⃣ Internet check
      final hasInternet = await Deviceconfig.checkInternetConnection();
      if (!hasInternet) {
        if (context.mounted) {
          ShowTaostMessage.toastMessage(context, "No internet connection");
        }
        return;
      }

      final platform = getPlatformType();

      LogoutRequestModel logoutRequest;
      String? imagePath;

      if (platform == PlatformType.web) {
        // Web admin: skip device/location/camera — same pattern as login.
        logoutRequest = LogoutRequestModel(
          logoutAddress: "local address",
          logoutDeviceBrand: "Brand",
          logoutDeviceId: "web1",
          logoutLatitude: "0.0",
          logoutLongitude: "0.0",
          logoutDeviceModel: "model1",
          logoutModel: "web",
          logOutExcuse: "New device login",
        );
        imagePath = null;
      } else {
        /// 2️⃣ Device info
        final deviceInfo = await Deviceconfig.getDeviceInfo();
        if (deviceInfo.isEmpty) {
          if (context.mounted) {
            ShowTaostMessage.toastMessage(context, "Failed to get device info");
          }
          return;
        }

        /// 3️⃣ Location
        final position = await Deviceconfig.deteminPosition();
        if (!context.mounted) return;
        if (position == null) {
          _showLocationDialog(context, false);
          ShowTaostMessage.toastMessage(
              context, "Location permission required");
          return;
        }

        final address = await Deviceconfig.getAddressFromLatLng(
          position.latitude,
          position.longitude,
        );

        /// 4️⃣ Image capture
        final image = await Deviceconfig.pickImage(ImageSource.camera);
        if (!context.mounted) return;
        if (image == null) {
          ShowTaostMessage.toastMessage(context, "Image capture failed");
          return; // finally resets loader — no need to set it manually here
        }

        logoutRequest = LogoutRequestModel(
          logoutAddress: address,
          logoutDeviceBrand: deviceInfo[2],
          logoutDeviceId: deviceInfo[1],
          logoutLatitude: position.latitude.toString(),
          logoutLongitude: position.longitude.toString(),
          logoutDeviceModel: deviceInfo[3],
          logoutModel: deviceInfo[0],
          logOutExcuse: "New device login",
        );
        imagePath = image.path;
      }

      final out = await TokenService.authorizedPostForLogout(
        logoutRequest.toJson(),
        imagePath,
        true,
      );

      if (!context.mounted) return;

      if (out.statusCode == 200) {
        // Unified clear — works for both mobile (SharedPreferences)
        // and web (FlutterSecureStorage) through the factory.
        await TokenFactoryStorage.instance.clearTokens();

        ShowTaostMessage.toastMessage(context, "Logged out successfully");

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SelectScreenForService()),
          (route) => false,
        );
      } else {
        // Previously silent — now surfaces the failure
        ShowTaostMessage.toastMessage(
          context,
          "Logout failed (status ${out.statusCode}). Please try again.",
        );
      }
    } catch (e) {
      debugPrint("Logout error: $e");
      if (context.mounted) {
        ShowTaostMessage.toastMessage(context, "Unexpected error occurred");
      }
    } finally {
      _setLogout(false);
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
//this code for ----------------------------------automatic logout for user when user sesson active..........
}
