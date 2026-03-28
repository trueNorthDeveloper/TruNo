import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/user_daily_attendance.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/services/attendanceService.dart';

class Attendancecontroller extends ChangeNotifier {
//create attendance service classs object for call api
  Attendanceservice _attendanceservice = Attendanceservice();
// GET USER DAILY ATTENDANCE USING PROVIDER.....

  UserDailyAttendance? _userDailyAttendance;
  UserDailyAttendance? get userDailyAttendance => _userDailyAttendance;

  Map<String, String> attendanceListMap = {};
  Map<String, List<Sessions>> attendanceEvent = {};
  List<Sessions> _selectedDaySessions = []; // Store the filtered list here

  List<Sessions> get selectedDaySessions => _selectedDaySessions;

  void updateSelectedSessions(String dateKey) {
    _selectedDaySessions = attendanceEvent[dateKey] ?? [];
    notifyListeners(); // Refresh the ListView
  }

  void prepareEventData() {
    attendanceEvent.clear();

    if (userDailyAttendance?.data != null) {
      for (var item in userDailyAttendance!.data!) {
        if (item.date != null && item.session != null) {
          attendanceEvent[item.date!] = item.session!;
        }
      }
    }

    notifyListeners();
  }

  void prepareDataWithmodelClass() {
    // Clear the old month's data before adding new data
    attendanceListMap.clear();

    if (_userDailyAttendance?.data != null) {
      for (var item in _userDailyAttendance!.data!) {
        if (item.date != null && item.status != null) {
          attendanceListMap[item.date!] = item.status!;
        }
      }
    }
    notifyListeners();
  }

  bool isLoadAttendace = false;
  String? _lastFetchedMonth;
  Future<void> fatchUserDailyAttendance(dynamic year, dynamic month) async {
    final key = "$year-$month";
    if (_lastFetchedMonth == key) {
      print("⚠️ Already fetched for $key");
      return;
    }
    _lastFetchedMonth = key;

    print("attendnce called");
    isLoadAttendace = true;
    notifyListeners();

    final response =
        await _attendanceservice.getUserDailyAttenadance(year, month);

    if (response.isSuccess) {
      // step 1: Assign to the class-level variable, not a local one
      _userDailyAttendance = response.data;

      // step 2: Automatically map the data so the UI updates immediately
      prepareDataWithmodelClass();
      prepareEventData();
    }

    isLoadAttendace = false;
    notifyListeners();
  }
  //DateTime get focusedDay => _focusedDay;

  // 2. Add this method to update the state
  void updateFocusedDay(DateTime newDay) {
    // Only update if the day actually changed to avoid unnecessary rebuilds
    if (_focusedDay != newDay) {
      _focusedDay = newDay;

      // Notify listeners so the CalendarHeader and TableCalendar
      // rebuild with the correct month title
      notifyListeners();
    }
  }

  void resetToToday() {
    _focusedDay = DateTime.now();
    notifyListeners();
  }

  DateTime? _focusedDay = DateTime.now();
  DateTime? get focusedDay => _focusedDay;

  DateTime _firstDay = new DateTime(2025, 1, 1);
  DateTime get firstDay => _firstDay;
  DateTime _lastDay = new DateTime(2030, 12, 30);
  DateTime get lastDay => _lastDay;
  final DateTime? _currentDay = DateTime.now(); // Immutable initial value

  DateTime? get currentDay => _currentDay;
  Map<String, String> attendanceMap = {};
  void prepareAttendanceData() {
    for (var item in event) {
      attendanceMap[item['date']] = item['status'];
    }
    notifyListeners();
  }

  final List<Map<String, dynamic>> event = [
    {
      "date": "2026-03-01",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-02",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-03",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-04",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-05",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-06",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-07",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-08",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-09",
      "status": "Present",
      "totalSession": 1,
      "session": [
        {
          "loginDate": "2026-03-09",
          "loginTime": "2026-03-09T10:48:57.703115",
          "logOutTime": "2026-03-12T12:12:23.7001",
          "workingHour": "73 hours 23 minutes"
        }
      ],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-10",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-11",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-12",
      "status": "Present",
      "totalSession": 1,
      "session": [
        {
          "loginDate": "2026-03-12",
          "loginTime": "2026-03-12T12:12:34.360331",
          "logOutTime": "2026-03-12T12:27:03.684999",
          "workingHour": "0 hours 14 minutes"
        }
      ],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-13",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-14",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-15",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-16",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-17",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-18",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-19",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-20",
      "status": "Present",
      "totalSession": 1,
      "session": [
        {
          "loginDate": "2026-03-20",
          "loginTime": "2026-03-20T17:10:16.019108",
          "logOutTime": "2026-03-20T18:13:02.537351",
          "workingHour": "1 hours 2 minutes"
        }
      ],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-21",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-22",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-23",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-24",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-25",
      "status": "Absent",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-26",
      "status": "Upcoming",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-27",
      "status": "Upcoming",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-28",
      "status": "Upcoming",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-29",
      "status": "Upcoming",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-30",
      "status": "Upcoming",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    },
    {
      "date": "2026-03-31",
      "status": "Upcoming",
      "totalSession": 0,
      "session": [],
      "leave": null,
      "holiday": null
    }
  ];
}
