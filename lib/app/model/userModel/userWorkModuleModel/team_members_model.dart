class TeamResponse {
  final bool success;
  final String message;
  final List<Team> data;

  TeamResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TeamResponse.fromJson(Map<String, dynamic> json) {
    return TeamResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Team.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Team {
  final int teamUid;
  final String teamName;
  final List<Member> members;

  Team({
    required this.teamUid,
    required this.teamName,
    required this.members,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamUid: json['teamUid'] ?? 0,
      teamName: json['teamName'] ?? '',
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => Member.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teamUid': teamUid,
      'teamName': teamName,
      'members': members.map((e) => e.toJson()).toList(),
    };
  }
}

class Member {
  final int userId;
  final String memberName;
  final String role;

  Member({
    required this.userId,
    required this.memberName,
    required this.role,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      userId: json['userId'] ?? 0,
      memberName: json['memberName'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'memberName': memberName,
      'role': role,
    };
  }
}
