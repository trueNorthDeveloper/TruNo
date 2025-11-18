import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:truenorthflutterfrontend/public/config/api_const.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/api_result.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userLogRegModel/user_login_info_model.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';

class UserServicesForApi {
  Future<Result<UserLoginInfoModel>> getSessionInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Try local cache
      if (prefs.containsKey("loginInfo")) {
        final cachedData = prefs.getString("loginInfo");
        if (cachedData != null) {
          try {
            final jsonMap = jsonDecode(cachedData) as Map<String, dynamic>;
            final userInfo = UserLoginInfoModel.fromJson(jsonMap);
            return Result.success(userInfo);
          } catch (_) {
            return Result.failure(ApiError.jsonFormat);
          }
        }
      }

      // Call API if not cached
      final sessionId = prefs.getString("sessionId");
      if (sessionId == null) {
        return Result.failure(ApiError.unauthorized);
      }

      final url = Uri.parse('${Apiconstants.userLoginInfo}$sessionId');
      final response = await http.get(url).timeout(Duration(seconds: 20));

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
          final userInfo = UserLoginInfoModel.fromJson(jsonMap);
          prefs.setString("loginInfo", jsonEncode(jsonMap));
          return Result.success(userInfo);
        } catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException {
      return Result.failure(ApiError.network);
    } on TimeoutException {
      return Result.failure(ApiError.timeout);
    } on http.ClientException {
      return Result.failure(ApiError.client);
    } on PlatformException {
      return Result.failure(ApiError.platform);
    } catch (_) {
      return Result.failure(ApiError.unknown);
    }
  }
}
