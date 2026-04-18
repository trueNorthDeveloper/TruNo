class ProjectTeamResponse {
  bool success;
  String message;
  List<ProjectTeam> data;

  ProjectTeamResponse(
      {required this.success, required this.message, required this.data});

  factory ProjectTeamResponse.fromJson(Map<String, dynamic> json) {
    return ProjectTeamResponse(
        success: json['success'],
        message: json['message'],
        data: json['data'] != null
            ? (json['data'] as List)
                .map((item) => ProjectTeam.fromJson(item))
                .toList()
            : []);
  }
}

class ProjectTeam {
  int teamUid;
  String teamName;
  List<TeamMember> members;

  var tnecProjectTeamUid;
  ProjectTeam(
      {required this.teamUid, required this.teamName, required this.members});

  factory ProjectTeam.fromJson(Map<String, dynamic> json) {
    return ProjectTeam(
        teamUid: json['teamUid'],
        teamName: json['teamName'],
        members: json['members'] != null
            ? (json['members'] as List)
                .map((item) => TeamMember.fromJson(item))
                .toList()
            : []);
  }
}

class TeamMember {
  String memberName;
  String role;
  int userUid;
  TeamMember({required this.memberName, required this.role,required this.userUid});

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      memberName: json['memberName'],
      role: json['role'] as String? ?? "",
      userUid: json['userId'] as int? ?? 0,
    );
  }
}





// {
//     "success": true,
//     "message": "Teams retrieved successfully",
//     "data": [
//         {
//             "teamUid": 1,
//             "teamName": "Survey-Team",
//             "members": [
//                 {
//                     "memberName": "Navendra",
//                     "role": "TEAMLEADER"
//                 },
//                 {
//                     "memberName": "RAKESH KUMAR KUSHWAHA",
//                     "role": "MEMBER"
//                 },
//                 {
//                     "memberName": "SUNIL KUSHWAHA",
//                     "role": "MEMBER"
//                 },
//                 {
//                     "memberName": "PRASHANT KUMAR DAHAYAT",
//                     "role": "MEMBER"
//                 }
//             ]
//         }
//     ]
// }