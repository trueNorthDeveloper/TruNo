class TaskReview {
  final int taskId;
 // final String taskDescription;
  final String taskStatus;
 // final String? taskPriority;
  final String submitStatus;
  final String submitMessage;

  TaskReview({
    required this.taskId,
   // required this.taskDescription,
    required this.taskStatus,
   //  this.taskPriority,
    required this.submitStatus,
    required this.submitMessage,
  });

  factory TaskReview.fromJson(Map<String, dynamic> json) {
    return TaskReview(
      taskId: json['taskId']??"",
     // taskDescription: json['taskDescription']??"",
      taskStatus: json['taskStatus']??"",
    //  taskPriority: json['taskPriority']??"",
      submitStatus: json['submitStatus']??"",
      submitMessage: json['submitMessage']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
     // 'taskDescription': taskDescription,
      'taskStatus': taskStatus,
    //  'taskPriority': taskPriority,
      'submitStatus': submitStatus,
      'submitMessage': submitMessage,
    };
  }
}
