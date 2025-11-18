import 'package:truenorthflutterfrontend/public/config/platform_type.dart' show ApiError;

class Result<T> {
  final T? data;
  final ApiError? error;

  bool get isSuccess => data != null && error == null;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;
}
