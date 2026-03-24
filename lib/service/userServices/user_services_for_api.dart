import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userLogRegModel/user_me_model.dart';

import 'package:truenorthflutterfrontend/public/config/api_const.dart';
import 'package:truenorthflutterfrontend/public/utils/resultt.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/api_result.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userLogRegModel/user_login_info_model.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';

class UserServicesForApi {
  final auth = TokenService();
  //user login service.....................................................with jwt......
  Future<Resultt> loginWithJwt(
    Map<String, dynamic> toJson,
    String filePath,
  ) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(Apiconstants.login),
      );

      request.files.add(
        http.MultipartFile.fromString(
          'dto',
          jsonEncode(toJson),
          contentType: http.MediaType('application', 'json'),
        ),
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', filePath),
      );

      final response = await request.send().timeout(
            const Duration(seconds: 30),
          );

      // final body = await response.stream.bytesToString();
      final responseBody = await http.Response.fromStream(response);

      if (responseBody.statusCode == 200) {
        return Resultt.success(jsonDecode(responseBody.body));
      } else {
        try {
          return Resultt.apiError(jsonDecode(responseBody.body));
        } catch (e) {
          return Resultt.systemError(ApiError.server);
        }
      }
    } on SocketException {
      return Resultt.systemError(ApiError.network);
    } on TimeoutException {
      return Resultt.systemError(ApiError.timeout);
    } catch (_) {
      return Resultt.systemError(ApiError.server);
    }
  }

//logut all ways
  Future<Resultt> automaticLogoutService(
      Map<String, dynamic> toJson, String filePath, bool image) async {
    try {
      final url = Uri.parse(Apiconstants.userlogout);
      final request = http.MultipartRequest("POST", url);

      request.files.add(
        http.MultipartFile.fromString(
          'dto',
          jsonEncode(toJson),
          contentType: http.MediaType('application', 'json'),
        ),
      );

      if (image) {
        request.files.add(await http.MultipartFile.fromPath('file', filePath));
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

  Future<Result<UsermeModel>> loginAfterMeService() async {
    try {
      String? endPoint = "v2me";
      final respones = await auth.authorizedGet(endPoint);
      if (respones.statusCode == 200) {
        try {
          final data = jsonDecode(respones.body);
          final userProject = UsermeModel.fromJson(data);
          return Result.success(userProject);
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException catch (_) {
      return Result.failure(ApiError.network);
    } on TimeoutException catch (_) {
      return Result.failure(ApiError.timeout);
    } on http.ClientException catch (_) {
      return Result.failure(ApiError.client);
    } on PlatformException catch (_) {
      return Result.failure(ApiError.platform);
    } catch (_) {
      return Result.failure(ApiError.unknown);
    }
  }

  Future<Result<UserLoginInfoModel>> getSessionInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? endPoint = "v2loginsessionInfo";
      final respone = await auth.authorizedGet(endPoint);

      if (respone.statusCode == 200) {
        final jsonMap = jsonDecode(respone.body) as Map<String, dynamic>;
        final userInfo = UserLoginInfoModel.fromJson(jsonMap);
        prefs.setString("loginInfo", jsonEncode(jsonMap));
        return Result.success(userInfo);
      } else {
        return Result.failure(ApiError.jsonFormat);
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
Future<Result<UserLoginInfoModel>> loadSessionOnecs() async {
    try {
     // SharedPreferences prefs = await SharedPreferences.getInstance();
      String? endPoint = "v2loginsessionInfo";
      final respone = await auth.authorizedGet(endPoint);

      if (respone.statusCode == 200) {
        final jsonMap = jsonDecode(respone.body) as Map<String, dynamic>;
        final userInfo = UserLoginInfoModel.fromJson(jsonMap);
        //prefs.setString("loginInfo", jsonEncode(jsonMap));
        return Result.success(userInfo);
      } else {
        return Result.failure(ApiError.jsonFormat);
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
 

  Future<Result<UserLoginInfoModel>> getSessionInfo2() async {
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
