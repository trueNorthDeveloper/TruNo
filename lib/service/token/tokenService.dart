import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart' as http_parser;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:truenorthflutterfrontend/public/config/api_const.dart';
import 'package:truenorthflutterfrontend/public/config/deviceConfig.dart';

class TokenService {
  static String url = "";
  static String baseUrl = url + "/auth/api/";
  static String projectBaseUrl = url + "/api/";
  static String attendance = url = "/api/attendance/";
//saved user token
  static Future<void> saveToken(String accessToken, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("access_token", accessToken);
    prefs.setString("refresh_token", refreshToken);
  }

//it will clear shareed prffrence...........................................
  static Future<void> clearSharredPrefrance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = await prefs.getString("access_token");
    return accessToken;
  }

  static Future<String?> getRefreshToken() async {
    print("refresh token funcation working============");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = await prefs.getString("refresh_token");
    // String? access =await  prefs.getString("access_token");
    //    String? role =await  prefs.getString("user_role");
    print("refresh toke function ${refreshToken}");
    return refreshToken;
  }

//get user role..............
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

//get user id..............
  static Future<int?> getSavedRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  static Future<String?> getUserEid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('eid');
  }

//GET REFRESH TOKEN----------------------------------------------------------------------------------

  static Future<bool> getRefreshAccessToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      final hasInternet = await Deviceconfig.checkInternetConnection();
      if (!hasInternet) return false;

      final url = Uri.parse(Apiconstants.refreshTokenAcess);

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type':
                  'application/json', // CRITICAL: Tell the server it's JSON
              'Accept': 'application/json',
            },
            body: jsonEncode({"refreshToken": refreshToken}),
          )
          .timeout(
              const Duration(seconds: 15)); // Good practice to add a timeout

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        // Safety check: only update refresh token if the API actually sent a new one
        final newAccessToken = json['access_token'];
        final newRefreshToken = json['refresh_token'] ?? refreshToken;

        await saveToken(newAccessToken, newRefreshToken);
        return true;
      }

      // If status is 401 or 403, the refresh token itself might be expired
      return false;
    } catch (e) {
      print("Refresh Token Error: $e");
      return false;
    }
  }

//ALL ERROR STATUS CODE IT WILLL RETURN TRUE AND FALSE ALL STATUS CODE------------------------COMMAN
  bool _isAuthError(int code) {
    return code == 400 || code == 401 || code == 403 || code == 419;
  }

//GET METHOD FOR WORK --------------------------------------(1)----------------------------------------------------------------START
  // Future<http.Response> authorizedGetForWork(String endPoint) async {
  //   String? token = await getAccessToken();
  //   if (token == null) {
  //     throw Exception("Access token not found");
  //   }

  //   http.Response res = await _sendGetRequestForWork(endPoint, token);

  //   if (_isAuthError(res.statusCode)) {
  //     final refreshed = await getRefreshAccessToken();

  //     if (refreshed) {
  //       final newToken = await getAccessToken();

  //       res = await _sendGetRequestForWork(endPoint, newToken);
  //     }
  //   }

  //   return res;
  // }

  // Future<http.Response> _sendGetRequestForWork(
  //     String endPoint, String? token) async {
  //   return await http.get(
  //     Uri.parse("$projectBaseUrl$endPoint"),
  //     headers: {
  //       "Authorization": "Bearer $token",
  //       "Content-Type": "application/json",
  //     },
  //   );
  // }
  Future<http.Response> authorizedGetForWork(String endPoint) async {
    try {
      final String? token = await getAccessToken();
      if (token == null || token.isEmpty) {
        throw const HttpException("Access token not found");
      }

      http.Response res = await _sendGetRequestForWork(endPoint, token);

      // 🔐 Handle 401 / 403
      if (_isAuthError(res.statusCode)) {
        final bool refreshed = await getRefreshAccessToken();

        if (!refreshed) {
          throw const HttpException("Unauthorized");
        }

        final String? newToken = await getAccessToken();
        if (newToken == null || newToken.isEmpty) {
          throw const HttpException("Unauthorized");
        }

        // 🔁 Retry request ONCE with new token
        res = await _sendGetRequestForWork(endPoint, newToken);

        if (_isAuthError(res.statusCode)) {
          throw const HttpException("Unauthorized");
        }
      }

      return res;
    } on SocketException {
      rethrow; // 🌐 No internet
    } on TimeoutException {
      rethrow; // ⏱ Timeout
    }
  }

  Future<http.Response> _sendGetRequestForWork(
      String endPoint, String token) async {
    try {
      return await http.get(
        Uri.parse("$projectBaseUrl$endPoint"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 20));
    } on SocketException {
      rethrow; // 🌐 Internet issue
    } on TimeoutException {
      rethrow; // ⏱ Request timeout
    }
  }

//GET METHOD FOR WORK --------------------------------------(1)----------------------------------------------------------------END

//THIS METHOD FOR COMMAN POST METHOD FOR SINGLE JSON WITHOUT FILE .............................................
  Future<http.Response> authorizedPostForWork(
      String endpoint, Map<String, dynamic> json) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception("Access token not found");
    }
    http.Response responsePost = await _sendPostRequest(endpoint, token, json);
    if (_isAuthError(responsePost.statusCode)) {
      bool refreshed = await getRefreshAccessToken();
      if (!refreshed) {
        throw Exception("Session expired. Please login again.");
      }

      String? newToken = await getAccessToken();
      if (newToken == null) {
        throw Exception("Failed to retrieve new access token");
      }
      responsePost = await _sendPostRequest(endpoint, token, json);
    }
    return responsePost;
  }

  Future<http.Response> _sendPostRequest(
      String endPoint, String token, Map<String, dynamic> json) async {
    return await http.post(Uri.parse("$projectBaseUrl$endPoint"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(json));
  }

//THIS METHOD FOR LOGOUT BCZ THIS METHOD CONTAIN ONLY SINGLE IMAGE...................................................
  static Future<http.StreamedResponse> authorizedPostForLogout(
    Map<String, dynamic> body,
    String? imagePath,
    bool hasImage,
  ) async {
    String? token = await getAccessToken();

    final url = Uri.parse(Apiconstants.userlogout);
    final request = http.MultipartRequest("POST", url);

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    });

    request.files.add(
      http.MultipartFile.fromString(
        'dto',
        jsonEncode(body),
        contentType: http_parser.MediaType('application', 'json'),
      ),
    );

    // ✅ ADD IMAGE IF EXISTS
    if (hasImage && imagePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imagePath,
        ),
      );
    }

    // SEND REQUEST
    http.StreamedResponse response = await request.send();

    // 🔁 HANDLE TOKEN EXPIRED
    if (response.statusCode == 400 || response.statusCode == 403) {
      bool refreshed = await getRefreshAccessToken();

      if (refreshed) {
        String? newToken = await getAccessToken();

        final retryRequest = http.MultipartRequest("POST", url);
        retryRequest.headers.addAll({
          "Authorization": "Bearer $newToken",
          "Accept": "application/json",
        });

        retryRequest.files.add(
          http.MultipartFile.fromString(
            'dto',
            jsonEncode(body),
            contentType: http_parser.MediaType('application', 'json'),
          ),
        );

        if (hasImage && imagePath != null) {
          retryRequest.files.add(
            await http.MultipartFile.fromPath('image', imagePath),
          );
        }

        return await retryRequest.send();
      }
    }

    return response;
  }
  //THIS METHOD FOR TASK UPLOAD WITH MULTIPLE IMAGE---------------------------start

  Future<http.StreamedResponse> authorizedPostForTaskWithMultipleFile(
    Map<String, dynamic> json,
    List<String> files,
    String endPoint,
  ) async {
    String? token = await getAccessToken();
    if (token == null) {
      throw Exception("Access token not found");
    }

    http.StreamedResponse response =
        await _sendRequestMultiplefile(endPoint, token, json, files);

    if (_isAuthError(response.statusCode)) {
      bool refreshed = await getRefreshAccessToken();
      if (refreshed) {
        String? newToken = await getAccessToken();
        response =
            await _sendRequestMultiplefile(endPoint, newToken, json, files);
      }
    }

    return response;
  }

  Future<http.StreamedResponse> _sendRequestMultiplefile(
    String endPoint,
    String? token,
    Map<String, dynamic> json,
    List<String> files,
  ) async {
    final request = await http.MultipartRequest(
      "POST",
      Uri.parse("$projectBaseUrl$endPoint"),
    );

    request.headers['Authorization'] = 'Bearer $token';

    // JSON DTO
    request.files.add(
      await http.MultipartFile.fromString(
        'dto',
        jsonEncode(json),
        contentType: http.MediaType('application', 'json'),
      ),
    );

    for (final filePath in files) {
      if (filePath.trim().isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'files',
            filePath,
          ),
        );
      }
    }

    return await request.send();
  }

//THIS METHOD FOR TASK UPLOAD WITH MULTIPLE IMAGE---------------------------ending------
  //post method authorized ............DUMMY METHOD................
  Future<http.Response> authorizedPost(String endPoint, Map body) async {
    String baseUrl = ""; //it willl  be change somewhere other request....
    String? token = await getAccessToken();
    var res = await http.post(Uri.parse("$baseUrl$endPoint"),
        headers: {"Authorization": "Bearer $token"}, body: jsonEncode(body));
    if (res.statusCode == 400 || res.statusCode == 403) {
      //acess token token exprire....................
      bool refreshed = await getRefreshAccessToken();
      if (refreshed) {
        String? newToken = await getAccessToken();
        return await http.post(Uri.parse("$baseUrl$endPoint"),
            headers: {"Authorization": "Bearer $newToken"},
            body: jsonEncode(body));
      }
    }
    return res;
  }

  //Get method with  token-------------------DUMMY GET METHOD---------------(1)--------------------------------------------------------------------start
  Future<http.Response> authorizedGet(String endPoint) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception("Access token not found");
    }
    http.Response response = await _sendGetRequest(endPoint, token);
    if (response.statusCode == 401 || response.statusCode == 403) {
      bool refreshed = await getRefreshAccessToken();
      if (!refreshed) {
        throw Exception("Session expired. Please login again.");
      }

      String? newToken = await getAccessToken();
      if (newToken == null) {
        throw Exception("Failed to retrieve new access token");
      }

      // Retry request once
      response = await _sendGetRequest(endPoint, newToken);
    }
    return response;
  }

  Future<http.Response> _sendGetRequest(String endPoint, String token) async {
    return await http.get(
      Uri.parse("$baseUrl$endPoint"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
  }

//put method for comman
  Future<http.Response> authorizedPutForWork(
      String endpoint, Map<String, dynamic> json) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception("Access token not found");
    }
    http.Response responsePost = await _sendPutRequest(endpoint, token, json);
    if (_isAuthError(responsePost.statusCode)) {
      bool refreshed = await getRefreshAccessToken();
      if (!refreshed) {
        throw Exception("Session expired. Please login again.");
      }

      String? newToken = await getAccessToken();
      if (newToken == null) {
        throw Exception("Failed to retrieve new access token");
      }
      responsePost = await _sendPutRequest(endpoint, token, json);
    }
    return responsePost;
  }

  Future<http.Response> _sendPutRequest(
      String endPoint, String token, Map<String, dynamic> json) async {
    return await http.put(Uri.parse("$projectBaseUrl$endPoint"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(json));
  }

//PUT METHOD WITH FILE AND WITHOUT FILE...................
  Future<http.StreamedResponse> authorizedPutWithFileForWork(
      String endpoint, Map<String, dynamic> json, List<String> files) async {
    String? token = await getAccessToken();

    if (token == null) {
      throw Exception("Access token not found");
    }
    //http.Response responsePost = await _sendPutRequest(endpoint, token, json);
    http.StreamedResponse responsePost =
        await _sendPutRequestForMultiplefile(endpoint, token, json, files);
    if (_isAuthError(responsePost.statusCode)) {
      bool refreshed = await getRefreshAccessToken();
      if (!refreshed) {
        throw Exception("Session expired. Please login again.");
      }

      String? newToken = await getAccessToken();
      if (newToken == null) {
        throw Exception("Failed to retrieve new access token");
      }
      responsePost =
          await _sendPutRequestForMultiplefile(endpoint, token, json, files);
    }
    return responsePost;
  }

  Future<http.StreamedResponse> _sendPutRequestForMultiplefile(String endPoint,
      String? token, Map<String, dynamic> json, List<String> files) async {
    final request = await http.MultipartRequest(
      "PUT",
      Uri.parse("$projectBaseUrl$endPoint"),
    );

    request.headers['Authorization'] = 'Bearer $token';

    // JSON DTO
    request.files.add(
      await http.MultipartFile.fromString(
        'dto',
        jsonEncode(json),
        contentType: http.MediaType('application', 'json'),
      ),
    );

    for (final filePath in files) {
      if (filePath.trim().isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'files',
            filePath,
          ),
        );
      }
    }

    return await request.send();
  }

//DELETE METHOD
  Future<http.Response> authDeleteForWork(String endPoint) async {
    String? token = await getAccessToken();
    if (token == null) {
      throw Exception("Access token not found");
    }

    http.Response res = await _sendDeleteRequestForWork(endPoint, token);

    if (_isAuthError(res.statusCode)) {
      final refreshed = await getRefreshAccessToken();

      if (refreshed) {
        final newToken = await getAccessToken();

        res = await _sendDeleteRequestForWork(endPoint, newToken);
      }
    }

    return res;
  }

  Future<http.Response> _sendDeleteRequestForWork(
      String endPoint, String? token) async {
    return await http.delete(
      Uri.parse("$projectBaseUrl$endPoint"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
  }
}
