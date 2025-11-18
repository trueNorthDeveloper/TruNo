class TaskResponse {
  final bool success;
  final String message;
  final List<Task> data;

  TaskResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => Task.fromJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
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
  final User assignedTo;
  final Project project;
  final Team team;
  final String createdAt;
  final String submitDate;

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
    required this.submitDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      taskName: json['taskName'],
      taskDescription: json['taskDescription'],
      taskPriorityStatus: json['taskPriorityStatus'],
      taskStatus: json['taskStatus'],
      allotmentDate: json['allotmentDate'],
      completionDate: json['completionDate'],
      createdBy: User.fromJson(json['createdBy']),
      assignedTo: User.fromJson(json['assignedTo']),
      project: Project.fromJson(json['project']),
      team: Team.fromJson(json['team']),
      createdAt: json['createdAt'],
      submitDate: json['submitDate']?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskPriorityStatus': taskPriorityStatus,
      'taskStatus': taskStatus,
      'allotmentDate': allotmentDate,
      'completionDate': completionDate,
      'createdBy': createdBy.toJson(),
      'assignedTo': assignedTo.toJson(),
      'project': project.toJson(),
      'team': team.toJson(),
      'createdAt': createdAt,
    };
  }
}

class User {
  final int userUid;
  final String userEid;
  final String userName;

  User({
    required this.userUid,
    required this.userEid,
    required this.userName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userUid: json['userUid'],
      userEid: json['userEid'],
      userName: json['userName'],
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
// project.dart

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

  Map<String, dynamic> toJson() {
    return {
      'projectUid': projectUid,
      'projectName': projectName,
    };
  }
}
// team.dart

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

  Map<String, dynamic> toJson() {
    return {
      'teamUid': teamUid,
      'teamName': teamName,
    };
  }
}
