import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:truenorthflutterfrontend/app/adminApplication/model/admin_login_record.dart';

import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/api_result.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';

class AdminAnalyticService {
  final auth = TokenService();
  //========================================================
//*ALLLOGIN USER START.......................................
//========================================================
  Future<Result<AdminLoginData>> fatchAdminServiceAllLoginUser(int currentPage, int size) async {
    try {
      // admin/api/all-login-user?page=0&size=10
      final endPoint = "admin/api/all-login-user?page=$currentPage&size=$size";

      final response = await auth.authorizedGet(endPoint);
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = jsonDecode(response.body);
          return Result.success(AdminLoginData.fromJson(data));
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException {
      return Result.failure(
        ApiError.network,
        message: "No internet connection. Please check your network.",
      );
    } on TimeoutException {
      return Result.failure(
        ApiError.timeout,
        message: "Request timed out. Please try again.",
      );
    } on http.ClientException {
      return Result.failure(
        ApiError.client,
        message: "Failed to reach the server. Please try again.",
      );
    } on PlatformException catch (e) {
      return Result.failure(
        ApiError.platform,
        message: e.message ?? "A platform error occurred.",
      );
    } catch (e) {
      return Result.failure(
        ApiError.unknown,
        message: e.toString(),
      );
    }
  }
  //========================================================
//*ALLLOGIN USER START.......................................
//========================================================
}
