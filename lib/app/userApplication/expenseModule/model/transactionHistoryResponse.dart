class TransactionHistoryResponse {
  final dynamic success;
  final dynamic message;
  final TransactionData? data;

  TransactionHistoryResponse(
      {required this.success, required this.message, required this.data});

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) =>
      TransactionHistoryResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] != null
            ? TransactionData.fromJson(json["data"])
            : null,
      );
}

class TransactionData {
  final List<TransactionContent>? content;
  final dynamic page;
  final dynamic size;
  final dynamic totalElements;
  final dynamic totalPages;
  final dynamic first;
  final dynamic last;

  TransactionData({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.first,
    required this.last,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      TransactionData(
        content: json["content"] != null
            ? List<TransactionContent>.from(
                json["content"].map((x) => TransactionContent.fromJson(x)),
              )
            : null,
        page: json["page"],
        size: json["size"],
        totalElements: json["totalElements"] as int?,
        totalPages: json["totalPages"] as int?,
        first: json["first"] as bool?,
        last: json["last"] as bool?,
      );
}

class TransactionContent {
  final dynamic transactionId;
  final dynamic type;
  final dynamic category;
  final dynamic description;
  final dynamic transcationDate;
  final dynamic amount;

  TransactionContent({
    required this.transactionId,
    required this.type,
    required this.category,
    required this.description,
    required this.transcationDate,
    required this.amount,
  });

  factory TransactionContent.fromJson(Map<String, dynamic> json) =>
      TransactionContent(
        transactionId: json["transactionId"] as int?,
        type: json["type"]?.toString(),
        category: json["category"]?.toString(),
        description: json["description"]?.toString(),
        transcationDate: json["transcationDate"].toString(),
            // ? DateTime.tryParse(json["transcationDate"].toString())
            // : null,
        // Safely parse dynamic numbers into doubles to prevent subtype errors
        amount: json["amount"] != null
            ? double.tryParse(json["amount"].toString())
            : null,
      );
}
