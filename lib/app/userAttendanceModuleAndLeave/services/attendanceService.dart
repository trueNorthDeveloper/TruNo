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
      //https://3808-106-222-212-68.ngrok-free.app/api/attendance/attendance_logs?year=2026&month=3
      String? endPoint = "attendance_logs?year=${year}${"&"}month=${month}";
      final respones = await auth.authorizedGet(endPoint);
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
