// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:truenorthflutterfrontend/app/adminApplication/view/admin_dashboard_page.dart';
import 'package:truenorthflutterfrontend/app/unUsedButImp/user_list_of_screen.dart';
import 'package:truenorthflutterfrontend/app/unUsedButImp/select_screen.dart';

import 'package:truenorthflutterfrontend/public/config/api_const.dart';
import 'package:truenorthflutterfrontend/public/utils/resultt.dart';

import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/service/auth_service.dart';

import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/model/user_login_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/model/user_logout_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/model/user_login_info_model.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';

class LoginProvider extends ChangeNotifier {
  UserServicesForApi _userServicesForApi = UserServicesForApi();

  bool _isPasswordHideShow = true;
  bool get isPasswordHideShow => _isPasswordHideShow;

  void togglePassswordVisibility() {
    _isPasswordHideShow = !_isPasswordHideShow;
    notifyListeners();
  }

  bool _isLoading = false;
  get isLoading => _isLoading;
  Future<void> userlogin2(
    String userId,
    String password,
    BuildContext context,
  ) async {
    if (userId.isEmpty) {
      if (context.mounted) {
        ShowTaostMessage.toastMessage(context, "Enter Your login Id");
      }
      return;
    } else if (password.isEmpty) {
      if (context.mounted) {
        ShowTaostMessage.toastMessage(context, "Enter your password");
      }
      return;
    }
    try {
      _isLoading = true;
      notifyListeners();
      bool networkResult = await checkInternetConnection(context);
      if (!networkResult) {
        await Future.delayed(Duration(seconds: 2));
        _isLoading = false;
        notifyListeners();
        if (context.mounted) {
          ShowTaostMessage.toastMessage(context, "No internet connection");
        }
        return;
      }
      List deviceInfo = await getDeviceInfo();
      if (deviceInfo.isEmpty) {
        _isLoading = false;
        notifyListeners();
        ShowTaostMessage.toastMessage(context, "Failed to get device info");
        return;
      }
      Position? position = await _deteminPosition(context);
      if (position == null) {
        _isLoading = false;
        notifyListeners();
        ShowTaostMessage.toastMessage(context, "Failed to get location");
        return;
      }
      String address = await _getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );
      XFile? imagePath = await pickImage(ImageSource.camera);
      if (imagePath == null) {
        _isLoading = false;
        notifyListeners();
        ShowTaostMessage.toastMessage(context, "Image capture failed");
        return;
      }
      // print(imagePath.path);
      //    _isLoading = false;
      //    notifyListeners();

      LoginRequestModel loginRequestModel = LoginRequestModel(
        empLoginId: userId,
        empPassword: password,
        device: deviceInfo[0],
        deviceId: deviceInfo[1],
        deviceBrand: deviceInfo[2],
        model: deviceInfo[3],
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
        address: address,
        // loginImage: imagePath.path
      );

      final result = await loginWithJwt(
        loginRequestModel.toJson(),
        imagePath.path,
      );
      print("${loginRequestModel.toJson()}+" + "${imagePath.path}");
      _isLoading = false;
      notifyListeners();

      if (result.isSuccess) {
        if (result.data != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString("access-token", result.data["Access-Token"]);
          prefs.setString("refresh-token", result.data["Refresh-Token"]);
          ShowTaostMessage.toastMessage(context, "Login Successfully");
          // UsermeModel? user = await UserServicesForApi().loginAfterMeService();
          // print(user!.id);
          // print(user.name);
          // print(user.email);
          // print(user.role);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ListOfUiScreen()),
          );
        }
      } else {
        ShowTaostMessage.toastMessage(
          context,
          result.message ?? "Something went wrong",
        );
        if (result.message == "User already logged in somewhere") ;
        {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Already Logged In"),
                content: Text(result.message ??
                    "You are logged in on somewhere. Do you want to log out?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Call backend API to force logout other devices
                      // forceLogoutOtherDevices(userId, imagePath.path,);
                    },
                    child: Text("Logout"),
                  ),
                ],
              );
            },
          );
          return;
        }
      }

//HERE LOGIN WITH IMAGE.........
    } catch (e) {}
  }

  Future<Resultt> loginWithJwt(
      Map<String, dynamic> toJson, String filePath) async {
    try {
      final url = Uri.parse(Apiconstants.login);
      final request = http.MultipartRequest("POST", url);

      // Add DTO as JSON
      request.files.add(
        http.MultipartFile.fromString(
          'dto',
          jsonEncode(toJson),
          contentType: MediaType('application', 'json'),
        ),
      );

      // Add file
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      final responseStream = await request.send();
      final responseBody = await responseStream.stream.bytesToString();

      if (responseStream.statusCode == 200) {
        return Resultt.success(jsonDecode(responseBody));
      }

      // Any API error
      try {
        final errorJson = jsonDecode(responseBody);
        return Resultt.apiError(errorJson);
      } catch (_) {
        return Resultt.systemError(ApiError.server);
      }
    } on SocketException {
      return Resultt.systemError(ApiError.network);
    } on TimeoutException {
      return Resultt.systemError(ApiError.timeout);
    } on http.ClientException {
      return Resultt.systemError(ApiError.client);
    } catch (_) {
      return Resultt.systemError(ApiError.server);
    }
  }

  Future<void> userlogin(
    String userId,
    String password,
    BuildContext context,
  ) async {
    if (userId.isEmpty) {
      if (context.mounted) {
        ShowTaostMessage.toastMessage(context, "Enter Your login Id");
      }
      return;
    } else if (password.isEmpty) {
      if (context.mounted) {
        ShowTaostMessage.toastMessage(context, "Enter your password");
      }
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      bool networkResult = await checkInternetConnection(context);
      if (!networkResult) {
        await Future.delayed(Duration(seconds: 2));
        _isLoading = false;
        notifyListeners();
        if (context.mounted) {
          ShowTaostMessage.toastMessage(context, "No internet connection");
        }
        return;
      }

      //check id and pasword for admin and emp role
      final result = await checkUserIdAndPassword(userId, password);

      _isLoading = false;
      notifyListeners();

      if (!result['success']) {
        if (context.mounted) {
          ShowTaostMessage.toastMessage(
              context, result['error'] ?? "Login failed");
        }
        return;
      }

// Proceed with login
      final userData = result['data'];
      final userRoles = userData['role'];
      print("User logged in successfully: $userRoles");

      if (userRoles == "ADMIN") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminDashboardPage(),
          ),
        );
      } else if (userRoles == "EMP") {
        _isLoading = true;
        notifyListeners();
        List deviceInfo = await getDeviceInfo();
        if (deviceInfo.isEmpty) {
          _isLoading = false;
          notifyListeners();
          ShowTaostMessage.toastMessage(context, "Failed to get device info");
          return;
        }
        Position? position = await _deteminPosition(context);
        if (position == null) {
          _isLoading = false;
          notifyListeners();
          ShowTaostMessage.toastMessage(context, "Failed to get location");
          return;
        }
        String address = await _getAddressFromLatLng(
          position.latitude,
          position.longitude,
        );
        XFile? imagePath = await pickImage(ImageSource.camera);
        if (imagePath == null) {
          _isLoading = false;
          notifyListeners();
          ShowTaostMessage.toastMessage(context, "Image capture failed");
          return;
        }
        int imgId = await uploadLoginImage(imagePath.path, "loginImage");
        //  int imgId = 1;

        LoginRequestModel loginRequestModel = LoginRequestModel(
          empLoginId: userId,
          empPassword: password,
          device: deviceInfo[0],
          deviceId: deviceInfo[1],
          deviceBrand: deviceInfo[2],
          model: deviceInfo[3],
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
          address: address,
          // loginImage: LoginImage(imageId: imgId),
          //loginImage: imagePath.path
        );

        Map<String, dynamic> apiResponse = await loginWithIdAndPassword(
          loginRequestModel.toJson(),
          context,
        );
        if (apiResponse.isEmpty) {
          _isLoading = false;
          notifyListeners();
          ShowTaostMessage.toastMessage(context, "login failed");
          return;
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('empId', apiResponse['EmpID'] ?? '');
        await prefs.setString('empName', apiResponse['empName'] ?? '');
        await prefs.setString('empRole', apiResponse['empRole'] ?? '');
        await prefs.setString('sessionId', apiResponse['sessionId'] ?? '');
        await prefs.setInt('uuid', apiResponse['uuid']);

        String sessionId = prefs.getString("sessionId") ?? "";
        await updateImageWithApi(imgId.toString(), sessionId);

        ShowTaostMessage.toastMessage(context, "Login Successfully");
        // BackgroundLocationService.start();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListOfUiScreen()),
        );
      } else {
        ShowTaostMessage.toastMessage(context, "Invalid user role");
      }
      _isLoading = false;
      notifyListeners();
    } on PlatformException catch (e) {
      _isLoading = false;
      notifyListeners();
      if (context.mounted) {
        ShowTaostMessage.toastMessage(context, "Login failed: $e");
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      if (context.mounted) {
        ShowTaostMessage.toastMessage(context, "Login failed: $e");
      }
    }
  }

  //check internet connection..............date 21-6-2025.......................
  Future<bool> checkInternetConnection(BuildContext context) async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();

    if (result[0] == ConnectivityResult.none) {
      ShowTaostMessage.toastMessage(context, "No internet connection");
      return false;
    } else {
      return true;
    }
  }

  // Device information added 21-6-2-25
  Future<List> getDeviceInfo() async {
    try {
      // Simulate fetching device information
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      await Future.delayed(Duration(seconds: 1));
      List item = [];
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String device = androidInfo.device;
      item.add(device);
      String deviceId = androidInfo.id;
      item.add(deviceId);
      String deviceBrand = androidInfo.brand;
      item.add(deviceBrand);
      String model = androidInfo.model;
      item.add(model);

      return item;
    } catch (e) {
      print("Error fetching device info: $e");
      return [];
    }
  }

  Future<Position?> _deteminPosition(BuildContext context) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationDialog(context, true);
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationDialog(context, false);
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationDialog(context, false);
        return null;
      }

      // Safe to get location now
      return await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy:
            LocationAccuracy.high, // Or LocationAccuracy.best, etc.
      );
    } on PlatformException catch (e) {
      print("❌ PlatformException in _deteminPosition: ${e.message}");
      return null;
    } catch (e) {
      print("❌ Unexpected error in _deteminPosition: $e");
      return null;
    }
  }

  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng)
          .timeout(const Duration(seconds: 6));

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.country}";
      } else {
        return "Address not found";
      }
    } on TimeoutException {
      print("⏱️ Reverse geocoding timed out.");
      return "Timeout getting address";
    } on PlatformException catch (e) {
      print("📱 Platform error: ${e.message}");
      return "Platform error while fetching address";
    } catch (e) {
      print("❌ Error fetching address: $e");
      return "Failed to get address";
    }
  }

  void _showLocationDialog(BuildContext context, bool isServiceDialog) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            isServiceDialog
                ? 'Location Services Required'
                : 'Location Permission Required',
          ),
          content: Text(
            isServiceDialog
                ? 'Please enable location services to continue.'
                : 'Please grant location permission to use this app.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (isServiceDialog) {
                  await Geolocator.openLocationSettings();
                } else {
                  await Geolocator.openAppSettings();
                }
                if (context.mounted) Navigator.pop(dialogContext);
              },
              child: const Text('Open Settings'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  final ImagePicker _picker = ImagePicker();
  bool _isPermissionRequestInProgress = false;
  Future<XFile?> pickImage(ImageSource source) async {
    if (_isPermissionRequestInProgress) return null;
    _isPermissionRequestInProgress = true;

    try {
      PermissionStatus cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        cameraStatus = await Permission.camera.request();
      }
      if (!cameraStatus.isGranted) {
        print("❌ Camera permission denied.");
        return null;
      }

      final XFile? image = await _picker.pickImage(source: source);
      return image;
    } finally {
      _isPermissionRequestInProgress = false;
    }
  }

//   Future<XFile?> pickImage(ImageSource source) async {
//   if (_isPermissionRequestInProgress) {
//     print("🔒 Permission request already in progress. Skipping.");
//     return null;
//   }

//   _isPermissionRequestInProgress = true;

//   try {
//     if (Platform.isAndroid) {
//       final androidInfo = await DeviceInfoPlugin().androidInfo;
//       int sdkInt = androidInfo.version.sdkInt;

//       List<Permission> permissions =
//           sdkInt >= 33 ? [Permission.camera] : [Permission.camera, Permission.storage];

//       Map<Permission, PermissionStatus> statuses = await permissions.request();

//       if (statuses.values.any((status) => !status.isGranted)) {
//         print("❌ Permissions denied.");
//         return null;
//       }
//     } else if (Platform.isIOS) {
//       var status = await Permission.photos.request();
//       if (!status.isGranted) {
//         print("❌ iOS Photos permission denied.");
//         return null;
//       }
//     }

//     final XFile? image = await _picker.pickImage(source: source);
//     if (image != null) {
//       print("✅ Picked Image Path: ${image.path}");
//     } else {
//       print("❌ No image selected.");
//     }

//     return image;
//   } catch (e) {
//     print("🚨 Error picking image: $e");
//     return null;
//   } finally {
//     _isPermissionRequestInProgress = false;
//   }
// }

  // bool _isPermissionRequestInProgress = false;

  // Future<XFile?> pickImage(ImageSource source) async {
  //   if (_isPermissionRequestInProgress) {
  //     print("🔒 Permission request already in progress. Skipping.");
  //     return null;
  //   }

  //   _isPermissionRequestInProgress = true;

  //   try {
  //     if (Platform.isAndroid) {
  //       final androidInfo = await DeviceInfoPlugin().androidInfo;
  //       int sdkInt = androidInfo.version.sdkInt;

  //       List<Permission> permissions = sdkInt >= 33
  //           ? [Permission.camera,  Permission.mediaLibrary]
  //           : [Permission.camera, Permission.storage];

  //       Map<Permission, PermissionStatus> statuses =
  //           await permissions.request();

  //       if (statuses.values.any((status) => status.isPermanentlyDenied)) {
  //         openAppSettings();
  //         return null;
  //       }

  //       if (statuses.values.any((status) => !status.isGranted)) {
  //         print("Some permissions denied.");
  //         return null;
  //       }

  //     }

  //     final XFile? image = await _picker.pickImage(source: source);
  //     if (image != null) {
  //       print("✅ Picked Image Path: ${image.path}");
  //     } else {
  //       print("❌ No image selected.");
  //     }

  //     return image;
  //   } catch (e) {
  //     print("🚨 Error picking image: $e");
  //     return null;
  //   } finally {
  //     _isPermissionRequestInProgress = false;
  //   }
  // }

  Future<int> uploadLoginImage(String path, String entityType) async {
    final url = Uri.parse(Apiconstants.upload);

    if (!await File(path).exists()) {
      throw Exception('Image file not found at: $path');
    }

    final mimeType = lookupMimeType(path) ?? 'image/jpeg';
    final mediaType = MediaType.parse(mimeType);

    var request = http.MultipartRequest('POST', url)
      ..fields['entityType'] = entityType
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          path,
          contentType: mediaType,
        ),
      );

    print("Sending request to $url");
    print("File path: $path");
    print("Entity Type: $entityType");
    print("Mime Type: $mimeType");

    try {
      var response = await request.send();
      var respStr = await response.stream.bytesToString();

      print("Response: $respStr");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(respStr);
        return jsonResponse['imageId'];
      } else {
        throw Exception(
            "Image upload failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception during image upload: $e");
      rethrow;
    }
  }

//LOGIN API WITH USER AND PASSWORD.............
  Future<Map<String, dynamic>> loginWithIdAndPassword(
      Map<String, dynamic> json, BuildContext context) async {
    final url = Uri.parse(Apiconstants.login);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + base64Encode(utf8.encode('admin:admin123')),
    };

    final body = jsonEncode(json);

    try {
      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(Duration(seconds: 30)); // Add timeout for network request

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse successful response
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        // Log error for unsuccessful response
        print('HTTP Error: ${response.statusCode} - ${response.body}');
        final res = jsonDecode(response.body);

        // Show the error message using a toast
        ShowTaostMessage.toastMessage(
            context, res["error"] ?? "Unknown error occurred");
        return {};
      }
    } on SocketException catch (e) {
      print('Network error: $e');
      ShowTaostMessage.toastMessage(context, "No Internet connection");
      return {};
    } on TimeoutException catch (e) {
      print('Request timed out: $e');
      ShowTaostMessage.toastMessage(
          context, "The request timed out. Please try again.");
      return {};
    } on FormatException catch (e) {
      print('Response format error: $e');
      ShowTaostMessage.toastMessage(
          context, "Received invalid data from server");
      return {};
    } on PlatformException catch (e) {
      print('Platform error: $e');
      ShowTaostMessage.toastMessage(context, "Platform error: $e");
      return {};
    } catch (e) {
      ShowTaostMessage.toastMessage(
          context, "An unexpected error occurred. Please try again.");
      return {};
    }
  }

  Future updateImageWithApi(String imageId, String updateWithSession) async {
    final url = Uri.parse(Apiconstants.updateImageId);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + base64Encode(utf8.encode('admin:admin123')),
    };

    final body = jsonEncode({"imageId": imageId, "linkId": updateWithSession});

    try {
      final updateBody = await http.put(url, headers: headers, body: body);

      if (updateBody.statusCode == 200 || updateBody.statusCode == 201) {
        final imageReponse = jsonDecode(updateBody.body);
        // final linkId = imageReponse;
        return imageReponse;
      } else {
        print(' HTTP Error: ${updateBody.statusCode} - ${updateBody.body}');

        return "";
      }
    } catch (e) {
      print('Error: $e');
      return " ";
    }
  }

  Future<bool> checkCameraPermissions() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return false;
  }

  //USER LOGOUT............................................

  bool _isLoggingOut = false;

  bool get isLoggingOut => _isLoggingOut;

  Future<void> userlLogout(
      int? uuid, String? sessionId, BuildContext context) async {
    try {
      _isLoggingOut = true;
      notifyListeners();

      await Future.delayed(Duration(seconds: 3));
      bool networkResult = await checkInternetConnectionForLogout(context);
      if (!networkResult) {
        _isLoggingOut = false;
        notifyListeners();

        return;
      }
      Position? position = await _deteminPosition(context);
      if (position == null) {
        _isLoggingOut = false;
        notifyListeners();
        if (context.mounted) {
          ShowTaostMessage.toastMessage(context, "Failed to get location");
        }
        return;
      }

      String address = await _getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      List deviceInfo = await getDeviceInfo();
      if (deviceInfo.isEmpty) {
        _isLoggingOut = false;
        notifyListeners();
        if (context.mounted) {
          ShowTaostMessage.toastMessage(context, "Failed to get device info");
        }
        return;
      }
      XFile? path = await pickImage(ImageSource.camera);
      if (path == null) {
        _isLoggingOut = false;
        notifyListeners();

        return;
      }
      int logoutImageId = await uploadLoginImage(path.path, "logoutImage");

      // print("Logout Image ID: $logoutImageId");
      // int logoutImageId=1;

      LogoutModel model = LogoutModel(
        // userId: uuid?? 0,
        logoutAddress: address,

        userId: uuid ?? 0,
        logoutLatitude: position.latitude.toString(),
        logoutLongitude: position.longitude.toString(),
        logoutDeviceBrand: deviceInfo[2],
        logoutDeviceId: deviceInfo[1],
        logoutDeviceModel: deviceInfo[3],
        logoutModel: deviceInfo[0],
        logoutimage: LogoutImage(imageId: logoutImageId),
      );
      //print(model.toJson());

      bool logoutResult = await logOutWithApi(model.toJson());
      await updateImageWithApi(logoutImageId.toString(), sessionId ?? "");

      if (logoutResult == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        prefs.remove("userProfile");
        Future.delayed(Duration(seconds: 3));
        ShowTaostMessage.toastMessage(context, "LogOut successfully");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SelectScreenForService(),
          ),
        );
        _isLoggingOut = false;

        notifyListeners();
      }

      _isLoggingOut = false;
      notifyListeners();
    } on PlatformException catch (e) {
      _isLoggingOut = false;
      notifyListeners();
      if (context.mounted) {
        ShowTaostMessage.toastMessage(context, "Login failed: $e");
      }
    } catch (e) {
      _isLoggingOut = false;
      notifyListeners();
      if (context.mounted) {
        ShowTaostMessage.toastMessage(context, "Login failed: $e");
      }
    }
  }

  Future<bool> checkInternetConnectionForLogout(BuildContext context) async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();

    if (result[0] == ConnectivityResult.none) {
      ShowTaostMessage.toastMessage(context, "No internet connection");
      return false;
    } else {
      return true;
    }
  }

  Future<bool> logOutWithApi(Map<String, dynamic> json) async {
    final url = Uri.parse(Apiconstants.logout);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + base64Encode(utf8.encode('admin:admin123')),
    };

    final body = jsonEncode(json);

    try {
      final response = await http
          .post(
            url,
            headers: headers,
            body: body,
          )
          .timeout(Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Logout successful');
        return true;
      } else {
        print('HTTP Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } on SocketException catch (e) {
      print('Network error: No Internet connection. Error: $e');
      return false;
    } on TimeoutException catch (e) {
      // Handle request timeout
      print('Request timed out: $e');
      return false;
    } on FormatException catch (e) {
      // Handle JSON parsing errors
      print('Response format error: $e');
      return false;
    } on PlatformException catch (e) {
      // Handle platform-specific exceptions (e.g., Android/iOS related errors)
      print('Platform error: $e');
      return false;
    } catch (e) {
      // Handle any other errors (generic fallback)
      print('Unexpected error: $e');
      return false;
    }
  }
  //check user id and password with session id

  Future<Map<String, dynamic>> checkUserIdAndPassword(
      String userId, String password) async {
    final url = Uri.parse(Apiconstants.checkUserIdPass);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + base64Encode(utf8.encode('admin:admin123')),
    };
    final body = jsonEncode({
      "empLoginId": userId,
      "empPassword": password,
    });

    try {
      final outResponse = await http
          .post(url, headers: headers, body: body)
          .timeout(Duration(seconds: 30));

      if (outResponse.statusCode == 200 || outResponse.statusCode == 201) {
        final responseData = jsonDecode(outResponse.body);
        return {"success": true, "data": responseData};
      } else {
        return {
          "success": false,
          "error":
              "Invalid credentials or server error: ${outResponse.statusCode}"
        };
      }
    } on SocketException {
      return {"success": false, "error": "No internet connection."};
    } on TimeoutException {
      return {"success": false, "error": "Server timeout. Please try again."};
    } on FormatException {
      return {
        "success": false,
        "error": "Invalid response format from server."
      };
    } on PlatformException catch (e) {
      return {"success": false, "error": "Platform error: ${e.message}"};
    } catch (e) {
      return {"success": false, "error": "Unexpected error: $e"};
    }
  }
  //USING PROVIDER FATCH LOGIN DETAILS...............................................

  bool _isSessionLog = false;
  ApiError? error;
  UserLoginInfoModel? userLoginInfoModel;

  bool get isSessionLog => _isSessionLog;

  Future<void> fetchSessionInfo() async {
    _isSessionLog = true;
    error = null;
    notifyListeners();

    final result = await _userServicesForApi.getSessionInfo();

    if (result.isSuccess) {
      userLoginInfoModel = result.data;
    } else {
      error = result.error;
    }

    _isSessionLog = false;
    notifyListeners();
  }

  //fatch login session only onecs when apppp login
  //Map<String, dynamic>? _userData;

  // //here we will use fatch background location  every dynamic timer interval..
  // Timer? _periodicTimer;
  // Future<void> getBackgroundLocationFetch(int duration) async {
  //   _periodicTimer = Timer.periodic(Duration(seconds: 5), (timer) {
  //     print("Background location fetch triggered in provider");
  //   });
  //   //notifyListeners();
  // }
  // //Automatic logout when user session has been expire............................

  Future<void> AutomaticLogout(BuildContext context, bool image) async {
    _isLoggingOut = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));
    bool networkResult = await checkInternetConnectionForLogout(context);
    if (!networkResult) {
      _isLoggingOut = false;
      notifyListeners();

      return;
    }
    Position? position = await _deteminPosition(context);
    if (position == null) {
      _isLoggingOut = false;
      notifyListeners();
      if (context.mounted) {
        ShowTaostMessage.toastMessage(context, "Failed to get location");
      }
      return;
    }

    String address = await _getAddressFromLatLng(
      position.latitude,
      position.longitude,
    );

    List deviceInfo = await getDeviceInfo();
    if (deviceInfo.isEmpty) {
      _isLoggingOut = false;
      notifyListeners();
      if (context.mounted) {
        ShowTaostMessage.toastMessage(context, "Failed to get device info");
      }
      return;
    }
    String? imagePath;
    if (image) {
      XFile? path = await pickImage(ImageSource.camera);
      imagePath = path!.path;
    }

    LogoutModel model = LogoutModel(
      // userId: uuid?? 0,
      logoutAddress: address,
      logoutLatitude: position.latitude.toString(),
      logoutLongitude: position.longitude.toString(),
      logoutDeviceBrand: deviceInfo[2],
      logoutDeviceId: deviceInfo[1],
      logoutDeviceModel: deviceInfo[3],
      logoutModel: deviceInfo[0],
    );
    automaticLogoutService(model.toJson(), imagePath, image);
  }

  ///autmatic logout

  Future<Resultt> automaticLogoutService(
      Map<String, dynamic> toJson, String? filePath, bool image) async {
    try {
      final url = Uri.parse(Apiconstants.login);
      final request = http.MultipartRequest("POST", url);

      request.files.add(
        http.MultipartFile.fromString(
          'dto',
          jsonEncode(toJson),
          contentType: MediaType('application', 'json'),
        ),
      );

      if (image) {
        request.files.add(await http.MultipartFile.fromPath('file', filePath!));
      }

      final responseStream = await request.send();
      final responseBody = await responseStream.stream.bytesToString();

      if (responseStream.statusCode == 200) {
        return Resultt.success(jsonDecode(responseBody));
      }

      // Any API error
      try {
        final errorJson = jsonDecode(responseBody);
        return Resultt.apiError(errorJson);
      } catch (_) {
        return Resultt.systemError(ApiError.server);
      }
    } on SocketException {
      return Resultt.systemError(ApiError.network);
    } on TimeoutException {
      return Resultt.systemError(ApiError.timeout);
    } on http.ClientException {
      return Resultt.systemError(ApiError.client);
    } catch (_) {
      return Resultt.systemError(ApiError.server);
    }
  }

  //user login session with image..............................................
  UserLoginInfoModel? _userLoginInfoModel2;
  bool _isLoadingSession = false;
  bool _dataLoaded = false; // The flag to track if data is fetched

  //Map<String, dynamic>? get userData => _userData;
  UserLoginInfoModel? get userLoginInfoModel2 => _userLoginInfoModel2;
  bool get isLoadingSession => _isLoadingSession;
  bool get dataLoaded => _dataLoaded;
  Future<void> loadUserSession() async {
    if (_dataLoaded) {
      return;
      //data alread load
    }
    _isLoadingSession = true;
    notifyListeners();
    try {
      final result = await _userServicesForApi.loadSessionOnecs();
      if (result.isSuccess) {
        _userLoginInfoModel2 = result.data;
        _dataLoaded = true;
        _isLoadingSession = false;
      }
    } catch (error) {
      _isLoadingSession = false;
    }
    notifyListeners();
  }
}
