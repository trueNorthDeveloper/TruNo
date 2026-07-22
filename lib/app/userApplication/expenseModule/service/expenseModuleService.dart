import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show StreamedResponse;
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/dailyExpenseReponse.dart';
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
      // print("show expense category$endPoint");
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

  Future<Result<DailyExpenseRespone>> dailyExpenseService(year, month) async {
    try {
      // FIXED: Corrected the query parameters string format
      String endPoint = "expense/show-daily-expense?year=$year&month=$month";
      final respones = await auth.authorizedGetForWork(endPoint);

      if (respones.statusCode == 200 || respones.statusCode == 202) {
        try {
          final data = jsonDecode(respones.body);
          // FIXED: Map to Root container first, then extract the internal 'data' node
          final rootResponse = DailyExpenseRespone.fromJson(data);

          if (rootResponse.data != null) {
            return Result.success(rootResponse);
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

  // Future<Result> submitExpense(
  //   Map<String, Object> dto,
  //   List<String> files,
  // ) async {
  //   try {
  //     const endPoint = "expense/expense-submission";

  //     final response = await auth.authorizedPostForTaskWithMultipleFile(
  //       dto,
  //       files,
  //       endPoint,
  //     );

  //     final body = await response.stream.bytesToString();

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return Result.success(jsonDecode(body));
  //     }

  //     return Result.failure(
  //       ApiError.server,
  //       //  message: body,
  //     );
  //   } on FormatException {
  //     return Result.failure(ApiError.jsonFormat);
  //   } on SocketException {
  //     return Result.failure(ApiError.network);
  //   } on TimeoutException {
  //     return Result.failure(ApiError.timeout);
  //   } on http.ClientException {
  //     return Result.failure(ApiError.client);
  //   } on PlatformException {
  //     return Result.failure(ApiError.platform);
  //   } catch (e) {
  //     return Result.failure(
  //       ApiError.unknown,
  //       // message: e.toString(),
  //     );
  //   }
  // }
  Future<Result> submitExpense(
    Map<String, Object> dto,
    List<String> files,
  ) async {
    try {
      const endPoint = "expense/expense-submission";

      final response = await auth.authorizedPostForTaskWithMultipleFile(
        dto,
        files,
        endPoint,
      );

      final body = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Result.success(jsonDecode(body));
      }

      // Try to surface a server-provided error message if present
      String serverMessage = "Server error (${response.statusCode})";
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map && decoded['message'] != null) {
          serverMessage = decoded['message'].toString();
        }
      } catch (_) {
        // body wasn't valid JSON — fall back to default serverMessage
      }

      return Result.failure(
        ApiError.server,
          message: serverMessage,
      );
    } on FormatException {
      return Result.failure(
        ApiError.jsonFormat,
         message: "Received an unexpected response from the server.",
      );
    } on SocketException {
      return Result.failure(
        ApiError.network,
         message: "No internet connection. Please check your network.",
      );
    } on TimeoutException {
      return Result.failure(
        ApiError.timeout,
         message: "Request timed out. Please try again.",
      );
    } on http.ClientException {
      return Result.failure(
        ApiError.client,
         message: "Failed to reach the server. Please try again.",
      );
    } on PlatformException catch (e) {
      return Result.failure(
        ApiError.platform,
         message: e.message ?? "A platform error occurred.",
      );
    } catch (e) {
      return Result.failure(
        ApiError.unknown,
         message: e.toString(),
      );
    }
  }
}
