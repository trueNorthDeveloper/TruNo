class CanApplyLeave {
  final bool? success;
  final String? message;
  final bool? data;

  CanApplyLeave(
      {required this.success, required this.message, required this.data});

  factory CanApplyLeave.fromJson(Map<String, dynamic> json) {
    return CanApplyLeave(
        success: json["success"], message: json["message"], data: json["data"]);
  }
}
