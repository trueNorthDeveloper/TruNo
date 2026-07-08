class ExpenseCategoryResponse {
  final bool success;
  final String message;
  final List<ExpenseCategory> data;

  ExpenseCategoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ExpenseCategoryResponse.fromJson(Map<String, dynamic> json) =>
      ExpenseCategoryResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<ExpenseCategory>.from(
                json["data"].map((x) => ExpenseCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ExpenseCategory {
  final int id;
  final String categoryName;
  final dynamic maxAllowedPerDay;
  final dynamic maxSubmissionsPerDay;
  final dynamic isLocked;
  final dynamic usedCount;
  final dynamic remainingCount;
  final dynamic lockMessage;

  ExpenseCategory(
      {required this.id,
      required this.categoryName,
      required this.maxAllowedPerDay,
      required this.maxSubmissionsPerDay,
      required this.isLocked,
      required this.usedCount,
      required this.remainingCount,
      required this.lockMessage});

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) =>
      ExpenseCategory(
          id: json["id"] ?? 0,
          categoryName: json["categoryName"] ?? "",
          maxAllowedPerDay: json["maxAllowedPerDay"],
          maxSubmissionsPerDay: json["maxSubmissionsPerDay"],
          isLocked: json["isLocked"],
          usedCount: json["usedCount"],
          remainingCount: json["remainingCount"],
          lockMessage: json["lockMessage"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryName": categoryName,
      };
}
