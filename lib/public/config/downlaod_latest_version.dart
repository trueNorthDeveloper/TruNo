import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class DownlaodLatestVersion {
  static String? downloadUrl;
//update app.........................................................................................
  static Future<bool?> getUpdate() async {
    print(
        "Checking for app updates...---------------------------------------------");

    final url =
        "https://raw.githubusercontent.com/trueNorthDeveloper/TruNo/refs/heads/main/updatejson.json";
    final response = await http.get(Uri.parse(url));

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

// FOR CURRENT VERSION OF APK WHICH VERSION OF APK YOU ARE USING..............
  static Future<String?> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    print("Current app version: $currentVersion");
    return currentVersion;
  }

  ///GET  NGROK URL FOR API FECTH................................................................................
  
}
