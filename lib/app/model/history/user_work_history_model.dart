class UserWorkHistoryResponse {
  final List<TaskDetails> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool first;
  final bool last;

  UserWorkHistoryResponse({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.first,
    required this.last,
  });

  factory UserWorkHistoryResponse.fromJson(Map<String, dynamic> json) {
    return UserWorkHistoryResponse(
      content: (json['content'] as List)
          .map((e) => TaskDetails.fromJson(e))
          .toList(),
      page: json['page'],
      size: json['size'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      first: json['first'],
      last: json['last'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content.map((e) => e.toJson()).toList(),
      'page': page,
      'size': size,
      'totalElements': totalElements,
      'totalPages': totalPages,
      'first': first,
      'last': last,
    };
  }
}

class TaskDetails {
  final int taskId;
  final String taskName;
  final String taskDescription;
  final String priority;
  final String taskStatus;
  final String createdBy;
  final String allotmentDate;
  final String completionDate;
  final String projectName;
  final String? submitStatus;
  final String? submittedAt;

  TaskDetails({
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.priority,
    required this.taskStatus,
    required this.createdBy,
    required this.allotmentDate,
    required this.completionDate,
    required this.projectName,
    this.submitStatus,
    this.submittedAt,
  });

  factory TaskDetails.fromJson(Map<String, dynamic> json) {
    return TaskDetails(
      taskId: json['taskId'],
      taskName: json['taskName'],
      taskDescription: json['taskDescription'],
      priority: json['priority'],
      taskStatus: json['taskStatus'],
      createdBy: json['createdBy'],
      allotmentDate: json['allotmentDate'],
      completionDate: json['completionDate'],
      projectName: json['projectName'],
      submitStatus: json['submitStatus'],
      submittedAt: json['submittedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'priority': priority,
      'taskStatus': taskStatus,
      'createdBy': createdBy,
      'allotmentDate': allotmentDate,
      'completionDate': completionDate,
      'projectName': projectName,
      'submitStatus': submitStatus,
      'submittedAt': submittedAt,
    };
  }
}
