class DailyExpenseRespone {
  final bool success;
  final String message;
  final ExpenseSummaryData? data;

  DailyExpenseRespone({
    required this.success,
    required this.message,
    this.data,
  });

  factory DailyExpenseRespone.fromJson(Map<String, dynamic> json) {
    return DailyExpenseRespone(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ExpenseSummaryData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ExpenseSummaryData {
  final int totalDaysWithExpenses;
  final num aggregateExpense;
  final List<DailySummary> dailySummaries;

  ExpenseSummaryData({
    required this.totalDaysWithExpenses,
    required this.aggregateExpense,
    required this.dailySummaries,
  });

  factory ExpenseSummaryData.fromJson(Map<String, dynamic> json) {
    return ExpenseSummaryData(
      totalDaysWithExpenses: json['totalDaysWithExpenses'] ?? 0,
      aggregateExpense: json['aggregateExpense'] ?? 0,
      dailySummaries: json['dailySummaries'] != null
          ? List<DailySummary>.from(
              json['dailySummaries'].map((x) => DailySummary.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalDaysWithExpenses': totalDaysWithExpenses,
      'aggregateExpense': aggregateExpense,
      'dailySummaries': dailySummaries.map((x) => x.toJson()).toList(),
    };
  }
}

class DailySummary {
  final String expenseDate;
  final String status;
  final num totalExpensesPerDay; // maps backend's 'totalExpenesPerDay' typo
  final List<Categories> categories;

  DailySummary({
    required this.expenseDate,
    required this.status,
    required this.totalExpensesPerDay,
    required this.categories,
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      expenseDate: json['expenseDate'] ?? '',
      status: json['status'] ?? '',
      totalExpensesPerDay:
          json['totalExpenesPerDay'] ?? 0, // backend typo, kept as-is
      categories: json['categories'] != null
          ? List<Categories>.from(
              json['categories'].map((x) => Categories.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expenseDate': expenseDate,
      'status': status,
      'totalExpenesPerDay': totalExpensesPerDay,
      'categories': categories.map((x) => x.toJson()).toList(),
    };
  }
}

class Categories {
  final int id;
  final dynamic transactionId;
  final dynamic expenseId;
  final String categoryName;
  final num expenseAmount;
  final String status;

  Categories({
    required this.id,
    required this.transactionId,
    required this.expenseId,
    required this.categoryName,
    required this.expenseAmount,
    required this.status,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'] ?? 0,
      transactionId: json["transactionId"],
      expenseId: json["expenseId"],
      categoryName: json['categoryName'] ?? '',
      expenseAmount: json['expenseAmount'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'expenseAmount': expenseAmount,
      'status': status,
    };
  }
}
