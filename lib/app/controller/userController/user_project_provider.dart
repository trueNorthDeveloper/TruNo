import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:truenorthflutterfrontend/service/userServices/user_work_module_service_api.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_complete_task_api_response_model.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_task_review_response_model.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/team_members_model.dart';

import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_project_model.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_project_team_model.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_project_type_model.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_task_response_model.dart';

import 'package:truenorthflutterfrontend/public/config/platform_type.dart';

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
    //print("only-response${response.data}");

    if (response.isSuccess && response.data != null) {
      final teamResponse = response.data!.data;

      // teamMemberInfo =
      //     teamResponse!.data.expand((team) => team.members).toList();
      teamMemberInfo = teamResponse!.members;

      // CLEAR previous error here
      error = null;
      // print("TEAM MEMBERS LOADED: ${teamMemberInfo.length}");
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

  Future<void> fatchReviewTaskCon() async {
    _isReviewTask = true;
    error = error;
    notifyListeners();
    final review = await _service.fatchReviewTask();
    if (review.isSuccess) {
      taskReviewResponse = review.data;
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
  //fatch user who is user...................
}
