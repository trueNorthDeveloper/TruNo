class LeaveRequestResponse {
  final bool? success;
  final String? message;
  final List<LeaveData>? data;

  LeaveRequestResponse({
    this.success,
    this.message,
    this.data,
  });

  factory LeaveRequestResponse.fromJson(Map<String, dynamic> json) {
    return LeaveRequestResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => LeaveData.fromJson(i)).toList()
          : null,
    );
  }
}

class LeaveData {
  final int? requestId;
  final String? userName;
  final String? userEid;
  final String? toDate;
  final String? fromDate;
  final String? leaveReason;
  final String? leaveType;
  final int? numberOfDays;
  final String? leaveStatus;

  LeaveData({
    this.requestId,
    this.userName,
    this.userEid,
    this.toDate,
    this.fromDate,
    this.leaveReason,
    this.leaveType,
    this.numberOfDays,
    this.leaveStatus,
  });

  factory LeaveData.fromJson(Map<String, dynamic> json) {
    return LeaveData(
      requestId: json['requestId'],
      userName: json['userName'],
      userEid: json['userEid'],
      toDate: json['toDate'],
      fromDate: json['fromDate'],
      leaveReason: json['leaveReason'],
      leaveType: json['leaveType'],
      numberOfDays: json['numberOfDays'],
      leaveStatus: json['leaveStatus'],
    );
  }
}
