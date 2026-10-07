
class AdminLogoutRecord {
  final String loginDate;
  final String loginTime;
  final String role;
  final String loginAddress;
  final String loginLatitude;
  final String loginLongitude;
  final String empName;
  final String empId;
  //logout details
  final String logoutTime;
  final String logoutinDate;
  final String logoutAddress;
  final String logoutLatitude;
  final String logoutLongitude;

  AdminLogoutRecord(
      {required this.loginDate,
      required this.loginTime,
      required this.role,
      required this.loginAddress,
      required this.loginLatitude,
      required this.loginLongitude,
      required this.empName,
      required this.empId,
      required this.logoutTime,
      required this.logoutinDate,
      required this.logoutAddress,
      required this.logoutLatitude,
      required this.logoutLongitude});
  bool get isTeamLeader => role == 'TEAMLEADER';
  factory AdminLogoutRecord.fromJson(Map<String, dynamic> json) =>
      AdminLogoutRecord(
          loginDate: json['loginDate'] ?? '',
          loginTime: json['loginTime'] ?? '',
          role: json['role'] ?? '',
          loginAddress: json['address'] ?? '',
          loginLatitude: json['latitude'] ?? '',
          loginLongitude: json['longitude'] ?? '',
          empName: json['empName'] ?? '',
          empId: json['empId'] ?? '',
          logoutAddress: json['logoutAddress'] ?? ' ',
          logoutLatitude: json['logoutLatitude'] ?? ' ',
          logoutTime: json["logoutTime"] ?? '',
          logoutLongitude: json['logoutLongitude'] ?? '',
          logoutinDate: json['logoutinDate'] ?? ''
          );

  bool matches(String query) {
    final q = query.toLowerCase();
    return empName.toLowerCase().contains(q) ||
        empId.toLowerCase().contains(q) ||
        role.toLowerCase().contains(q);
  }
}
