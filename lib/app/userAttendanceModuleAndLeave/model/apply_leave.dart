class ApplyLeaveRequest {
  final String? leaveType;
  final String? fromDate;
  final String? toDate;
  final String? reason;

  ApplyLeaveRequest(
      {required this.leaveType,
      required this.fromDate,
      required this.toDate,
      required this.reason});
  Map<String, dynamic> tojson() {
    return {
      "leaveType": leaveType ?? null,
      "fromDate": fromDate ?? null,
      "toDate": toDate ?? null,
      "reason": reason ?? null
    };
  }
}

class ApplyLeaveResponse {
  final bool? success;
  final String? message;
  final Map<String, dynamic>? data;

  ApplyLeaveResponse(
      {required this.success, required this.message, required this.data});

  factory ApplyLeaveResponse.fromJson(Map<String, dynamic> json) {
    return ApplyLeaveResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] != null
            ? Map<String, dynamic>.from(json['data'])
            : null);
  }
}
