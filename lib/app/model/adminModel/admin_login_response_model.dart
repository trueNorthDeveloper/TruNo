class LoginResponse {
  final bool success;
  final String message;
  final EmployeeData data;
  final DateTime date;

  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.date,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      message: json['message'],
      data: EmployeeData.fromJson(json['data']),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
    'date': date.toIso8601String(),
  };
}

class EmployeeData {
  final int uuid;
  final String empId;
  final String empName;
  final String role;

  EmployeeData({
    required this.uuid,
    required this.empId,
    required this.empName,
    required this.role,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      uuid: json['uuid'],
      empId: json['empId'],
      empName: json['empName'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'empId': empId,
    'empName': empName,
    'role': role,
  };
}
