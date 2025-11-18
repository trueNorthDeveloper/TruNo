import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

enum PlatformType {
  web,
  android,
  ios,
  windows,
  macos,
  linux,
  unknown,
}

PlatformType getPlatformType() {
  if (kIsWeb) return PlatformType.web;
  if (Platform.isAndroid) return PlatformType.android;
  if (Platform.isIOS) return PlatformType.ios;
  if (Platform.isWindows) return PlatformType.windows;
  if (Platform.isMacOS) return PlatformType.macos;
  if (Platform.isLinux) return PlatformType.linux;

  return PlatformType.unknown;
}

enum ApiError {
  network,
  timeout,
  platform,
  client,
  server,
  jsonFormat,
  missingUUID,
  unknown,
  unauthorized
}

ApiError getApiErrorType(Object error) {
  if (error is SocketException) {
    return ApiError.network;
  } else if (error is TimeoutException) {
    return ApiError.timeout;
  } else if (error is HttpException) {
    return ApiError.platform;
  } else if (error is FormatException) {
    return ApiError.jsonFormat;
  } else {
    return ApiError.unknown;
  }
}
