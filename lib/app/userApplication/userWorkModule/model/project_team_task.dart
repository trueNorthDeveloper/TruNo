class ProjectTeamTask {
  final bool success;
  final String message;
  final List<AllTask> content;
    final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool first;
  final bool last;
  ProjectTeamTask(
      {required this.success, required this.message, required this.content,required this.page,required this.size, required this.totalElements,required this.totalPages,required this.first,required this.last});
  factory ProjectTeamTask.fromJson(Map<String, dynamic> json) {
    return ProjectTeamTask(
      success: json['success']??true,
      message: json['message']??"Success",
      content: json['content'] != null
          ? (json['content'] as List)
              .map((item) => AllTask.fromJson(item))
              .toList()
          : [],
          page: json['page']??0,
          size: json['size']??10,
          totalElements: json['totalElements']??0,
          totalPages: json['totalPages']??0,
          first: json['first']??false,
          last: json['last']??false
        
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': List<dynamic>.from(content.map((x) => x.toJson())),
    };
  }
}

class AllTask {
  final int? taskId;
  final String? taskName;
  final String? taskDescription;
  final String? taskPriorityStatus;
  final String? taskStatus;
  final String? allotmentDate;
  final String? completionDate;
  final CreateUser? createdBy;
  final CreateUser? assignedTo;
  final TaskProject? project;
  final TaskTeam? team;
  final String? createdAt;
  final String? submitDate;

  AllTask({
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

  factory AllTask.fromJson(Map<String, dynamic> json) {
    return AllTask(
      taskId: json['taskId'],
      taskName: json['taskName'],
      taskDescription: json['taskDescription'],
      taskPriorityStatus: json['taskPriorityStatus'],
      taskStatus: json['taskStatus'],
      allotmentDate: json['allotmentDate'],
      completionDate: json['completionDate'],
      createdBy: CreateUser.fromJson(json['createdBy']),
      assignedTo: CreateUser.fromJson(json['assignedTo']),
      project: TaskProject.fromJson(json['project']),
      team: TaskTeam.fromJson(json['team']),
      createdAt: json['createdAt'],
      submitDate: json['submitDate'] ?? "",
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
      'createdBy': createdBy?.toJson(),
      'assignedTo': assignedTo?.toJson(),
      'project': project!.toJson(),
      'team': team!.toJson(),
      'createdAt': createdAt,
    };
  }
}

class CreateUser {
  final int userUid;
  final String userEid;
  final String userName;

  CreateUser({
    required this.userUid,
    required this.userEid,
    required this.userName,
  });

  factory CreateUser.fromJson(Map<String, dynamic> json) {
    return CreateUser(
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

class TaskProject {
  final int projectUid;
  final String projectName;

  TaskProject({
    required this.projectUid,
    required this.projectName,
  });

  factory TaskProject.fromJson(Map<String, dynamic> json) {
    return TaskProject(
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

class TaskTeam {
  final int teamUid;
  final String teamName;

  TaskTeam({
    required this.teamUid,
    required this.teamName,
  });

  factory TaskTeam.fromJson(Map<String, dynamic> json) {
    return TaskTeam(
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
