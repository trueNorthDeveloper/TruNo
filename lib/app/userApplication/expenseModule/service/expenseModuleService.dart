import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/expenseCategoriesModel.dart';
import 'package:truenorthflutterfrontend/public/config/platform_type.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/api_result.dart';
import 'package:truenorthflutterfrontend/service/token/tokenService.dart';

class Expensemoduleservice {
  final auth = TokenService();

  Future<Result> fatchExpenseCategory() async {
    try {
      //  String? endPoint = "attendance/attendance_logs?year=${year}${"&"}month=${month}";
      String endPoint = "expense/show-expense-category";
      final respones = await auth.authorizedGetForWork(endPoint);
      if (respones.statusCode == 200) {
        try {
           final List<dynamic> rawJsonList = jsonDecode(respones.body);
         final listRes=  Result.success(rawJsonList.map((item)=>ExpenseCategoriesModel.fromJson(item as Map<String,dynamic>)).toList());
         return listRes;
          //final response = ExpenseCategoriesModel.fromJson(rawJsonList);
          //return Result.success(response);
          //  return rawJsonList
          //   .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          //   .toList();
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
}
