import 'package:truenorthflutterfrontend/public/config/platform_type.dart';

class Resultt<T> {
  final T? data;          // success data
  final String? message;  // always contains a user-friendly message
  final bool isSuccess;

  Resultt._({this.data, this.message, required this.isSuccess});

  // Success factory
  factory Resultt.success(T data) {
    return Resultt._(data: data, message: null, isSuccess: true);
  }

  // Failure factory for API JSON errors
  factory Resultt.apiError(Map<String, dynamic> errorJson) {
    // Use "message" from backend, or fallback
    String msg = errorJson["message"] ?? "Something went wrong";
    return Resultt._(data: null, message: msg, isSuccess: false);
  }

  // Failure factory for system/network errors
  factory Resultt.systemError(ApiError error) {
    return Resultt._(
      data: null,
      message: error.toString(),
      isSuccess: false,
    );
  }
}
