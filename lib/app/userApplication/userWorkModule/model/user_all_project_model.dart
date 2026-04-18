class AllProject {
  int projectUid;
  String projectName;
  String projectDescription;

  String projectStartDate;
  String projectEndDate;
  String workDuration;
  String projectId;
  String status;

  AllProject(
      {required this.projectUid,
      required this.projectName,
      required this.projectDescription,
      required this.projectStartDate,
      required this.projectEndDate,
      required this.status,
      required this.projectId,
      required this.workDuration});
//this method convert object to json.............................
  Map<String, dynamic> toJson() {
    return {
      "projectUid": projectUid,
      "projectName": projectName,
      "projectDescription": projectDescription,
      "projectStartDate": projectStartDate,
      "projectEndDate": projectEndDate,
      "workDuration": workDuration,
      "projectId": projectId,
      "status": status,
    };
  }

  factory AllProject.fromJson(Map<String, dynamic> json) {
    return AllProject(
        projectUid: json["projectUid"] ?? 0,
        projectName: json["projectName"] ?? " ",
        projectDescription: json["projectDescription"] ?? " ",
        projectId: json["projectStartDate"] ?? " ",
        projectEndDate: json["projectEndDate"] ?? " ",
        projectStartDate: json["projectId"] ?? " ",
        status: json["status"] ?? " ",
        workDuration: json["workDuration"] ?? " ");
  }
}
