import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/expenseCategoryResponse.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/expenseDynamicFieldResponseModel.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/myBalanceResponse.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/transactionHistoryResponse.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/api_result.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';

class Expensemoduleservice {
  final auth = TokenService();

  Future<Result> fatchExpenseCategory(dynamic date) async {
    try {
      String endPoint = "expense/show-expense-category?date=$date";
      print("show expense category$endPoint");
      final respones = await auth.authorizedGetForWork(endPoint);
      if (respones.statusCode == 200) {
        try {
          final jsonReponse = jsonDecode(respones.body);
          final data = ExpenseCategoryResponse.fromJson(jsonReponse);

          return Result.success(data);
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException catch (_) {
      return Result.failure(ApiError.network);
    } on TimeoutException catch (_) {
      return Result.failure(ApiError.timeout);
    } on http.ClientException catch (_) {
      return Result.failure(ApiError.client);
    } on PlatformException catch (_) {
      return Result.failure(ApiError.platform);
    } catch (_) {
      return Result.failure(ApiError.unknown);
    }
  }

  Future<Result> fatchDynamicFieldReponse(int id) async {
    try {
      String endPoint = "expense/show-category-field/${id}";
      final respones = await auth.authorizedGetForWork(endPoint);
      if (respones.statusCode == 200) {
        try {
          final data = jsonDecode(respones.body);
          final jsonResponse = ExpenseDynamicFieldResponseModel.fromJson(data);
          return Result.success(jsonResponse);
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException catch (_) {
      return Result.failure(ApiError.network);
    } on TimeoutException catch (_) {
      return Result.failure(ApiError.timeout);
    } on http.ClientException catch (_) {
      return Result.failure(ApiError.client);
    } on PlatformException catch (_) {
      return Result.failure(ApiError.platform);
    } catch (_) {
      return Result.failure(ApiError.unknown);
    }
  }

  ///USER..........................USER ACCOUNT BALANCE RETRIVE

  Future<Result> fatchMyAccountBalance() async {
    try {
      String endPoint = "expense/my-balance";
      final respones = await auth.authorizedGetForWork(endPoint);
      if (respones.statusCode == 200) {
        try {
          final data = jsonDecode(respones.body);
          final jsonResponse = MyBalanceRespone.fromJson(data);
          return Result.success(jsonResponse);
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException catch (_) {
      return Result.failure(ApiError.network);
    } on TimeoutException catch (_) {
      return Result.failure(ApiError.timeout);
    } on http.ClientException catch (_) {
      return Result.failure(ApiError.client);
    } on PlatformException catch (_) {
      return Result.failure(ApiError.platform);
    } catch (_) {
      return Result.failure(ApiError.unknown);
    }
  }

  //USER ACCOUNT TRANSCATION HISTORY
  // Future<Result<TransactionData>> fatchAccountHistory(
  //     int page, int size) async {
  //   try {
  //     String endPoint = "expense/my-account-transcations?=page=$page$size";
  //     final respones = await auth.authorizedGetForWork(endPoint);
  //     if (respones.statusCode == 200) {
  //       try {
  //         final data = jsonDecode(respones.body);
  //         final jsonResponse = TransactionData.fromJson(data);
  //         return Result.success(jsonResponse);
  //       } on FormatException catch (_) {
  //         return Result.failure(ApiError.jsonFormat);
  //       }
  //     } else {
  //       return Result.failure(ApiError.server);
  //     }
  //   } on SocketException catch (_) {
  //     return Result.failure(ApiError.network);
  //   } on TimeoutException catch (_) {
  //     return Result.failure(ApiError.timeout);
  //   } on http.ClientException catch (_) {
  //     return Result.failure(ApiError.client);
  //   } on PlatformException catch (_) {
  //     return Result.failure(ApiError.platform);
  //   } catch (_) {
  //     return Result.failure(ApiError.unknown);
  //   }
  // }
  Future<Result<TransactionData>> fatchAccountHistory(
      int page, int size) async {
    try {
      // FIXED: Corrected the query parameters string format
      String endPoint = "expense/my-account-transcations?page=$page&size=$size";
      final respones = await auth.authorizedGetForWork(endPoint);

      if (respones.statusCode == 200) {
        try {
          final data = jsonDecode(respones.body);
          // FIXED: Map to Root container first, then extract the internal 'data' node
          final rootResponse = TransactionHistoryResponse.fromJson(data);

          if (rootResponse.data != null) {
            return Result.success(rootResponse.data);
          } else {
            return Result.failure(ApiError.emptyResponse);
          }
        } on FormatException catch (_) {
          return Result.failure(ApiError.jsonFormat);
        }
      } else {
        return Result.failure(ApiError.server);
      }
    } on SocketException catch (_) {
      return Result.failure(ApiError.network);
    } on TimeoutException catch (_) {
      return Result.failure(ApiError.timeout);
    } on http.ClientException catch (_) {
      return Result.failure(ApiError.client);
    } on PlatformException catch (_) {
      return Result.failure(ApiError.platform);
    } catch (_) {
      return Result.failure(ApiError.unknown);
    }
  }

  //submit expense...................
  Future<Result>? submitExpenseService(
      Map<String, dynamic> json, List<String> files) async {
    String endPoint = "expense/expense-submission";
    // final respones = await auth.authorizedGetForWork(endPoint);
    final respones =
        await auth.authorizedPostForTaskWithMultipleFile(json, files, endPoint);

    if (respones.statusCode == 200) {
      try {
        final data = jsonEncode(respones);
        return Result.success(data);

        // if (rootResponse.data != null) {
        //   return Result.success(rootResponse.data);
        // } else {
        //   return Result.failure(ApiError.emptyResponse);
        // }
      } on FormatException catch (_) {
        return Result.failure(ApiError.jsonFormat);
      }
    } else {
      return Result.failure(ApiError.emptyResponse);
    }
  }
}
