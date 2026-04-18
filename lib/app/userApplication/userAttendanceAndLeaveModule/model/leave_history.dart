class LeaveHistoryResponse {
  final List<LeaveRequest> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool first;
  final bool last;

  LeaveHistoryResponse({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.first,
    required this.last,
  });

  factory LeaveHistoryResponse.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryResponse(
      content: (json['content'] as List)
              .map((i) => LeaveRequest.fromJson(i))
              .toList(),
          
      page: json['page'],
      size: json['size'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      first: json['first'],
      last: json['last'],
    );
  }
}

class LeaveRequest {
  final String? leaveType;
  final String? toDate;
  final String? fromDate;
  final int? numberOfDays;
  final String? applyDate;
  final String? finalStatus;
  final List<LeaderStatus>? leaderStatus;

  LeaveRequest({
    this.leaveType,
    this.toDate,
    this.fromDate,
    this.numberOfDays,
    this.applyDate,
    this.finalStatus,
    this.leaderStatus,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      leaveType: json['leaveType'],
      toDate: json['toDate'],
      fromDate: json['fromDate'],
      numberOfDays: json['numberOfdays'], // Note: API uses 'numberOfdays'
      applyDate: json['applyDate'],
      finalStatus: json['finalStatus'],
      leaderStatus: json['leaderStatus'] != null
          ? (json['leaderStatus'] as List)
              .map((i) => LeaderStatus.fromJson(i))
              .toList()
          : null,
    );
  }
}

class LeaderStatus {
  final String? eid;
  final String? name;
  final String? approverStatus;
  final String? comment;
  final String? approvedUpdated;

  LeaderStatus({
    this.eid,
    this.name,
    this.approverStatus,
    this.comment,
    this.approvedUpdated,
  });

  factory LeaderStatus.fromJson(Map<String, dynamic> json) {
    return LeaderStatus(
      eid: json['eid'],
      name: json['name'],
      approverStatus: json['approverStatus'],
      comment: json['comment'],
      approvedUpdated: json['approvedUpdated'],
    );
  }
}
