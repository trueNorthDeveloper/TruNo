import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/view/admin_dashboard_page.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/model/admin_login_response_model.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/model/admin_all_users_detail_model.dart';
import 'package:truenorthflutterfrontend/public/config/api_const.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';

class AdminDashboardProvider extends ChangeNotifier {
  int _selectScreen = 0;

  int get selectScreen => _selectScreen;

  void onMenuItemSelected(int selectedIndex) {
    _selectScreen = selectedIndex;
    notifyListeners();
  }

  bool _isShow = false;
  bool get isShow => _isShow;
  void drawerHideAndShow() {
    _isShow = !_isShow;
    print(_isShow);
    notifyListeners();
  }

//date 29-6-25 admin login with id and password

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  Future<void> adminLoginWithIdAndPassword(
      String loginId, String password, BuildContext context) async {
    _isLogin = true;
    notifyListeners();

    final url = Uri.parse(Apiconstants.adminlog); // Make sure this is correct
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic ' + base64Encode(utf8.encode('admin:admin123')),
    };
    final body = jsonEncode({
      "empLoginId": loginId,
      "empPassword": password,
    });

    try {
      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(Duration(seconds: 30));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(jsonResponse);
        ShowTaostMessage.toastMessage(context, loginResponse.message);

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('empId', loginResponse.data.empId);
        prefs.setString('empName', loginResponse.data.empName);
        prefs.setString('role', loginResponse.data.role);
        prefs.setInt('uuid', loginResponse.data.uuid);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboardPage()),
        );
      } else {
        ShowTaostMessage.toastMessage(
            context, "Login failed: ${response.statusCode}");
      }
    } on PlatformException catch (e) {
      debugPrint("PlatformException: $e");
    } on SocketException catch (e) {
      debugPrint("SocketException: $e");
      ShowTaostMessage.toastMessage(context, "No Internet connection");
    } on TimeoutException catch (e) {
      debugPrint("TimeoutException: $e");
      ShowTaostMessage.toastMessage(context, "Request timed out");
    } on FormatException catch (e) {
      debugPrint("FormatException: $e");
    } catch (e) {
      debugPrint("General error: $e");
      ShowTaostMessage.toastMessage(context, "Unexpected error occurred");
    } finally {
      _isLogin = false;
      notifyListeners();
    }
  }

  ///here all user facth......................
  //  Future<void> allUsers(BuildContext context) async {
  //   final url = Uri.parse(Apiconstants.fatchAllUser);

  //   try {
  //     final allUserResponse =await http.get(url).timeout(Duration(seconds: 30));
  //     if (allUserResponse.statusCode == 200 ||
  //         allUserResponse.statusCode == 201) {
  //       print('Status code: ${allUserResponse.statusCode}');
  //       print('Response body: ${allUserResponse.body}');
  //       print('Content-Type: ${allUserResponse.headers['content-type']}');
  //      // List<dynamic> data = jsonDecode(allUserResponse.body);
  //       //return data.map((user) => User.fromJson(user)).toList();
  //       // List<User> item=data.map((user)=>User.fromJson(user)).toList();
  //     } else {
  //       ShowTaostMessage.toastMessage(
  //           context, "Login failed: ${allUserResponse.statusCode}");
  //     }
  //   } on PlatformException catch (e) {
  //     debugPrint("PlatformException: $e");
  //   } on SocketException catch (e) {
  //     debugPrint("SocketException: $e");
  //     ShowTaostMessage.toastMessage(context, "No Internet connection");
  //   } on TimeoutException catch (e) {
  //     debugPrint("TimeoutException: $e");
  //     ShowTaostMessage.toastMessage(context, "Request timed out");
  //   } on FormatException catch (e) {
  //     debugPrint("FormatException: $e");
  //   } catch (e) {
  //     debugPrint("General error: $e");
  //     // return throw Exception('Failed to load shoes');
  //     ShowTaostMessage.toastMessage(context, "Unexpected error occurred");
  //   }
  //   // return [];
  // }
  Future<void> allUsers(BuildContext context) async {
  final url = Uri.parse(Apiconstants.fatchAllUser);
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Basic ' + base64Encode(utf8.encode('admin:admin123')),
  };

  try {
    final allUserResponse = await http
        .get(url, headers: headers)
        .timeout(const Duration(seconds: 30));

    final statusCode = allUserResponse.statusCode;
    final contentType = allUserResponse.headers['content-type'] ?? '';

    if (statusCode == 200 || statusCode == 201) {
      if (contentType.contains('application/json')) {
        final List<dynamic> data = jsonDecode(allUserResponse.body);
        // Parse users (if you have User.fromJson):
        final users = data.map((user) => User.fromJson(user)).toList();
        // Do something with users
        debugPrint('Fetched ${users.length} users.');
      } else {
        debugPrint("Unexpected content-type: $contentType");
        ShowTaostMessage.toastMessage(
            context, "Unexpected response format (not JSON).");
      }
    } else {
      debugPrint("API Error: $statusCode");
      ShowTaostMessage.toastMessage(
        context,
        "API error: $statusCode",
      );
    }
  } on SocketException {
    ShowTaostMessage.toastMessage(context, "No Internet connection");
  } on TimeoutException {
    ShowTaostMessage.toastMessage(context, "Request timed out");
  } on FormatException {
    ShowTaostMessage.toastMessage(context, "Invalid response format");
  } catch (e) {
    debugPrint("Unexpected error: $e");
    ShowTaostMessage.toastMessage(context, "Something went wrong");
  }
}


}
