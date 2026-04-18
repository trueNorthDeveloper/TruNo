class ProjectTypeResponse {
  final bool success;
  final String message;
  final List<ProjectType>? data;

  ProjectTypeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProjectTypeResponse.fromJson(Map<String, dynamic> json) {
    return ProjectTypeResponse(
      success: json['success'],
      message: json['message'],
    data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => ProjectType.fromJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList() ?? [],
    };
  }
}

class ProjectType {
  final int tnecProjectTypeUid;
  final String tnecProjectTypeName;

  ProjectType({
    required this.tnecProjectTypeUid,
    required this.tnecProjectTypeName,
  });

  factory ProjectType.fromJson(Map<String, dynamic> json) {
    return ProjectType(
      tnecProjectTypeUid: json['tnecProjectTypeUid'],
      tnecProjectTypeName: json['tnecProjectTypeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tnecProjectTypeUid': tnecProjectTypeUid,
      'tnecProjectTypeName': tnecProjectTypeName,
    };
  }
}
