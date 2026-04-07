import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/apply_leave.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/can_apply_leave.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/leave_history.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/user_daily_attendance.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/model/user_leave_logs.dart';
import 'package:truenorthflutterfrontend/app/userAttendanceModuleAndLeave/services/attendanceService.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';

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
  //USER ALL OVER LEAVE LOGS................................................
  UserLeaveLogs? _userLeaveLogs;
  UserLeaveLogs? get userLeaveLogs => _userLeaveLogs;
  bool _isLeaveLogs = false;
  bool get isLeaveLogs => _isLeaveLogs;
  Future<void> getLeaveLogs() async {
    _isLeaveLogs = true;
    notifyListeners();

    try {
      final logResponse = await _attendanceservice.fatchUserLeaveLogs();
      if (logResponse.isSuccess) {
        _userLeaveLogs = logResponse.data;
      } else {
        _userLeaveLogs = null; // Ensure it's null on failure
      }
    } catch (e) {
      _userLeaveLogs = null;
    } finally {
      _isLeaveLogs = false; // Set to false only ONCE at the very end
      notifyListeners();
    }
  }

//USER CAN APPLY LEAVE OR NOT USING THIS  DISABLE BUUTON
  CanApplyLeave? _canApplyLeave;
  CanApplyLeave? get canApplyLeave => _canApplyLeave;
  bool _isLeaveApply = false;
  bool get isLeaveApply => _isLeaveApply;
  Future<void> canApplyLeaveGet() async {
    _isLeaveApply = true;
    notifyListeners();
    try {
      final response = await _attendanceservice.canApplyLeaveFatch();
      if (response.isSuccess) {
        _canApplyLeave = response.data;
        print(response.data!.data);
      } else {
        _canApplyLeave = null;
      }
    } catch (e) {
      _canApplyLeave = null;
    } finally {
      _isLeaveApply = false;
      notifyListeners();
    }
  }

//FUNCTION FOR APPLY LEAVE...........................
  ApplyLeaveResponse? applyLeaveResponse;
  bool _isAppy = false;
  bool get isApply => _isAppy;
  Future<ApplyLeaveResponse?> applyMonthlyLeave(
      Map<String, dynamic> tojson) async {
    _isAppy = true;
    notifyListeners();

    final response = await _attendanceservice.applyMonthLeaveService(tojson);

    _isAppy = false;

    if (response.isSuccess) {
      applyLeaveResponse = response.data;
      notifyListeners();
      return applyLeaveResponse;
    } else {
      // FIX: Extract the response data even if it's an error (isSuccess is false)
      // This assumes your service still provides the parsed JSON in response.data on 400/500 errors
      final errorResponse = response.data;
      notifyListeners();
      return errorResponse;
    }
  }
//USER LEAVE APPLY HISTORY................................. TRACK WITH PAGINATOION

  // LeaveHistoryResponse? _leaveHistoryResponse;
  // LeaveHistoryResponse? get leaveHistoryResponse => _leaveHistoryResponse;
  // List<LeaveRequest> _leaveHistory = [];
  // List<LeaveRequest> get leaveHisry => _leaveHistory;

  // bool _showLeaveHistory = false;
  // bool get showLeaveHistory => _showLeaveHistory;
  ApiError? error;
  // int _currentPage = 0;
  // int _size = 10;
  // int get currentPage => _currentPage;
  // int get size => _size;
  // bool _isLastPage = false;
  List<LeaveRequest> _leaveList = [];
  List<LeaveRequest> get leaveList => _leaveList;
  int _currentPage = 0;
  bool _isLoadingMore = false;
  bool _hasNextPage = true;
  bool isRefresh = false;
  int _size = 10; // Ensure this is defined

  bool get isLoadingMore => _isLoadingMore;

  Future<void> showUserLeaveApplyHistory({bool isRefresh = false}) async {
    // 1. Reset logic for Refresh
    if (isRefresh) {
      _currentPage = 0;
      _hasNextPage = true;
      _leaveList.clear(); // Clear existing list to show fresh data
      // We don't 'return' here, we continue to fetch the first page
    }

    // 2. Guard Clause: Don't fetch if already loading or no more data
    if (!_hasNextPage || _isLoadingMore) return;

    _isLoadingMore = true;
    error = null;
    notifyListeners();

    try {
      final response = await _attendanceservice.showUserapplyLeaveHistory(
          _currentPage, _size);

      if (response.isSuccess && response.data != null) {
        final pageData = response.data!;

        // 3. Add data to the list
        _leaveList.addAll(pageData.content ?? []);

        // 4. Update pagination status
        _hasNextPage = !(pageData.last ?? true);
        _currentPage++;
      } else {
        error = ApiError.invalidData;
      }
    } catch (e) {
      error = ApiError.invalidData;
      debugPrint("Pagination Error: $e");
    } finally {
      // 5. Always stop loading and notify UI
      _isLoadingMore = false;
      notifyListeners();
    }
  }
  //team leader show leave request
}
