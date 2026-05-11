import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/model/project_team_task.dart';

import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/services/user_work_module_service_api.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/model/user_complete_task_api_response_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/model/user_task_review_response_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/model/team_members_model.dart';

import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/model/user_project_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/model/user_project_team_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/model/user_project_type_model.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userWorkModule/model/user_task_response_model.dart';

import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';

class UserProjectProvider extends ChangeNotifier {
  int counter = 0;
  void increaseCounter(int value) {
    counter = value;
    notifyListeners();
  }

  final UserProjectService _service = UserProjectService();

  bool isLoading = false;
  ApiError? error;
  TeamResponse? teamResponse;
  ProjectTypeResponse? projectType;
  TaskResponse? taskResponse;
  TaskResponse? taskResponse2;

  Map<int, bool> isLoadingProjects = {};
  Map<int, userProjectResponse> userProjects = {};

  Map<int, bool> isLoadingTeams = {};
  Map<int, ProjectTeamResponse> projectTeams = {};

  Future<void> fatchAllProjectType() async {
    isLoading = true;
    error = null;
    notifyListeners();

    final result = await _service.fetchAllProjectType();
    if (result.isSuccess) {
      projectType = result.data;
    } else {
      error = result.error;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fatchAllProjects(int projectTypeUid) async {
    isLoadingProjects[projectTypeUid] = true;
    notifyListeners();

    final result = await _service.getAllProject(projectTypeUid);
    if (result.isSuccess) {
      userProjects[projectTypeUid] = result.data!;
    } else {
      error = result.error;
    }

    isLoadingProjects[projectTypeUid] = false;
    notifyListeners();
  }

  Future<void> fatchProjectTeam(int projectUid) async {
    isLoadingTeams[projectUid] = true;
    notifyListeners();

    final result = await _service.getProjectTeam(projectUid);
    if (result.isSuccess) {
      projectTeams[projectUid] = result.data!;
    } else {
      error = result.error;
    }

    isLoadingTeams[projectUid] = false;
    notifyListeners();
  }

  //GET USER TASK USING ID.......................
  bool isloadingTask = false;
  Future<void> fatchUserTask() async {
    isloadingTask = true;
    error = null;
    notifyListeners();

    try {
      final taskResult = await _service.getUserTask();

      if (taskResult.isSuccess) {
        taskResponse = taskResult.data;
      } else {
        error = taskResult.error;
        taskResponse = null; // optional: clear previous data on failure
      }
    } catch (e) {
      // Fallback in case the service throws an unexpected exception
      error = getApiErrorType(e);
      taskResponse = null;
    } finally {
      isloadingTask = false;
      notifyListeners();
    }
  }

  // Future<void> fatchUserTask() async {
  //   isloadingTask = true;
  //   error = null;
  //   notifyListeners();
  //   final task = await _service.getUserTask();
  //   if (task.isSuccess) {
  //     taskResponse = task.data;
  //   } else {
  //     error = task.error;
  //   }
  //   isloadingTask = false;
  //   notifyListeners();
  // }

  //FATCH ALL TASK FOR USER.................................

  bool isLoadingAllTak = false;

  Future<void> fatchAllTaskInTeam(int projectUid, int teamUid) async {
    isLoadingAllTak = true;
    error = null;
    notifyListeners();
    final allTask = await _service.getAllTaskInTeam(projectUid, teamUid);
    if (allTask.isSuccess) {
      taskResponse2 = allTask.data;
    } else {
      error = allTask.error;
    }
    isLoadingAllTak = false;
    notifyListeners();
  }

  //submit task.........................
  bool _isSubmitTask = false;
  bool get isSubmitTask => _isSubmitTask;

  Future<void> submitTask(Map<String, dynamic> json) async {
    print("this functio nis working");
    _isSubmitTask = true;
    error = error;
    notifyListeners();
    final submit = await _service.toSubmitTask(json);

    if (submit.isSuccess) {
      submit.data;
    } else {
      error = submit.error;
    }

    _isSubmitTask = false;
    notifyListeners();
  }
//date final submi task..................

  Future<void> submitTaskWithOrWithOutFileProvider(
      Map<String, dynamic> json, List<String> files) async {
    _isSubmitTask = true;
    error = error;
    notifyListeners();
    final submitResult = await _service.submitTaskWithWithOutFiles(json, files);
    if (submitResult.isSuccess) {
      // final rs = submitResult.data;
    } else {
      error = submitResult.error;
    }
    _isSubmitTask = false;
    notifyListeners();
  }

  //SUBMIT TAS FILE OR IMAGE.................
  bool _isSubmitFile = false;
  bool get isSubmitFile => _isSubmitFile;

  Future<void> submitTaskFile(
    String filepath,
    String parentName,
    String childName,
    String teamName,
    String userEid,
    int taskId,
  ) async {
    _isSubmitFile = true;
    error = error;
    notifyListeners();
    final submitFile = await _service.taskFileSubmission(
        filepath, parentName, childName, teamName, userEid, taskId);
    if (submitFile.isSuccess) {
      submitFile.data;
    } else {
      submitFile.error;
    }
    _isSubmitFile = false;
    notifyListeners();
  }

//get all team-member using project Id and TeamId............
  List<Member> teamMemberInfo = [];
  bool _isTeamMember = false;
  bool get isTeamMember => _isTeamMember;
  Future<void> fatchTeamMember(int projectId, int teamId) async {
    _isTeamMember = true;
    error = null;
    notifyListeners(); // show loader

    final response = await _service.getAllTeamMember(projectId, teamId);

    if (response.isSuccess && response.data != null) {
      final teamResponse = response.data!.data;

      teamMemberInfo = teamResponse!.members;
      await isUserTeamLeaderInTeam(teamMemberInfo);

      error = null;
    } else {
      teamMemberInfo = [];
      error = response.error ?? ApiError.server;
    }

    _isTeamMember = false;
    notifyListeners(); // update UI
  }

  bool _isReviewTask = false;
  bool get isReviewTask => _isReviewTask;
  TaskReviewResponse? taskReviewResponse;
  //list declareed to review task for team leader
  List<TaskData> _reviewList = [];
  List<TaskData> get reviewList => _reviewList;
  Future<void> fatchReviewTaskCon() async {
    _isReviewTask = true;
    error = error;
    notifyListeners();
    final review = await _service.fatchReviewTask();
    if (review.isSuccess) {
      taskReviewResponse = review.data;
      //FILTER DATA.........................
      //  final   userId= TokenService.getUserUniqueID();
      //     _reviewList=taskReviewResponse!.data.where((i) {
      //       i.submittedTo.submitToId==userId;}).toList()??[];
    } else {
      error = review.error;
    }
    _isReviewTask = false;
    notifyListeners();
  }

//get user by sharredpreference id.........................
  int? userUid;
  Future<void> getUserBySharedPreferenceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('uuid');
    userUid = userId;
    notifyListeners();
  }

  bool _isReview = false;
  bool get isReview => _isReview;

  // Make sure this is declared in your provider

  Future<void> reviewTask(Map<String, dynamic> json) async {
    _isReview = true;
    error = null;
    notifyListeners();

    final review = await _service.updateReviewTask(json);

    if (review.isSuccess) {
      // Optionally use review.data if needed
      //final responseData = review.data;
    } else {
      error = review.error;
    }

    _isReview = false;
    notifyListeners();
  }

  Member? getUserInfo(int userId) {
    if (teamResponse == null) return null;

    // for (var team in teamResponse!.data) {
    //   for (var member in team.members) {
    //     if (member.userId == userId) {
    //       return member;
    //     }
    //   }
    // }
    return null;
  }

  Future<int?> getUserIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  //CREATE TASK
  bool _isCreateTask = false;
  bool get isCreateTask => _isCreateTask;
  Future<void> createTaskByTeamLeader(Map<String, dynamic> json) async {
    _isCreateTask = true;
    error = null;
    notifyListeners();
    final response = await _service.createTask(json);
    if (response.isSuccess) {
    } else {
      error = response.error;
    }
    _isCreateTask = false;
    notifyListeners();
  }

  //VIEW COMPLETE TASK DETAIL AS PER USER COMPELET TASK

  bool _isComplete = false;
  bool get isComplete => _isComplete;
  CompleteTaskApiResponse? completeTaskApiResponse;

  Future<void> toviewCompleteTaskProvider(int taskId) async {
    _isComplete = true;
    error = null;

    notifyListeners();
    final completeResponse = await _service.toviewCompleteTask(taskId);

    if (completeResponse.isSuccess) {
      completeTaskApiResponse = completeResponse.data;
    } else {
      error = completeResponse.error;
    }
    _isComplete = false;
    notifyListeners();
  }

  //THE PROVIDER METHOD REFERACTOR THAT CALLL THE API FUNCTION CREATED IN USER_SERVICE CLASS FOR DELETE THE FILE ..
  bool _isDeleted = false;
  bool get isDeleted => _isDeleted;
  final Set<int> _deletingFileIds = {};
  Set<int> get deletingFileIds => _deletingFileIds;
  Future<void> todeleteFileProvider(int fileId) async {
    _deletingFileIds.add(fileId);
    notifyListeners();
    // _isDeleted = true;
    error = null;
    notifyListeners();
    final fileDeleted = await _service.todeleteFile(fileId);
    if (fileDeleted.isSuccess) {
      completeTaskApiResponse?.data!.files
          ?.removeWhere((files) => files.fileIdd == fileId);
    } else {
      error = fileDeleted.error;
    }

    _deletingFileIds.remove(fileId);

    notifyListeners();
  }

  //THIS PROVIDER METHOD CALL THE API IN USER_SERVICE CLASS FOR RESUBMIT TASK WITH FILE...
  bool _isResubmitask = false;
  bool get isResubmitask => _isResubmitask;
  Future<void> toResubmitTask(
      Map<String, dynamic> toJson, List<String> files) async {
    _isResubmitask = true;
    error = error;
    notifyListeners();
    final resubmitTask = await _service.toResubmitUpdate(toJson, files);
    if (resubmitTask.isSuccess) {
      resubmitTask.data;
    } else {
      error = resubmitTask.error;
    }
    _isResubmitask = false;
    notifyListeners();
  }
  // final Set<int> _deletingFileIds = {};

  // Set<int> get deletingFileIds => _deletingFileIds;

  // Future<void> to0deleteFileProvider(int taskId) async {
  //   _deletingFileIds.add(taskId);
  //   error = null;
  //   notifyListeners();

  //   final fileDeleted = await _service.todeleteFile(taskId);

  //   if (!fileDeleted.isSuccess) {
  //     error = fileDeleted.error;
  //   }

  //   _deletingFileIds.remove(taskId);
  //   notifyListeners();
  // }

  List<FileAttachment> _filesAtt = [];
  List<FileAttachment> get filesAtt => _filesAtt;
  Future<void> setFiles(List<FileAttachment> newFiles) async {
    notifyListeners();
  }

  int? _expandedIndex; // null means nothing expanded
  int? get expandedIndex => _expandedIndex;

  void toggleExpand(int index) {
    if (_expandedIndex == index) {
      _expandedIndex = null; //
    } else {
      _expandedIndex = index; // expand clicked card
    }
    notifyListeners();
  }

  //FATCH ALL TASK IN TEAM USING PAGINATION....
  //   Future<void> fatchAllTaskInTeam(int projectUid, int teamUid) async {
  //   isLoadingAllTak = true;
  //   error = null;
  //   notifyListeners();
  //   final allTask = await _service.getAllTaskInTeam(projectUid, teamUid);
  //   if (allTask.isSuccess) {
  //     taskResponse2 = allTask.data;
  //   } else {
  //     error = allTask.error;
  //   }
  //   isLoadingAllTak = false;
  //   notifyListeners();
  // }
  //   UserWorkHistoryResponse? userWorkHistoryResponse;
  // bool _isHistoryload = false;
  // bool get isHistoryload => _isHistoryload;
  // List<TaskDetails> _usWrkHistory = [];
  // List<TaskDetails> get usWrkHistory => _usWrkHistory;
  // ApiError? error;
  // int _currentPage = 0;
  // int _size = 10;
  // int get currentPage => _currentPage;
  // int get size => _size;

  // bool _isLastPage = false;
  // Future<void> userWorkHistory() async {
  //   if (_isHistoryload || _isLastPage) return;

  //   _isHistoryload = true;
  //   error = null;
  //   notifyListeners();

  //   try {
  //     final historyResponse =
  //         await _service.getUserHistory(_currentPage, _size);

  //     if (historyResponse.isSuccess && historyResponse.data != null) {
  //       final pageData = historyResponse.data!;

  //       _usWrkHistory.addAll(pageData.content);

  //       _isLastPage = pageData.last;
  //       _currentPage++;
  //     }
  //   } catch (e) {
  //     error = ApiError.invalidData;
  //   }

  //   _isHistoryload = false;
  //   notifyListeners();
  // }
//name of name with getter method
  ProjectTeamTask? _projectTeamTask;
  ProjectTeamTask? get projectTeamTask => _projectTeamTask;
  //inside class declared list for store data
  //ApiError? error;
  bool _showAllTask = false;
  bool get showAllTask => _showAllTask;
  int _currentPage = 0;
  int _size = 10;
  int get currentPage => _currentPage;
  int get size => _size;
  bool _isLastPage = false;
  List<AllTask> _listOfAllTask = [];
  List<AllTask> get listOfAllTask => _listOfAllTask;
  List<AllTask> _pendingTask = [];
  List<AllTask> get pendingTask => _pendingTask;
  List<AllTask> _resubmit = [];
  List<AllTask> get resubmit => _resubmit;
  List<AllTask> _underReview = [];
  List<AllTask> get underReview => _underReview;
  List<AllTask> _completed = [];
  List<AllTask> get completed => _completed;
  Future<void> fatchAllTaskINTeamUsingPagination(int projectId, int teamId,
      {bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 0;
      _isLastPage = false;
    }
    if (_showAllTask || _isLastPage) return;
    if (_currentPage == 0) {
      _listOfAllTask.clear();
      _pendingTask.clear();
      _resubmit.clear();
      _underReview.clear();
      _completed.clear();
    }
    _showAllTask = true;
    error = null;
    notifyListeners();
    try {
      final taskResponse = await _service.getAllProjectAndTeamTaskService(
          currentPage, size, projectId, teamId);

      if (taskResponse.isSuccess) {
        final pageData = taskResponse.data!;
        final newTasks = pageData.content;
        for (var task in newTasks) {
          String status = task.taskStatus?.toUpperCase() ?? "";
          if (status == "PENDING")
            _pendingTask.add(task);
          else if (status == "UNDER_REVIEW")
            _underReview.add(task);
          else if (status == "RESUBMIT")
            _resubmit.add(task);
          else if (status == "COMPLETED") _completed.add(task);
        }
        _isLastPage = pageData.last;
        _currentPage++;
      }
    } catch (e, stacktrace) {
      print("CRASH DETECTED: $e");
      print(
          "STACKTRACE: $stacktrace"); // This will tell you the exact line of the Stack Overflow
      error = ApiError.invalidData;
    } finally {
      _showAllTask = false;
      notifyListeners(); // Always notify, even on failure
    }
      }

    Future<void> fatchAllTaskINTeamUsingPagination2(int projectId, int teamId,
        {bool isRefresh = false}) async {
      if (isRefresh) {
        _currentPage = 0;
        _isLastPage = false;
        _pendingTask.clear();
        _resubmit.clear();
        _underReview.clear();
        _completed.clear();

        notifyListeners();
      }
      if (_showAllTask || _isLastPage) return;
      // if (_currentPage == 0) {
      //   _listOfAllTask.clear();
      //   _pendingTask.clear();
      //   _resubmit.clear();
      //   _underReview.clear();
      //   _completed.clear();
      // }
      _showAllTask = true;
      error = null;
      notifyListeners();
      try {
        final taskResponse = await _service.getAllProjectAndTeamTaskService(
            currentPage, size, projectId, teamId);

        if (taskResponse.isSuccess) {
          final pageData = taskResponse.data!;
          final newTasks = pageData.content;
          for (var task in newTasks) {
            String status = task.taskStatus?.toUpperCase() ?? "";
            if (status == "PENDING" && !exists(_pendingTask,task))
              _pendingTask.add(task);
            else if (status == "UNDER_REVIEW" &&!exists(_underReview, task))
              _underReview.add(task);
            else if (status == "RESUBMIT"&&exists(_resubmit, task))
              _resubmit.add(task);
            else if (status == "COMPLETED"&&exists(_completed, task)) _completed.add(task);
          }
          _isLastPage = pageData.last;
          _currentPage++;
        }
      } catch (e, stacktrace) {
        print("CRASH DETECTED: $e");
        print(
            "STACKTRACE: $stacktrace"); // This will tell you the exact line of the Stack Overflow
        error = ApiError.invalidData;
      } finally {
        _showAllTask = false;
        notifyListeners(); // Always notify, even on failure
      }
    }
   

 bool exists(List<AllTask> list, AllTask task) {
  return list.any((t) => t.taskId == task.taskId);
 }
 void resetTaskState() {
  _currentPage = 0;
  _isLastPage = false;
  _showAllTask = false;

  _pendingTask.clear();
  _resubmit.clear();
  _underReview.clear();
  _completed.clear();

  notifyListeners();
}

//     try {
//       final taskResponse = await _service.getAllProjectAndTeamTaskService(
//           currentPage, size, projectId, teamId);
//       if (taskResponse.isSuccess ) {
//         final pageData = taskResponse.data!;
//         print("here sucess------------");
//        // _listOfAllTask.addAll(pageData.content);

// //pending task...
//         final pending =
//             pageData.content.where((t) => t.taskStatus == "PENDING").toList() ??
//                 [];
//         _pendingTask.addAll(pending);

//         final resubmit = pageData.content
//                 .where((t) => t.taskStatus == "RESUBMITTED")
//                 .toList() ??
//             [];
//         _resubmit.addAll(resubmit);
//         final underReview = pageData.content
//                 .where((t) => t.taskStatus == "UNDER_REVIEW")
//                 .toList() ??
//             [];
//         _underReview.addAll(underReview);
//         final completed = pageData.content
//                 .where((t) => t.taskStatus == "COMPLETED")
//                 .toList() ??
//             [];
//         _completed.addAll(completed);

//         _isLastPage = pageData.last;
//         _currentPage++;
//       }
//       _showAllTask = false;
//       notifyListeners();
//     } catch (e) {
//       error = ApiError.invalidData;
//     }
  

//PROJECT TEAM LEADER AUTHICATE BASED IN TEAM MEMBER........................................................
  bool isTeamLeaderTrue = false;
  Member? _member;
  Member? get member => _member;
  Future<void> isUserTeamLeaderInTeam(List<Member> teamMemberInfo) async {
    //  isTeamLeaderTrue = true;
    //notifyListeners();
    //step find if user is teamleader.......
    for (var user in teamMemberInfo) {
      String role = user.role;
      var userId = user.userId;
      int? id = await TokenService.getUserUniqueID();
      if (userId == id && role.toUpperCase() == "TEAMLEADER") {
        _member = user;
        isTeamLeaderTrue = true;
        notifyListeners();
      }
      break;
    }
  }
}
