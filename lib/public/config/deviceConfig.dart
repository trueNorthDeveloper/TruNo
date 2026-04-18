import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Deviceconfig {
  //check internet connection..............date 21-6-2025.......................
  static Future<bool> checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<List> getDeviceInfo() async {
    try {
      // Simulate fetching device information
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      await Future.delayed(Duration(seconds: 1));
      List item = [];
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String device = androidInfo.device;
      item.add(device);
      String deviceId = androidInfo.id;
      item.add(deviceId);
      String deviceBrand = androidInfo.brand;
      item.add(deviceBrand);
      String model = androidInfo.model;
      item.add(model);

      return item;
    } catch (e) {
      print("Error fetching device info: $e");
      return [];
    }
  }
//Position
  static Future<Position?> deteminPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        //  _showLocationDialog(context, true);
        return null;
       
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          //  _showLocationDialog(context, false);
           return null;
         // return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        //  _showLocationDialog(context, false);
        return null;
       // return false;
      }

      // Safe to get location now
      return await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy:
            LocationAccuracy.high, // Or LocationAccuracy.best, etc.
      );
    } on PlatformException catch (e) {
      print("❌ PlatformException in _deteminPosition: ${e.message}");
      return null;
     // return false;
    } catch (e) {
      print("❌ Unexpected error in _deteminPosition: $e");
      return null;
     // return false;
    }
  }

  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng)
          .timeout(const Duration(seconds: 6));

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.country}";
      } else {
        return "Address not found";
      }
    } on TimeoutException {
      print("⏱️ Reverse geocoding timed out.");
      return "Timeout getting address";
    } on PlatformException catch (e) {
      print("📱 Platform error: ${e.message}");
      return "Platform error while fetching address";
    } catch (e) {
      print("❌ Error fetching address: $e");
      return "Failed to get address";
    }
  }

  static ImagePicker _picker = ImagePicker();
  static bool _isPermissionRequestInProgress = false;
  static Future<XFile?> pickImage(ImageSource source) async {
    if (_isPermissionRequestInProgress) return null;
    _isPermissionRequestInProgress = true;

    try {
      PermissionStatus cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        cameraStatus = await Permission.camera.request();
      }
      if (!cameraStatus.isGranted) {
        print("❌ Camera permission denied.");
        return null;
      }

      final XFile? image = await _picker.pickImage(source: source);
      return image;
    } finally {
      _isPermissionRequestInProgress = false;
    }
  }
}
