import 'package:intl/intl.dart';

class UserLoginInfoModel {
  String empName;
  DateTime loginTime;
  DateTime logoutTime;
  String imageURL;

  UserLoginInfoModel(
      {required this.empName, required this.loginTime, required this.imageURL})
      : logoutTime = loginTime.add(Duration(hours: 8));

 factory UserLoginInfoModel.fromJson(Map<String, dynamic> json) {
  
    final rawLoginTime = json['loginTime'];
    if (rawLoginTime == null || rawLoginTime.toString().isEmpty) {
      throw FormatException("Invalid or missing loginTime");
    }

    final parsedLoginTime = DateTime.parse(rawLoginTime);
    final empNameBeforeSpace = json['empName']?.toString().split(' ').first ?? '';

    final rawUrl = json['imageDownlaodLink']; // ✅ Corrected spelling
    final validUrl = rawUrl != null && rawUrl.toString().trim().isNotEmpty
        ? rawUrl.toString().trim()
        : '';

    return UserLoginInfoModel(
      empName: empNameBeforeSpace,
      loginTime: parsedLoginTime,
      imageURL: validUrl,
    );
}

  String? get formattedLoginTime {
    return DateFormat('h:mm a').format(loginTime);
  }

  String? get formattedLogoutTime {
    return DateFormat('h:mm a').format(logoutTime);
  }
}
