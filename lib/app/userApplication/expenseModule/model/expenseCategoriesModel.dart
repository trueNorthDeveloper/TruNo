class ExpenseCategoriesModel {
  final int id;
  final String categoryName;
  ExpenseCategoriesModel({required this.id, required this.categoryName});
  factory ExpenseCategoriesModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoriesModel(
      id: json['id'] as int,
      categoryName: json['categoryName'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
    };
  }

  ExpenseCategoriesModel copyWith({
    int? id,
    String? categoryName,
  }) {
    return ExpenseCategoriesModel(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}

// [
//     {
//         "id": 1,
//         "categoryName": "Fuel"
//     }
// ]
