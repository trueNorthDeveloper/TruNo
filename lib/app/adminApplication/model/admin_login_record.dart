class AdminAllLoginResponse {
  final String success;
  final String message;
  final AdminLoginData? data;
  AdminAllLoginResponse(
      {required this.success, required this.message, required this.data});
  factory AdminAllLoginResponse.fromJson(Map<String, dynamic> json) =>
      AdminAllLoginResponse(
        success: json["success"],
        message: json["message"],
        data:
            json["data"] != null ? AdminLoginData.fromJson(json["data"]) : null,
      );
}

class AdminLoginData {
  final List<AdminLoginRecord>? content;
  final dynamic page;
  final dynamic size;
  final dynamic totalElements;
  final dynamic totalPages;
  final dynamic first;
  final dynamic last;
  AdminLoginData(
      {required this.content,
      required this.page,
      required this.size,
      required this.totalElements,
      required this.totalPages,
      required this.first,
      required this.last});

  /// Factory method to construct AdminLoginData from a JSON map
  factory AdminLoginData.fromJson(Map<String, dynamic> json) {
    return AdminLoginData(
      content: json['content'] != null
          ? (json['content'] as List)
              .map((item) =>
                  AdminLoginRecord.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      page: json['page'] ?? 0, // Fallback to 0 if null
      size: json['size'] ?? 0, // Fallback to 0 if null
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      first: json['first'] ?? false, // Fallback to false if null
      last: json['last'] ?? false, // Fallback to false if null
    );
  }
}

class AdminLoginRecord {
  final String loginDate;
  final String loginTime;
  final String role;
  final String address;
  final String latitude;
  final String longitude;
  final String empName;
  final String empId;

  AdminLoginRecord({
    required this.loginDate,
    required this.loginTime,
    required this.role,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.empName,
    required this.empId,
  });
  bool get isTeamLeader => role == 'TEAMLEADER';
  factory AdminLoginRecord.fromJson(Map<String, dynamic> json) =>
      AdminLoginRecord(
        loginDate: json['loginDate'] ?? '',
        loginTime: json['loginTime'] ?? '',
        role: json['role'] ?? '',
        address: json['address'] ?? '',
        latitude: json['latitude'] ?? '',
        longitude: json['longitude'] ?? '',
        empName: json['empName'] ?? '',
        empId: json['empId'] ?? '',
      );

  bool matches(String query) {
    final q = query.toLowerCase();
    return empName.toLowerCase().contains(q) ||
        empId.toLowerCase().contains(q) ||
        role.toLowerCase().contains(q);
  }
}
