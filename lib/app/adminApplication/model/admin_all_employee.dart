class ApiResponse {
  final bool? success;
  final String? message;
  final DataContent? data;

  ApiResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? DataContent.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class DataContent {
  final List<Employee>? content;

  DataContent({this.content});

  factory DataContent.fromJson(Map<String, dynamic> json) {
    return DataContent(
      content: json['content'] != null
          ? (json['content'] as List)
              .map((i) => Employee.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content?.map((e) => e.toJson()).toList(),
    };
  }
}

class Employee {
  final int? uuid;
  final String? empId;
  final String? empName;
  final String? empDob;
  final String? empEmail;
  final String? joinDate;
  final String? empDesignation;
  final String? empSystemName;
  final String? empSystemType;
  final String? empWorkingType;
  final int? empCl;
  final int? empMl;
  final String? empPassword;
  final String? empMobile;
  final String? empWorkingLocation;
  final String? createdDate;
  final String? role;
  final int? curcl;
  final int? cuml;
  final int? curlwp;
  final int? nextcl;
  final int? nextml;
  final dynamic
      userInterface; // declared dynamic to handle null or mixed values smoothly
  final String? workStatus;

  Employee({
    this.uuid,
    this.empId,
    this.empName,
    this.empDob,
    this.empEmail,
    this.joinDate,
    this.empDesignation,
    this.empSystemName,
    this.empSystemType,
    this.empWorkingType,
    this.empCl,
    this.empMl,
    this.empPassword,
    this.empMobile,
    this.empWorkingLocation,
    this.createdDate,
    this.role,
    this.curcl,
    this.cuml,
    this.curlwp,
    this.nextcl,
    this.nextml,
    this.userInterface,
    this.workStatus,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      uuid: json['uuid'] as int?,
      empId: json['empId'] as String?,
      empName: json['empName'] as String?,
      empDob: json['empDob'] as String?,
      empEmail: json['empEmail'] as String?,
      joinDate: json['joinDate'] as String?,
      empDesignation: json['empDesignation'] as String?,
      empSystemName: json['empSystemName'] as String?,
      empSystemType: json['empSystemType'] as String?,
      empWorkingType: json['empWorkingType'] as String?,
      empCl: json['empCl'] as int?,
      empMl: json['empMl'] as int?,
      empPassword: json['empPassword'] as String?,
      empMobile: json['empMobile'] as String?,
      empWorkingLocation: json['empWorkingLocation'] as String?,
      createdDate: json['createdDate'] as String?,
      role: json['role'] as String?,
      curcl: json['curcl'] as int?,
      cuml: json['cuml'] as int?,
      curlwp: json['curlwp'] as int?,
      nextcl: json['nextcl'] as int?,
      nextml: json['nextml'] as int?,
      userInterface: json['userInterface'],
      workStatus: json['workStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'empId': empId,
      'empName': empName,
      'empDob': empDob,
      'empEmail': empEmail,
      'joinDate': joinDate,
      'empDesignation': empDesignation,
      'empSystemName': empSystemName,
      'empSystemType': empSystemType,
      'empWorkingType': empWorkingType,
      'empCl': empCl,
      'empMl': empMl,
      'empPassword': empPassword,
      'empMobile': empMobile,
      'empWorkingLocation': empWorkingLocation,
      'createdDate': createdDate,
      'role': role,
      'curcl': curcl,
      'cuml': cuml,
      'curlwp': curlwp,
      'nextcl': nextcl,
      'nextml': nextml,
      'userInterface': userInterface,
      'workStatus': workStatus,
    };
  }
  bool matches(String query) {
    final q = query.toLowerCase();
    return empName!.toLowerCase().contains(q) ||
        empId!.toLowerCase().contains(q) ||
        role!.toLowerCase().contains(q);
  }
}
