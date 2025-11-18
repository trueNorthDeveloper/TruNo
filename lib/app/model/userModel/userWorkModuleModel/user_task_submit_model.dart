class TaskSubmit {
  int taskId;
  int submittedById;
  int submittedToId;
  String message;
  String parent;
  String child;
  String team;
  String userEid;

  TaskSubmit(
      {required this.taskId,
      required this.submittedById,
      required this.submittedToId,
      required this.message,
      required this.parent,
      required this.child,
      required this.team,
      required this.userEid});
  Map<String, dynamic> toJson() => {
        "taskId": taskId,
        "submittedById": submittedById,
        "submittedToId": submittedToId,
        "message": message,
        "parent": parent,
        "child": child,
        "team": team,
        "userEid": userEid,
      };
}
// {
//   "taskId": 3,
//   "submittedById": 1,
//   "submittedToId": 7,
//   "submitStatus": "SUBMITTED",
//   "message": "Task submitted for review",
//   "submittedAt": "2025-08-28"
// }
