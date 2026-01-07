class CompleteTaskApiResponse {
  final bool success;
  final String message;
  final TaskDetailInfo? data;

  CompleteTaskApiResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CompleteTaskApiResponse.fromJson(Map<String, dynamic> json) {
    return CompleteTaskApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? " ",
      data: json['data'] != null ? TaskDetailInfo.fromJson(json['data']) : null,
    );
  }
}

class TaskDetailInfo {
  final TaskInfo? task;
  final Submit? submit;
  final List<FileAttachment>? files;

  TaskDetailInfo({
    required this.task,
    required this.submit,
    required this.files,
  });

  factory TaskDetailInfo.fromJson(Map<String, dynamic> json) {
    return TaskDetailInfo(
        task: json['task'] != null ? TaskInfo.fromJson(json['task']) : null,
        submit: json["submit"] != null ? Submit.fromJson(json['submit']) : null,
        files: json['files'] != null
            ? (json['files'] as List)
                .map((f) => FileAttachment.fromJson(f))
                .toList()
            : []);
  }
}

class TaskInfo {
  final int? taskId;
  final String? taskName;
  final String? taskDescription;
  final String? taskPriorityStatus;
  final String? taskStatus;
  final String? allotmentDate;
  final String? completionDate;
  final UserInfo? createdBy;
  final UserInfo? assignedTo;
  final Project? project;
  final Team? team;
  final String? createdAt;

  TaskInfo({
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.taskPriorityStatus,
    required this.taskStatus,
    required this.allotmentDate,
    required this.completionDate,
    required this.createdBy,
    required this.assignedTo,
    required this.project,
    required this.team,
    required this.createdAt,
  });

  factory TaskInfo.fromJson(Map<String, dynamic> json) {
    return TaskInfo(
      taskId: json['taskId'] ?? 0,
      taskName: json['taskName'] ?? " ",
      taskDescription: json['taskDescription'] ?? " ",
      taskPriorityStatus: json['taskPriorityStatus'] ?? " ",
      taskStatus: json['taskStatus'] ?? " ",
      allotmentDate: json['allotmentDate'] ?? " ",
      completionDate: json['completionDate'] ?? " ",
      createdBy: json['createdBy'] != null
          ? UserInfo.fromJson(json['createdBy'])
          : null,
      assignedTo: json["assignedTo"] != null
          ? UserInfo.fromJson(json['assignedTo'])
          : null,
      project:
          json["project"] != null ? Project.fromJson(json['project']) : null,
      team: json["team"] != null ? Team.fromJson(json['team']) : null,
      createdAt: json['createdAt'] ?? " ",
    );
  }
}

class UserInfo {
  final int? userUid;
  final String? userName;
  final String? userEid;

  UserInfo({
    required this.userUid,
    required this.userName,
    required this.userEid,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userUid: json['userUid'] ?? 0,
      userName: json['userName'] ?? " ",
      userEid: json['userEid'] ?? " ",
    );
  }
}

class Project {
  final int? projectUid;
  final String? projectName;

  Project({
    required this.projectUid,
    required this.projectName,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectUid: json['projectUid'] ?? " ",
      projectName: json['projectName'] ?? " ",
    );
  }
}

class Team {
  final int? teamUid;
  final String? teamName;

  Team({
    required this.teamUid,
    required this.teamName,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamUid: json['teamUid'] ?? " ",
      teamName: json['teamName'] ?? " ",
    );
  }
}

class Submit {
  final int? submissionUid;
  final UserInfo? submitBy;
  final UserInfo? submitTo;
  final String? taskSubmittedAt;
  final String? taskReviewAt;

  Submit({
    required this.submissionUid,
    required this.submitBy,
    required this.submitTo,
    required this.taskSubmittedAt,
    this.taskReviewAt,
  });

  factory Submit.fromJson(Map<String, dynamic> json) {
    return Submit(
      submissionUid: json['submissionUid'] ?? " ",
      submitBy:
          json["submitBy"] != null ? UserInfo.fromJson(json['submitBy']) : null,
      submitTo:
          json["submitTo"] != null ? UserInfo.fromJson(json['submitTo']) : null,
      taskSubmittedAt: json['taskSubmittedAt'] ?? " ",
      taskReviewAt: json['taskReviewAt'] = null ?? " ",
    );
  }
}

class FileAttachment {
  final int fileIdd;
  final String? mimeType;
  final String? fileUrll;
  final String? downloadUrll;
  final String? uploadedAtt;

  FileAttachment({
    required this.fileIdd,
    this.mimeType,
    required this.fileUrll,
    required this.downloadUrll,
    required this.uploadedAtt,
  });

  factory FileAttachment.fromJson(Map<String, dynamic> json) {
    return FileAttachment(
      fileIdd: json['fileIdd'] ?? 0,
      mimeType: json['mimeType'] ?? " ",
      fileUrll: json['fileUrll'] ?? " ",
      downloadUrll: json['downloadUrll'] ?? " ",
      uploadedAtt: json['uploadedAtt'] ?? " ",
    );
  }
}
