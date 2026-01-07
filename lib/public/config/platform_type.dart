import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
  unauthorized,
  forbidden,
  tooManyRequests,
  server,
  jsonFormat,
  invalidData,
  emptyResponse,
  ssl,
  cancelled,
  platform,
  client,
  unknown,
}

ApiError getApiErrorType(Object error) {
  if (error is SocketException) {
    return ApiError.network;
  } else if (error is TimeoutException) {
    return ApiError.timeout;
  } else if (error is HttpException) {
    return ApiError.unauthorized; // assuming HttpException is 401
  } else if (error is HandshakeException) {
    return ApiError.ssl;
  } else if (error is FormatException) {
    return ApiError.jsonFormat;
  } else if (error is http.ClientException) {
    return ApiError.client;
  } else {
    return ApiError.unknown;
  }
}

ApiError getApiErrorTypeFromStatusCode(int statusCode) {
  if (statusCode == 401) return ApiError.unauthorized;
  if (statusCode == 403) return ApiError.forbidden;
  if (statusCode == 429) return ApiError.tooManyRequests;
  if (statusCode >= 500) return ApiError.server;
  return ApiError.unknown;
}
