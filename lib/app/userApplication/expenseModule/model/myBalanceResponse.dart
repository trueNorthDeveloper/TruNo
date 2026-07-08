// RETRIVE USER CURRENT ACCOUNT BALANCE...........................
class MyBalanceRespone {

  final dynamic success;
  final dynamic message;
  final Balance? data;
  MyBalanceRespone({required this.success, required this.message, this.data});
  factory MyBalanceRespone.fromJson(Map<String, dynamic> json) =>
      MyBalanceRespone(
          success: json["success"],
          message: json["message"],
          data: json["data"] != null ? Balance.fromJson(json["data"]) : null);
}

class Balance {
  final dynamic accountId;
  final dynamic totalCreditAmount;
  final dynamic totalExpenseAmount;
  final dynamic availableAmount;
  Balance(
      {required this.accountId,
      required this.totalCreditAmount,
      required this.totalExpenseAmount,
      required this.availableAmount});
  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
      accountId: json["accountId"],
      totalCreditAmount: json["totalCreditAmount"],
      totalExpenseAmount: json["totalExpenseAmount"],
      availableAmount: json["availableAmount"]);
}
