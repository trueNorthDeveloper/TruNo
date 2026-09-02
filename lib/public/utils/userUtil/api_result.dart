import 'package:truenorthflutterfrontend/public/config/platform_type.dart'
    show ApiError;

class Result<T> {
  final T? data;
  final ApiError? error;
  final String? message;
  final bool _isUnprocessed;

  bool get isSuccess => data != null && error == null && !_isUnprocessed;
  bool get isProcess => data != null && error == null && _isUnprocessed;
  bool get isFailure => error != null;

  Result.success(this.data)
      : error = null,
        message = null,
        _isUnprocessed = false;

  Result.unProcess(this.data)
      : error = null,
        message = null,
        _isUnprocessed = true;

  Result.failure(this.error, {this.message})
      : data = null,
        _isUnprocessed = false;
}
