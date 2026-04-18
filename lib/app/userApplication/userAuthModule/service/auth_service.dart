import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/model/user_me_model.dart';

import 'package:truenorthflutterfrontend/public/config/api_const.dart';
import 'package:truenorthflutterfrontend/public/utils/resultt.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/api_result.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/model/user_login_info_model.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';

class UserServicesForApi {
  final auth = TokenService();
  //user login service.....................................................with jwt......
  // Future<Resultt> loginWithJwt(
  //   Map<String, dynamic> toJson,
  //   String filePath,
  // ) async {
  //   try {
  //     final request = http.MultipartRequest(
  //       "POST",
  //       Uri.parse(Apiconstants.login),
  //     );

  //     request.files.add(
  //       http.MultipartFile.fromString(
  //         'dto',
  //         jsonEncode(toJson),
  //         contentType: http.MediaType('application', 'json'),
  //       ),
  //     );

  //     request.files.add(
  //       await http.MultipartFile.fromPath('file', filePath),
  //     );

  //     final response = await request.send().timeout(
  //           const Duration(seconds: 30),
  //         );

  //     // final body = await response.stream.bytesToString();
  //     final responseBody = await http.Response.fromStream(response);

  //     if (responseBody.statusCode == 200) {
  //       return Resultt.success(jsonDecode(responseBody.body));
  //     } else {
  //       try {
  //         return Resultt.apiError(jsonDecode(responseBody.body));
  //       } catch (e) {
  //         return Resultt.systemError(ApiError.server);
  //       }
  //     }
  //   } on SocketException {
  //     return Resultt.systemError(ApiError.network);
  //   } on TimeoutException {
  //     return Resultt.systemError(ApiError.timeout);
  //   } catch (_) {
  //     return Resultt.systemError(ApiError.server);
  //   }
  // }
  Future<Resultt> loginWithJwt(
      Map<String, dynamic> toJson, String filePath) async {
    try {
      final request =
          http.MultipartRequest("POST", Uri.parse(Apiconstants.login));

      // Part 1: JSON Data
      request.files.add(
        http.MultipartFile.fromString(
          'dto',
          jsonEncode(toJson),
          contentType: http.MediaType('application', 'json'),
        ),
      );

      // Part 2: Image File
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return Resultt.success(jsonDecode(response.body));
      } else {
        // Safely try to parse error message from server
        final errorData = jsonDecode(response.body);
        return Resultt.apiError(errorData);
      }
    } on SocketException {
      return Resultt.systemError(ApiError.network);
    } catch (e) {
      return Resultt.systemError(ApiError.server);
    }
  }

//logut all ways
  Future<Resultt> automaticLogoutService(
      Map<String, dynamic> toJson, String filePath, bool image) async {
    try {
      final url = Uri.parse(Apiconstants.userlogout);
      final request = http.MultipartRequest("POST", url);

      request.files.add(
        http.MultipartFile.fromString(
          'dto',
          jsonEncode(toJson),
          contentType: http.MediaType('application', 'json'),
        ),
      );

      if (image) {
        request.files.add(await http.MultipartFile.fromPath('file', filePath));
      }

      final responseStream = await request.send();
      final responseBody = await responseStream.stream.bytesToString();

      if (responseStream.statusCode == 200) {
        return Resultt.success(jsonDecode(responseBody));
      }

      // Any API error
      try {
        final errorJson = jsonDecode(responseBody);
        return Resultt.apiError(errorJson);
      } catch (_) {
        return Resultt.systemError(ApiError.server);
      }
    } on SocketException {
      return Resultt.systemError(ApiError.network);
    } on TimeoutException {
      return Resultt.systemError(ApiError.timeout);
    } on http.ClientException {
      return Resultt.systemError(ApiError.client);
    } catch (_) {
      return Resultt.systemError(ApiError.server);
    }
  }
Future<Result<UsermeModel>> loginAfterMeService2(String token) async {
  try {
    final url = Uri.parse(Apiconstants.me);
    print("Attempting to call: $url"); // DEBUG PRINT
    print("Using Token: Bearer $token"); // DEBUG PRINT

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    ).timeout(const Duration(seconds: 15));

    print("Response Status: ${response.statusCode}"); // DEBUG PRINT
    print("Response Body: ${response.body}"); // DEBUG PRINT

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Result.success(UsermeModel.fromJson(data));
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      return Result.failure(ApiError.unauthorized);
    } else {
      return Result.failure(ApiError.server);
    }
  } on SocketException {
    return Result.failure(ApiError.network);
  } on TimeoutException {
    return Result.failure(ApiError.timeout);
  } on FormatException {
    print("Error during Me API call: JSON parse error");
    return Result.failure(ApiError.jsonFormat);
  } catch (e) {
    print("Error during Me API call: $e"); // THIS WILL TELL YOU WHY
    return Result.failure(ApiError.unknown);
  }
}
  // Future<Result<UsermeModel>> loginAfterMeService2(String token) async {
  //   try {
  //     final url = Uri.parse(Apiconstants.me); // Use your constant

  //     final response = await http.get(
  //       url,
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //     ).timeout(const Duration(seconds: 15));

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return Result.success(UsermeModel.fromJson(data));
  //     } else if (response.statusCode == 401 || response.statusCode == 403) {
  //       return Result.failure(ApiError.client); // Forbidden or Unauthorized
  //     } else {
  //       return Result.failure(ApiError.server);
  //     }
  //   } on SocketException {
  //     return Result.failure(ApiError.network);
  //   } catch (e) {
  //     return Result.failure(ApiError.unknown);
  //   }
  // }

  Future<Result<UsermeModel>> loginAfterMeService() async {
    try {
      String? endPoint = "v2me";
      final respones = await auth.authorizedGet(endPoint);
      if (respones.statusCode == 200) {
        try {
          final data = jsonDecode(respones.body);
          final userProject = UsermeModel.fromJson(data);
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

  Future<Result<UserLoginInfoModel>> getSessionInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? endPoint = "v2loginsessionInfo";
      final respone = await auth.authorizedGet(endPoint);

      if (respone.statusCode == 200) {
        final jsonMap = jsonDecode(respone.body) as Map<String, dynamic>;
        final userInfo = UserLoginInfoModel.fromJson(jsonMap);
        prefs.setString("loginInfo", jsonEncode(jsonMap));
        return Result.success(userInfo);
      } else {
        return Result.failure(ApiError.jsonFormat);
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

  Future<Result<UserLoginInfoModel>> loadSessionOnecs() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      String? endPoint = "v2loginsessionInfo";
      final respone = await auth.authorizedGet(endPoint);

      if (respone.statusCode == 200) {
        final jsonMap = jsonDecode(respone.body) as Map<String, dynamic>;
        final userInfo = UserLoginInfoModel.fromJson(jsonMap);
        //prefs.setString("loginInfo", jsonEncode(jsonMap));
        return Result.success(userInfo);
      } else {
        return Result.failure(ApiError.jsonFormat);
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

  Future<Result<UserLoginInfoModel>> getSessionInfo2() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Try local cache
      if (prefs.containsKey("loginInfo")) {
        final cachedData = prefs.getString("loginInfo");
        if (cachedData != null) {
          try {
            final jsonMap = jsonDecode(cachedData) as Map<String, dynamic>;
            final userInfo = UserLoginInfoModel.fromJson(jsonMap);
            return Result.success(userInfo);
          } catch (_) {
            return Result.failure(ApiError.jsonFormat);
          }
        }
      }

      // Call API if not cached
      final sessionId = prefs.getString("sessionId");
      if (sessionId == null) {
        return Result.failure(ApiError.unauthorized);
      }

      final url = Uri.parse('${Apiconstants.userLoginInfo}$sessionId');
      final response = await http.get(url).timeout(Duration(seconds: 20));

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
          final userInfo = UserLoginInfoModel.fromJson(jsonMap);
          prefs.setString("loginInfo", jsonEncode(jsonMap));
          return Result.success(userInfo);
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

  ///check user credentail before login...................
  // Future<Result> checkUserCredentailService(
  //     String empLoginId, String empPassword) async {
  //   try {
  //     final url = Uri.parse(Apiconstants.checkuserCredentail);
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json', // Tell the server this is JSON
  //         'Accept': 'application/json',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'empLoginId': empLoginId.trim(),
  //         'empPassword': empPassword.trim(),
  //       }),
  //     );
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final jsonRespones = jsonDecode(response.body);

  //       return Result.success(jsonRespones);
  //     } else if (response.statusCode == 422) {
  //       //invalid input
  //       final jsonRespones = jsonDecode(response.body);
  //       return Result.unProcess(jsonRespones);
  //     } else if (response.statusCode == 409) {
  //       //means already login
  //       final jsonRespones = jsonDecode(response.body);
  //       return Result.unProcess(jsonRespones);
  //     } else if (response.statusCode == 401) {
  //       //means user not found
  //       final jsonRespones = jsonDecode(response.body);
  //       return Result.unProcess(jsonRespones);
  //     } else {
  //       final jsonRespones = jsonDecode(response.body);
  //       return Result.failure(jsonRespones);
  //     }
  //   } on SocketException {
  //     return Result.failure(ApiError.network);
  //   } on TimeoutException {
  //     return Result.failure(ApiError.timeout);
  //   } on http.ClientException {
  //     return Result.failure(ApiError.client);
  //   } on PlatformException {
  //     return Result.failure(ApiError.platform);
  //   } catch (_) {
  //     return Result.failure(ApiError.unknown);
  //   }
  // }
  //FINAL LOGIN IMPLEMENTED WITH IMAGE AND LOCATION..
  Future<Result> checkUserCredentailService(
      String empLoginId, String empPassword) async {
    try {
      final url = Uri.parse(Apiconstants.checkuserCredentail);
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'empLoginId': empLoginId.trim(),
              'empPassword': empPassword.trim(),
            }),
          )
          .timeout(const Duration(seconds: 15));

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Result.success(jsonResponse);
      } else if (response.statusCode == 422 ||
          response.statusCode == 409 ||
          response.statusCode == 401) {
        // Inject the status code into the map so the UI can check for 409 specifically
        if (jsonResponse is Map) {
          jsonResponse['statusCode'] = response.statusCode;
        }
        return Result.unProcess(jsonResponse);
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException {
      return Result.failure(ApiError.network);
    } on TimeoutException {
      return Result.failure(ApiError.timeout);
    } on http.ClientException {
      return Result.failure(ApiError.client);
    } catch (e) {
      return Result.failure(ApiError.unknown);
    }
  }

  Future<Result> finalLoginCrdentilWithImage(
    Map<String, dynamic> toJson,
    String filePath,
  ) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(Apiconstants.login),
      );

      request.files.add(
        http.MultipartFile.fromString(
          'dto',
          jsonEncode(toJson),
          contentType: http.MediaType('application', 'json'),
        ),
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', filePath),
      );

      final response = await request.send().timeout(
            const Duration(seconds: 30),
          );

      final responseBody = await http.Response.fromStream(response);

      if (responseBody.statusCode == 200 || responseBody.statusCode == 201) {
        final response = responseBody.body;
        return Result.success(jsonDecode(response));
      } else if (responseBody.statusCode == 422 ||
          responseBody.statusCode == 409) {
        final response = responseBody.body;
        return Result.unProcess(jsonEncode(response));
      } else {
        return Result.failure(ApiError.jsonFormat);
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
//date user logout new method.................

  Future<Result> userLogOut(
      Map<String, dynamic> toJson, String filePath) async {
    try {
      final url = Uri.parse(Apiconstants.userlogout);
      final request = http.MultipartRequest("POST", url);

      request.files.add(
        http.MultipartFile.fromString(
          'dto',
          jsonEncode(toJson),
          contentType: http.MediaType('application', 'json'),
        ),
      );

      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      // Added timeout: crucial for Multipart requests which can hang
      final responseStream =
          await request.send().timeout(const Duration(seconds: 30));
      final responseBody = await responseStream.stream.bytesToString();

      // Safely decode the body
      final dynamic decodedData =
          responseBody.isNotEmpty ? jsonDecode(responseBody) : {};

      if (responseStream.statusCode == 200 ||
          responseStream.statusCode == 201) {
        return Result.success(decodedData);
      } else if (responseStream.statusCode == 400) {
        // Fixed: decode instead of encode
        return Result.unProcess(decodedData);
      } else {
        // Pass ApiError enum instead of raw json for Result.failure
        return Result.failure(ApiError.server);
      }
    } on SocketException {
      return Result.failure(ApiError.network);
    } on TimeoutException {
      return Result.failure(ApiError.timeout);
    } catch (e) {
      print("Logout Error: $e");
      return Result.failure(ApiError.unknown);
    }
  }
}
