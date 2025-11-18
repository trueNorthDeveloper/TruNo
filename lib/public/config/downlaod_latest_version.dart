import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class DownlaodLatestVersion {
  static String? downloadUrl;

  static Future<bool?> getUpdate() async {
    print(
        "Checking for app updates...---------------------------------------------");

  
    final response = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/trueNorthDeveloper/-truenorthflutterfrontendnew/refs/heads/main/updatejson.json?token=GHSAT0AAAAAADPDAAAJXEIJ3BHZIJQMI5RY2I3BHGA"));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      String latestVersion = jsonData["latest_version"];
      String? currentVersion = await getCurrentVersion(); // <-- FIX

      if (currentVersion != latestVersion) {
        downloadUrl = jsonData['apk_url'];
        return true; // Update available
      } else {
        return false; // Up to date
      }
    }
    return false; // If API fails
  }

  static Future<String?> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    print("Current app version: $currentVersion");
    return currentVersion;
  }
}
