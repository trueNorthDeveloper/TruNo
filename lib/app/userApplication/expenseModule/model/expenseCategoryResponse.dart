// class ExpenseCategoriesModel {
//   final bool success;
//   final String message;
//   List<ExpenseFieldName>data;

//   final int id;
//   final String categoryName;
//   ExpenseCategoriesModel({required this.id, required this.categoryName});
//   factory ExpenseCategoriesModel.fromJson(Map<String, dynamic> json) {
//     return ExpenseCategoriesModel(
//       id: json['id'] as int,
//       categoryName: json['categoryName'] as String,
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'categoryName': categoryName,
//     };
//   }
// class ExpenseFieldName
// {

// }
//   ExpenseCategoriesModel copyWith({
//     int? id,
//     String? categoryName,
//   }) {
//     return ExpenseCategoriesModel(
//       id: id ?? this.id,
//       categoryName: categoryName ?? this.categoryName,
//     );
//   }
// }

// // [
// //     {
// //         "id": 1,
// //         "categoryName": "Fuel"
// //     }
// // ]
class ExpenseCategoryResponse {
  final bool success;
  final String message;
  final List<ExpenseCategory> data;

  ExpenseCategoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ExpenseCategoryResponse.fromJson(Map<String, dynamic> json) => ExpenseCategoryResponse(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: json["data"] == null 
        ? [] 
        : List<ExpenseCategory>.from(json["data"].map((x) => ExpenseCategory.fromJson(x))),
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

  ExpenseCategory({
    required this.id,
    required this.categoryName,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) => ExpenseCategory(
    id: json["id"] ?? 0,
    categoryName: json["categoryName"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryName": categoryName,
  };
}