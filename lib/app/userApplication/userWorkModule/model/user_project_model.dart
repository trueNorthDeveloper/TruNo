class userProjectResponse {
  final bool success;
  final String message;
  final List<Project>? data;

  userProjectResponse(
      {required this.success, required this.message, this.data});

  factory userProjectResponse.fromJson(Map<String, dynamic> json) {
    return userProjectResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => Project.fromJson(item))
              .toList()
          : [],
    );
  }
}

class Project {
  final int tnecProjectUid;
  final String tnecProjectName;
  final String createdDate;
  final String tnecProjectDescription;
  final String tnecProjectStatus;
  final String tnecProjectId;
  final String tnecProjectStartDate;
  final String tnecProjectEndDate;
  final String tnecProjectWorkDuration;

  Project({
    required this.tnecProjectUid,
    required this.tnecProjectName,
    required this.createdDate,
    required this.tnecProjectDescription,
    required this.tnecProjectStatus,
    required this.tnecProjectId,
    required this.tnecProjectStartDate,
    required this.tnecProjectEndDate,
    required this.tnecProjectWorkDuration,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      tnecProjectUid: json['tnecProjectUid'],
      tnecProjectName: json['tnecProjectName'],
      createdDate: json['createdDate'],
      tnecProjectDescription: json['tnecProjectDescription'],
      tnecProjectStatus: json['tnecProjectStatus'],
      tnecProjectEndDate: json['tnecProjectEndDate'],
      tnecProjectWorkDuration: json['tnecProjectWorkDuration'],
      tnecProjectId: json['tnecProjectId'],
      tnecProjectStartDate: json['tnecProjectStartDate'],
    );
  }
}
