import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/user_daily_attendance.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/api_result.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';

class Attendanceservice {
  final auth = TokenService();

  Future<Result<UserDailyAttendance>> getUserDailyAttenadance(
      year, month) async {
    try {
      //  String? endPoint = "attendance/attendance_logs?year=${year}${"&"}month=${month}";
      String endPoint = "attendance/attendance_logs?year=$year&month=$month";
      final respones = await auth.authorizedGetForWork(endPoint);
      if (respones.statusCode == 200) {
        try {
          final data = jsonDecode(respones.body);
          final response = UserDailyAttendance.fromJson(data);
          return Result.success(response);
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
}
