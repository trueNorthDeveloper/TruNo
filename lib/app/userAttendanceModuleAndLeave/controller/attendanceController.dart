import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/user_daily_attendance.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/services/attendanceService.dart';

class Attendancecontroller extends ChangeNotifier {
//create attendance service classs object for call api
  Attendanceservice _attendanceservice = Attendanceservice();
// GET USER DAILY ATTENDANCE USING PROVIDER.....

  UserDailyAttendance? _userDailyAttendance;
  UserDailyAttendance? get userDailyAttendance => _userDailyAttendance;
  
  bool isLoadAttendace = false;
  Future<void> fatchUserDailyAttendance() async {
    isLoadAttendace = true;
    notifyListeners();
    int year = 0;
    int month = 0;
    final response =
        await _attendanceservice.getUserDailyAttenadance(year, month);
    if (response.isSuccess) {
      isLoadAttendace = false;
    } else {
      isLoadAttendace = false;
    }
    isLoadAttendace = false;
    notifyListeners();
  }
}
