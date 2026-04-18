
class UserDailyAttendance {
  final bool? success;
  final String? message;
  final List<AttendanceData>? data;

  UserDailyAttendance({this.message, this.success, this.data});

  factory UserDailyAttendance.fromJson(Map<String, dynamic> json) {
    return UserDailyAttendance(
      message: json["message"] ?? "",
      success: json["success"] ?? false,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) =>
                  AttendanceData.fromJson(item)) // FIX: Use 'item', not 'json'
              .toList()
          : [],
    );
  }
}

class AttendanceData {
  final String? date;
  final String? status;
  final int? totalSession;
  final List<Sessions>? session;
  final dynamic leave; // Changed to dynamic because it can be null or a Map
  final dynamic holiday;

  AttendanceData({
    this.date,
    this.status,
    this.totalSession,
    this.session,
    this.leave,
    this.holiday,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      date: json['date'] ?? "",
      status: json['status'] ?? "Absent",
      totalSession: json['totalSession'] ?? 0,
      session: json['session'] != null
          ? (json['session'] as List)
              .map((item) =>
                  Sessions.fromJson(item)) // FIX: Use 'item', not 'json'
              .toList()
          : [],
      leave: json['leave'],
      holiday: json['holiday'],
    );
  }
}

class Sessions {
  final String? loginDate; // Fixed key name based on your JSON
  final String? loginTime;
  final String? logOutTime;
  final String? workingHour;

  Sessions({
    this.loginDate,
    this.loginTime,
    this.logOutTime,
    this.workingHour,
  });

  factory Sessions.fromJson(Map<String, dynamic> json) {
    return Sessions(
      loginDate: json['loginDate'], // FIX: Key was 'loginDate' in your JSON
      loginTime: json['loginTime'],
      logOutTime: json['logOutTime'],
      workingHour: json['workingHour'],
    );
  }
}
