class CreateTaskByLeaderModel {
  final String taskName;
  final String taskDescription;
  final String taskPriorityStatus;
 // final String taskStatus;
  final int taskAssignedToUser;
  final int taskCreatedById;
  final String allotmentDate; // Or DateTime if parsing
  final String completionDate; // Or DateTime if parsing
  final int tnecProjectId;
  final int tnecPtTeamId;

  CreateTaskByLeaderModel({
    required this.taskName,
    required this.taskDescription,
    required this.taskPriorityStatus,
  // required this.taskStatus,
    required this.taskAssignedToUser,
    required this.taskCreatedById,
    required this.allotmentDate,
    required this.completionDate,
    required this.tnecProjectId,
    required this.tnecPtTeamId,
  });

  factory CreateTaskByLeaderModel.fromJson(Map<String, dynamic> json) {
    return CreateTaskByLeaderModel(
      taskName: json['taskName'] ?? '',
      taskDescription: json['taskDescription'] ?? '',
      taskPriorityStatus: json['taskPriorityStatus'] ?? '',
   // taskStatus: json['taskStatus'] ?? '',
      taskAssignedToUser: json['taskAssignedToUser'] ?? 0,
      taskCreatedById: json['taskCreatedById'] ?? 0,
      allotmentDate: json['allotmentDate'] ?? '',
      completionDate: json['completionDate'] ?? '',
      tnecProjectId: json['tnecProjectId'] ?? 0,
      tnecPtTeamId: json['tnecPtTeamId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskPriorityStatus': taskPriorityStatus,
      //'taskStatus': taskStatus,
      'taskAssignedToUser': taskAssignedToUser,
      'taskCreatedById': taskCreatedById,
      'allotmentDate': allotmentDate,
      'completionDate': completionDate,
      'tnecProjectId': tnecProjectId,
      'tnecPtTeamId': tnecPtTeamId,
    };
  }
}
