import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:truenorthflutterfrontend/app/model/teamLeaderModels/leaveRequestResponse.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/apply_leave.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/can_apply_leave.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/leave_history.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/user_daily_attendance.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/user_leave_logs.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/api_result.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';

class Attendanceservice {
  final auth = TokenService();
//USER DAILY ATTENDANCE FATCH SERVICE METHOD
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

  Future<Result<UserLeaveLogs>> fatchUserLeaveLogs() async {
    try {
      //  String? endPoint = "attendance/attendance_logs?year=${year}${"&"}month=${month}";
      String endPoint = "attendance/leaveLog";
      final respones = await auth.authorizedGetForWork(endPoint);
      if (respones.statusCode == 200) {
        try {
          final data = jsonDecode(respones.body);
          final response = UserLeaveLogs.fromJson(data);
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

//user can apply leave or not....................
  Future<Result<CanApplyLeave>> canApplyLeaveFatch() async {
    try {
      String endPoint = "attendance/can-apply";
      final respones = await auth.authorizedGetForWork(endPoint);
      if (respones.statusCode == 200) {
        try {
          final data = jsonDecode(respones.body);
          final response = CanApplyLeave.fromJson(data);
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

//PostMethod for apply leave...............................
  Future<Result<ApplyLeaveResponse>> applyMonthLeaveService(
      Map<String, dynamic> tojson) async {
    const String endPoint = "attendance/leaveApply";

    try {
      final response = await auth
          .authorizedPostForWork(endPoint, tojson)
          .timeout(const Duration(seconds: 20));

      // 1. Check if the body is empty or null before decoding
      if (response.body.isEmpty) {
        return Result.failure(ApiError.server);
      }

      if (response.statusCode == 200 || response.statusCode == 422) {
        // 2. Wrap decoding in a try-catch to catch model mapping errors
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        return Result.success(ApplyLeaveResponse.fromJson(decodedData));
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
    } catch (e) {
      // 3. CRITICAL: Log the error so you know WHY it failed
      debugPrint("Unexpected Error in applyMonthLeaveService: $e");
      return Result.failure(ApiError.unknown);
    }
  }

//user LEAVE APPLY HISTORY WITH APPLY LOGS
  Future<Result<LeaveHistoryResponse>> showUserapplyLeaveHistory(
      int currentPage, int size) async {
    try {
      String endPoint = "attendance/leave_history?page=$currentPage&size=$size";
      final respones = await auth.authorizedGetForWork(endPoint);
      if (respones.statusCode == 200) {
        try {
          if (respones.body.isEmpty) {
            return Result.failure(ApiError.emptyResponse);
          }
          final data = jsonDecode(respones.body);
          final response = LeaveHistoryResponse.fromJson(data);
          return Result.success(response);
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        } on NoSuchMethodError {
          return Result.failure(ApiError.invalidData);
        }
      } else if (respones.statusCode == 401) {
        return Result.failure(ApiError.unauthorized);
      } else if (respones.statusCode == 403) {
        return Result.failure(ApiError.forbidden);
      } else if (respones.statusCode == 429) {
        return Result.failure(ApiError.tooManyRequests);
      } else if (respones.statusCode > -500) {
        return Result.failure(ApiError.server);
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

//THIS METHHOD FOR TEAM IF USER LOGIN ACCOUNT AS TEAM LEADER THIS METHOD WILL APPPEAR
  Future<Result<LeaveRequestResponse>> showLeaveRequestToTeamLeader() async {
    try {
      String endPoint = "attendance/allLeaveRequestShow";
      final respones = await auth.authorizedGetForWork(endPoint);
      if (respones.statusCode == 200) {
        try {
          if (respones.body.isEmpty) {
            return Result.failure(ApiError.emptyResponse);
          }
          final data = jsonDecode(respones.body);
          final response = LeaveRequestResponse.fromJson(data);
          return Result.success(response);
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        } on NoSuchMethodError {
          return Result.failure(ApiError.invalidData);
        }
      } else if (respones.statusCode == 401) {
        return Result.failure(ApiError.unauthorized);
      } else if (respones.statusCode == 403) {
        return Result.failure(ApiError.forbidden);
      } else if (respones.statusCode == 429) {
        return Result.failure(ApiError.tooManyRequests);
      } else if (respones.statusCode > -500) {
        return Result.failure(ApiError.server);
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
