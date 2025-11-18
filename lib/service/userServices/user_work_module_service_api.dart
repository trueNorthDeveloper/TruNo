import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truenorthflutterfrontend/public/config/api_const.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/api_result.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_complete_task_api_response_model.dart';

import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_task_review_response_model.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/team_members_model.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_project_model.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_project_team_model.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_project_type_model.dart';
import 'package:truenorthflutterfrontend/app/model/userModel/userWorkModuleModel/user_task_response_model.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';

class UserProjectService {
  //fatch all projectType........................

  Future<Result<ProjectTypeResponse>> fetchAllProjectType() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final uuid = prefs.getInt("uuid");
      if (uuid == null) {
        return Result.failure(ApiError.missingUUID);
      }
      final url = Uri.parse('${Apiconstants.userProjectType}$uuid');

      final response = await http.get(url).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          final projectType = ProjectTypeResponse.fromJson(data);
          return Result.success(projectType);
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException catch (_) {
      return Result.failure(ApiError.network);
    } on TimeoutException catch (_) {
      return Result.failure(ApiError.timeout);
    } on http.ClientException catch (_) {
      return Result.failure(ApiError.client);
    } on PlatformException catch (_) {
      return Result.failure(ApiError.platform);
    } catch (_) {
      return Result.failure(ApiError.unknown);
    }
  }
//get all project

  Future<Result<userProjectResponse>> getAllProject(int projectUid) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final uuid = prefs.getInt("uuid");
      if (uuid == null) {
        return Result.failure(ApiError.missingUUID);
      }
      final url = Uri.parse('${Apiconstants.userAllProject}$projectUid/$uuid');
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          final userProject = userProjectResponse.fromJson(data);
          return Result.success(userProject);
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException catch (_) {
      return Result.failure(ApiError.network);
    } on TimeoutException catch (_) {
      return Result.failure(ApiError.timeout);
    } on http.ClientException catch (_) {
      return Result.failure(ApiError.client);
    } on PlatformException catch (_) {
      return Result.failure(ApiError.platform);
    } catch (_) {
      return Result.failure(ApiError.unknown);
    }
  }

  // get project team under project
  Future<Result<ProjectTeamResponse>> getProjectTeam(int projectUid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uuid = prefs.getInt("uuid");

      if (uuid == null) {
        return Result.failure(ApiError.missingUUID);
      }

      final url = Uri.parse('${Apiconstants.userProjectTeam}$projectUid/$uuid');

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          final projectTeam = ProjectTeamResponse.fromJson(data);
          return Result.success(projectTeam);
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException catch (_) {
      return Result.failure(ApiError.network);
    } on TimeoutException catch (_) {
      return Result.failure(ApiError.timeout);
    } on http.ClientException catch (_) {
      return Result.failure(ApiError.client);
    } on PlatformException catch (_) {
      return Result.failure(ApiError.platform);
    } catch (_) {
      return Result.failure(ApiError.unknown);
    }
  }

// fatch user task.....................
  Future<Result<TaskResponse>> getUserTask() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uuid = prefs.getInt("uuid");
      final url = Uri.parse("${Apiconstants.userTaskById}$uuid");
      final response = await http.get(url).timeout(const Duration(seconds: 20));
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          final taskResponse = TaskResponse.fromJson(data);

          return Result.success(taskResponse);
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException catch (_) {
      return Result.failure(ApiError.network);
    } on TimeoutException catch (_) {
      return Result.failure(ApiError.timeout);
    } on http.ClientException catch (_) {
      return Result.failure(ApiError.client);
    } on PlatformException catch (_) {
      return Result.failure(ApiError.platform);
    } catch (_) {
      return Result.failure(ApiError.unknown);
    }
  }

//Get all task based on

  Future<Result<TaskResponse>> getAllTaskInTeam(
      int projectId, int teamId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uuid = prefs.getInt("uuid");
      final url = Uri.parse(
          "${Apiconstants.userAllTaskInTeam}$projectId/$teamId/$uuid");
      final response = await http.get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          final allTaskResponse = TaskResponse.fromJson(data);
          return Result.success(allTaskResponse);
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException catch (_) {
      return Result.failure(ApiError.network);
    } on TimeoutException catch (_) {
      return Result.failure(ApiError.timeout);
    } on http.ClientException catch (_) {
      return Result.failure(ApiError.client);
    } on PlatformException catch (_) {
      return Result.failure(ApiError.platform);
    } catch (_) {
      return Result.failure(ApiError.unknown);
    }
  }

  //submit task in form of text...........................
  Future<Result> toSubmitTask(Map<String, dynamic> json) async {
    try {
      final url = Uri.parse(Apiconstants.submitTaskByUser);
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ' + base64Encode(utf8.encode('admin:admin123')),
      };
      final body = jsonEncode(json); // Add actual request data if needed

      try {
        final response = await http
            .post(url, headers: headers, body: body)
            .timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);

          return Result.success(json);
        } else {
          return Result.failure(ApiError.server);
        }
      } on SocketException {
        return Result.failure(ApiError.network);
      } on TimeoutException {
        return Result.failure(ApiError.timeout);
      } on http.ClientException {
        return Result.failure(ApiError.client);
      } on PlatformException {
        return Result.failure(ApiError.platform);
      } catch (e) {
        return Result.failure(ApiError.unknown);
      }
    } catch (e) {
      return Result.failure(ApiError.unknown);
    }
  }

  //DATE 8-9-2025..........UPLOAD FILE AND IMAGE ON GOOGLE DRIVE.............

  // Future<Result> taskFileSubmissoin(String filepath, String parentName,
  //     String childName, String teamName, String userEid, int taskId) async {
  //   try {
  //     Map<String, String> data = {
  //       'file': filepath,
  //       'parent': parentName,
  //       'child': childName,
  //       'team': teamName,
  //       'userEid': userEid,
  //       "taskId": taskId.toString()
  //     };
  //     final url = Uri.parse(Apiconstants.uploadfileOfTask);
  //     final headers = {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Basic ' + base64Encode(utf8.encode('admin:admin123')),
  //     };

  //     // final upload= await http.MultipartRequest('POST', url);
  //     // upload
  //     final response = await http.MultipartRequest("POST", url);
  //     response.fields.addAll(data);
  //     try {
  //       final reqResponse = await response.send();
  //       var respStr = await reqResponse.stream.bytesToString();
  //       if (reqResponse.statusCode == 200) {
  //         final jsonResponse = jsonDecode(respStr);
  //         return Result.success(jsonResponse);
  //       } else {
  //         return Result.failure(ApiError.server);
  //       }
  //     } on SocketException {
  //       return Result.failure(ApiError.network);
  //     } on TimeoutException {
  //       return Result.failure(ApiError.timeout);
  //     } on http.ClientException {
  //       return Result.failure(ApiError.client);
  //     } on PlatformException {
  //       return Result.failure(ApiError.platform);
  //     } catch (e) {
  //       return Result.failure(ApiError.unknown);
  //     }
  //   } catch (e) {
  //     return Result.failure(ApiError.unknown);
  //   }
  // }
  Future<Result> taskFileSubmission(
    String filepath,
    String parentName,
    String childName,
    String teamName,
    String userEid,
    int taskId,
  ) async {
    try {
      final url = Uri.parse(Apiconstants.uploadfileOfTask);
      final request = http.MultipartRequest("POST", url);

      // Add text fields
      request.fields['parent'] = parentName;
      request.fields['child'] = childName;
      request.fields['team'] = teamName;
      request.fields['userEid'] = userEid;
      request.fields['taskId'] = taskId.toString();

      // Add image file
      request.files.add(await http.MultipartFile.fromPath(
        'file', // this should match the backend field name
        filepath,
      ));

      // Add headers
      request.headers['Authorization'] =
          'Basic ' + base64Encode(utf8.encode('admin:admin123'));

      // Send request
      final streamedResponse = await request.send();
      final responseString = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        final jsonResponse = jsonDecode(responseString);
        return Result.success(jsonResponse);
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException {
      return Result.failure(ApiError.network);
    } on TimeoutException {
      return Result.failure(ApiError.timeout);
    } on http.ClientException {
      return Result.failure(ApiError.client);
    } on PlatformException {
      return Result.failure(ApiError.platform);
    } catch (e) {
      return Result.failure(ApiError.unknown);
    }
  }
//GET ALL TEAM MEMBER IN SPECIFIC PROJECT...................AND TEAM.

  Future<Result<TeamResponse>> getAllTeamMember(
      int projectId, int teamId) async {
    try {
      final url = Uri.parse("${Apiconstants.teamMember}$projectId/$teamId");
      final response = await http.get(url).timeout(const Duration(seconds: 20));
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          final teamResponse = TeamResponse.fromJson(data);
          return Result.success(teamResponse);
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException catch (_) {
      return Result.failure(ApiError.network);
    } on TimeoutException catch (_) {
      return Result.failure(ApiError.timeout);
    } on http.ClientException catch (_) {
      return Result.failure(ApiError.client);
    } on PlatformException catch (_) {
      return Result.failure(ApiError.platform);
    } catch (_) {
      return Result.failure(ApiError.unknown);
    }
  }

  //UPLOAD TASK WITH FILES AND IMAGES................

  // Future<Result> submitTaskWithWithOutFiles(
  //     Map<String, dynamic> json, List<String> files) async {
  //   try {
  //     final url = Uri.parse(Apiconstants.submitTaskWithFiles);

  //     final request =await http.MultipartRequest("POST", url);

  //     request.headers.addAll({
  //       'Authorization': 'Basic ' + base64Encode(utf8.encode('admin:admin123')),
  //     });

  //     request.fields['dto'] = jsonEncode(json);

  //     for (var filePath in files) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           'files',
  //           filePath
  //         ),
  //       );
  //     }

  //     final streamedResponse = await request.send();

  //     final respStr = await streamedResponse.stream.bytesToString();

  //     if (streamedResponse.statusCode == 200) {
  //       final jsonResponse = jsonDecode(respStr);
  //       return Result.success(jsonResponse);
  //     } else {
  //       return Result.failure(ApiError.server);
  //     }
  //   } on SocketException {
  //     return Result.failure(ApiError.network);
  //   } on TimeoutException {
  //     return Result.failure(ApiError.timeout);
  //   } on http.ClientException {
  //     return Result.failure(ApiError.client);
  //   } on PlatformException {
  //     return Result.failure(ApiError.platform);
  //   } catch (e, s) {
  //     return Result.failure(ApiError.unknown);
  //   }
  //}
//   Future<Result> submitTaskWithWithOutFiles(
//     Map<String, dynamic> json, List<String> files) async {
//   try {
//     final url = Uri.parse(Apiconstants.submitTaskWithFiles);

//     final request = http.MultipartRequest("POST", url);

//     request.headers.addAll({
//       'Authorization': 'Basic ${base64Encode(utf8.encode('admin:admin123'))}',
//     });

//     // Use the correct field name as per backend
//     request.fields['dto'] = jsonEncode(json);

//     for (var filePath in files) {
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'files', // 👈 must match backend param name
//           filePath,
//         ),
//       );
//     }

//     final streamedResponse = await request.send();
//     final respStr = await streamedResponse.stream.bytesToString();

//     if (streamedResponse.statusCode == 200) {
//       final jsonResponse = jsonDecode(respStr);
//       return Result.success(jsonResponse);
//     } else {
//       return Result.failure(ApiError.server);
//     }
//   } on SocketException {
//     return Result.failure(ApiError.network);
//   } on TimeoutException {
//     return Result.failure(ApiError.timeout);
//   } on http.ClientException {
//     return Result.failure(ApiError.client);
//   } on PlatformException {
//     return Result.failure(ApiError.platform);
//   } catch (e, s) {
//     print("Upload error: $e\n$s");
//     return Result.failure(ApiError.unknown);
//   }
// }

  Future<Result> submitTaskWithWithOutFiles(
      Map<String, dynamic> json, List<String> files) async {
    try {
      final url = Uri.parse(Apiconstants.submitTaskWithFiles);

      final request = http.MultipartRequest("POST", url);

      request.headers.addAll({
        'Authorization': 'Basic ${base64Encode(utf8.encode('admin:admin123'))}',
      });

      // 🔹 Send dto as application/json
      request.files.add(
        http.MultipartFile.fromString(
          'dto',
          jsonEncode(json),
          contentType: MediaType('application', 'json'),
        ),
      );

      // 🔹 Send files if any
      for (var filePath in files) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'files',
            filePath,
          ),
        );
      }

      final streamedResponse = await request.send();
      final respStr = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        final jsonResponse = jsonDecode(respStr);
        return Result.success(jsonResponse);
      } else {
        print("Server error: $respStr");
        return Result.failure(ApiError.server);
      }
    } catch (e, s) {
      print("Upload error: $e\n$s");
      return Result.failure(ApiError.unknown);
    }
  }
//HERE REVIEW ALL TASK............................................

  Future<Result<TaskReviewResponse>> fatchReviewTask() async {
    try {
      final url = Uri.parse(Apiconstants.reviewTask);

      final responseReview = await http.get(url).timeout(Duration(seconds: 20));

      if (responseReview.statusCode == 200) {
        try {
          final data = jsonDecode(responseReview.body);
          final reviewTask = TaskReviewResponse.fromJson(data);
          return Result.success(reviewTask);
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException catch (_) {
      return Result.failure(ApiError.network);
    } on TimeoutException catch (_) {
      return Result.failure(ApiError.timeout);
    } on http.ClientException catch (_) {
      return Result.failure(ApiError.client);
    } on PlatformException catch (_) {
      return Result.failure(ApiError.platform);
    } catch (_) {
      return Result.failure(ApiError.unknown);
    }
  }
  //UPDATE TASK REVIEW.........................................

  Future<Result> updateReviewTask(Map<String, dynamic> json) async {
    try {
      final url = Uri.parse(Apiconstants.reviewTaskUpdate);

      final response = await http
          .put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(json),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // API returns a plain string, so just return it directly
        return Result.success(response.body);
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException {
      return Result.failure(ApiError.network);
    } on TimeoutException {
      return Result.failure(ApiError.timeout);
    } on http.ClientException {
      return Result.failure(ApiError.client);
    } on PlatformException {
      return Result.failure(ApiError.platform);
    } catch (e) {
      return Result.failure(ApiError.unknown);
    }
  }
//CREATE TASK BY TEAM LEADER IF UESR IS TEAM LEADER SO LEADER CAN BE CREATE TASK........

  Future<Result> createTask(Map<String, dynamic> json) async {
    try {
      final url = Uri.parse(Apiconstants.crtTask);

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(json),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // API returns a plain string, so just return it directly
        return Result.success(response.body);
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException {
      return Result.failure(ApiError.network);
    } on TimeoutException {
      return Result.failure(ApiError.timeout);
    } on http.ClientException {
      return Result.failure(ApiError.client);
    } on PlatformException {
      return Result.failure(ApiError.platform);
    } catch (e) {
      return Result.failure(ApiError.unknown);
    }
  }
  //VIEW COMPLETE TASK DATAILS......................

  Future<Result<CompleteTaskApiResponse>> toviewCompleteTask(int taskId) async {
    try {
      final url = Uri.parse("${Apiconstants.viewCompleteTask}/$taskId");
      final apiResponse = await http.get(url).timeout(Duration(seconds: 20));

      if (apiResponse.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(apiResponse.body);
          final model = CompleteTaskApiResponse.fromJson(jsonResponse);
          return Result.success(model);
        } catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException {
      return Result.failure(ApiError.network);
    } on TimeoutException {
      return Result.failure(ApiError.timeout);
    } on http.ClientException {
      return Result.failure(ApiError.client);
    } on PlatformException {
      return Result.failure(ApiError.platform);
    } catch (_) {
      return Result.failure(ApiError.unknown);
    }
  }

//resubmit means user can update the task...................
  Future<Result> toResubmitUpdate(
      int taskId, Map<String, dynamic> json, List<String> files) async {
    try {
      final url = Uri.parse("${Apiconstants.resubmitupdate}$taskId");
      final updateRequest = http.MultipartRequest("PUT", url);

      // updateRequest.fields['dto'] = jsonEncode(json);
      updateRequest.files.add(
        http.MultipartFile.fromString(
          'dto',
          jsonEncode(json),
          contentType: MediaType('application', 'json'),
        ),
      );

      if (files.isNotEmpty) {
        for (var filePath in files) {
          updateRequest.files.add(
            await http.MultipartFile.fromPath('files', filePath),
          );
        }
      }

      // Send the request
      final streamedResponse = await updateRequest.send();
      final responseStr = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        final jsonResponse = jsonDecode(responseStr);
        return Result.success(jsonResponse);
      } else {
        print("Server error: $responseStr");
        return Result.failure(ApiError.server);
      }
    } on SocketException {
      return Result.failure(ApiError.network);
    } on TimeoutException {
      return Result.failure(ApiError.timeout);
    } on http.ClientException {
      return Result.failure(ApiError.client);
    } on PlatformException {
      return Result.failure(ApiError.platform);
    } catch (e) {
      print("Unexpected error: $e");
      return Result.failure(ApiError.unknown);
    }
  }

//THIS FUNCTION REFRACTOR:-TO-DELETE THE FILE FROM DRIVE AS WELL AS DATABASE.................
  Future<Result> todeleteFile(int id) async {
    try {
      final url = Uri.parse("${Apiconstants.deleteFile}$id");
      final response =
          await http.delete(url).timeout(const Duration(minutes: 2));

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          try {
            final data = jsonDecode(response.body);
            return Result.success(data);
          } catch (_) {
            return Result.failure(ApiError.jsonFormat);
          }
        } else {
          return Result.success({'message': 'File deleted successfully'});
        }
      } else {
        print("Delete failed: ${response.body}");
        return Result.failure(ApiError.server);
      }
    } on SocketException {
      return Result.failure(ApiError.network);
    } on TimeoutException {
      return Result.failure(ApiError.timeout);
    } on http.ClientException {
      return Result.failure(ApiError.client);
    } on PlatformException {
      return Result.failure(ApiError.platform);
    } catch (e) {
      print("Unexpected error during delete: $e");
      return Result.failure(ApiError.unknown);
    }
  }
}
