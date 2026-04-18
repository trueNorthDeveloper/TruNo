import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:truenorthflutterfrontend/app/managerApplication/model/leaveRequestResponse.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAttendanceAndLeaveModule/services/attendanceService.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';

class TeamleaderControllerPro extends ChangeNotifier {
  ///call user serive class for implement middle layer of api call
  Attendanceservice _attendanceservice = Attendanceservice();
  int counter = 0;
  void increaseCounterForTeam(int value) {
    counter = value;
    notifyListeners();
  }

  bool _changeIcn = true;
  bool get changeIcn => _changeIcn;
  void changeIcons() {
    _changeIcn = !changeIcn;
    notifyListeners();
  }

  final TextEditingController _allotmentDateController =
      TextEditingController();
  final TextEditingController _completionDateController =
      TextEditingController();

  DateTime? _allotmentDate;
  DateTime? _completionDate;

  TextEditingController get allotmentDateController => _allotmentDateController;
  TextEditingController get completionDateController =>
      _completionDateController;

  DateTime? get allotmentDate => _allotmentDate;
  DateTime? get completionDate => _completionDate;

  Future<void> selectDate({
    required BuildContext context,
    required bool isCompletionDate,
  }) async {
    final DateTime initialDate = isCompletionDate
        ? (_completionDate ?? DateTime.now())
        : (_allotmentDate ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    if (isCompletionDate) {
      _completionDate = picked;
      _completionDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    } else {
      _allotmentDate = picked;
      _allotmentDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }

    notifyListeners();
  }

  // bool _checkBoxTrue = false;
  // bool get checkBoxTrue => _checkBoxTrue;
  // void changeCheckBox() {
  //   _checkBoxTrue = !checkBoxTrue;
  //   notifyListeners();
  // }

  int _selectedFilterIndex = 0; // -1 means none selected

  int get selectedFilterIndex => _selectedFilterIndex;

  void selectFilter(int index) {
    _selectedFilterIndex = index;
    notifyListeners();
  }

  String filterData(int value) {
    switch (value) {
      case 0:
        return "All";
      case 1:
        return "PENDING";
      case 2:
        return "COMPLETED";
      case 3:
        return "REVIEW";
      default:
        return "All";
    }
  }

  ///TEAM LEADER LEAVE REQUST SHOW FOR APPROVAL.....................................................
  LeaveRequestResponse? _leaveRequestResponse;
  LeaveRequestResponse? get leaveRequestResponse => _leaveRequestResponse;
  List<LeaveData> leaveList = [];
  bool _isShowRequest = false;
  bool get isShowRequest => _isShowRequest;

  Future<void> fetchLeaveApprovalRequests() async {
    _leaveRequestResponse = null;
    _isShowRequest = true;
    notifyListeners();

    try {
      // bool? role = await userRoleFind();
      bool isLeader = await TokenService.getLeaderRole();
      //if user not team leader so not move further
      if (!isLeader) {
        _isShowRequest = false;
        notifyListeners();
        return;
      }

      final apiResponse =
          await _attendanceservice.showLeaveRequestToTeamLeader();

      if (apiResponse.isSuccess && apiResponse.data != null) {
        _leaveRequestResponse = apiResponse.data;
      }

      // Use if-let or null check properly
    } catch (e) {
      // Never leave catch empty!
      debugPrint("Logic Error: $e");
    } finally {
      // finally ensures loading stops even if the code crashes
      _isShowRequest = false;
      notifyListeners();
    }
  }

  bool _isTeamLeader = false;
  bool get isTeamLeader => _isTeamLeader;

  // Initialize the role and fetch data if they are a leader
  Future<void> initializeUserDashboard() async {
    // 1. Get the role from SharedPreferences
    _isTeamLeader = await TokenService.getLeaderRole();
    notifyListeners();

    // 2. If they are a leader, automatically trigger the request fetch
    if (_isTeamLeader) {
      await fetchLeaveApprovalRequests();
    }
  }

  //
  bool _isUpdate = false;
  bool get isUpdate => _isUpdate;
  Future<void> updateLeaveStatusByTeamLeader(
      Map<String, dynamic> tojson) async {
    _isUpdate = true;
    notifyListeners();
    try {
      final updateStatus =
          await _attendanceservice.updateLeaveStausByTeamLeader(tojson);
      if (updateStatus.isSuccess && updateStatus.data != null) {
        print(updateStatus.data);
        //here need to call more more method again show team leader show all request again
        final apiResponse =
            await _attendanceservice.showLeaveRequestToTeamLeader();

        if (apiResponse.isSuccess && apiResponse.data != null) {
          _leaveRequestResponse = apiResponse.data;
          notifyListeners();
        }
      }
    } catch (e) {
      print(e);
    }
    _isUpdate = false;
    notifyListeners();
  }
}
