class TaskReviewResponse {
  final bool success;
  final String message;
  final List<TaskData> data;

  TaskReviewResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TaskReviewResponse.fromJson(Map<String, dynamic> json) {
    return TaskReviewResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => TaskData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TaskData {
  final Task task;
  final String taskSubmitMessage;
  final String submitDate;
  final String taskSubmitStatus;
  
  final User submittedTo;
  final User submittedBy;
  final List<FileModel>? files;

  TaskData({
    required this.task,
    required this.taskSubmitMessage,
    required this.taskSubmitStatus,
    required this.submitDate,
    required this.submittedTo,
    required this.submittedBy,
    this.files,
  });

  factory TaskData.fromJson(Map<String, dynamic> json) {
    return TaskData(
      task: Task.fromJson(json['task']),
      
      taskSubmitMessage: json['taskSubmitMessage']??"",
      taskSubmitStatus: json['taskSubmitStatus']??"",
      submitDate: json['submitDate']??"",
      submittedTo: User.fromJson(json['submittedTo']??{}),
      submittedBy: User.fromJson(json['submittedBy']??{}),
      files: (json['files'] as List<dynamic>?)
              ?.map((e) => FileModel.fromJson(e))
              .toList(),
    );
  }
}

class Task {
  final int taskId;
  final String taskName;
  final String taskDescription;
  final String taskPriorityStatus;
  final String taskStatus;
  final String allotmentDate;
  final String completionDate;
  final User createdBy;
  final AssignedUser assignedTo;
  final Project project;
  final Team team;
  final String createdAt;
  

  Task({
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

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      taskName: json['taskName']??"",
      taskDescription: json['taskDescription']??"",
      taskPriorityStatus: json['taskPriorityStatus']??"",
      taskStatus: json['taskStatus']??"",
      allotmentDate: json['allotmentDate']??"",
      completionDate: json['completionDate']??"",
      createdBy: User.fromJson(json['createdBy']),
      assignedTo: AssignedUser.fromJson(json['assignedTo']),
      
      project: Project.fromJson(json['project']),
      team: Team.fromJson(json['team']),
      createdAt: json['createdAt']??"",

    );
  }
}

class User {
  final int submitToId; // or userUid
  final String role; // or userEid
  final String name; // or userName

  User({
    required this.submitToId,
    required this.role,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      submitToId: json['submitToId'] ?? json['userUid'] ?? json['submitById'],
      role: json['role'] ?? json['userEid'] ?? '',
      name: json['name'] ?? json['userName'] ?? '',
    );
  }
}

class Project {
  final int projectUid;
  final String projectName;

  Project({
    required this.projectUid,
    required this.projectName,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectUid: json['projectUid'],
      projectName: json['projectName'],
    );
  }
}

class Team {
  final int teamUid;
  final String teamName;

  Team({
    required this.teamUid,
    required this.teamName,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamUid: json['teamUid'],
      teamName: json['teamName'],
    );
  }
}

class FileModel {
  final int fileIdd;
   final String mimeType ;
  final String fileUrll;
  final String? downloadUrll;
  final String uploadedAtt;

  FileModel({
    required this.fileIdd,
    required this.fileUrll,
    this.downloadUrll,
    required this.mimeType,
    required this.uploadedAtt,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      fileIdd: json['fileIdd'],
      mimeType: json['mimeType']?? "",
      fileUrll: json['fileUrll']?? "",
      downloadUrll: json['downloadUrll']?? "",
      uploadedAtt: json['uploadedAtt']?? "",
    );
  }
}
class AssignedUser {
  final int userUid;
  final String userEid;
  final String userName;

  AssignedUser({
    required this.userUid,
    required this.userEid,
    required this.userName,
  });

  factory AssignedUser.fromJson(Map<String, dynamic> json) {
    return AssignedUser(
      userUid: json['userUid'] ?? 0,
      userEid: json['userEid'] ?? '',
      userName: json['userName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userUid': userUid,
      'userEid': userEid,
      'userName': userName,
    };
  }
}
class SubmittedBy {
  final int submitById;
  final String role;
  final String name;

  SubmittedBy({
    required this.submitById,
    required this.role,
    required this.name,
  });

  factory SubmittedBy.fromJson(Map<String, dynamic> json) {
    return SubmittedBy(
      submitById: json['submitById'] ?? 0,
      role: json['role'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'submitById': submitById,
      'role': role,
      'name': name,
    };
  }
}
class SubmittedTo {
  final int submitToId;
  final String role;
  final String name;

  SubmittedTo({
    required this.submitToId,
    required this.role,
    required this.name,
  });

  factory SubmittedTo.fromJson(Map<String, dynamic> json) {
    return SubmittedTo(
      submitToId: json['submitToId'] ?? 0,
      role: json['role'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'submitToId': submitToId,
      'role': role,
      'name': name,
    };
  }
}
