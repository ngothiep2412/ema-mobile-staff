import 'dart:convert';

import 'package:hrea_mobile_staff/app/modules/request_transaction/model/budget_transaction_model.dart';
import 'package:hrea_mobile_staff/app/resources/base_link.dart';
import 'package:http/http.dart' as http;

class RequestTransactionApi {
  static Future<List<BudgetTransactionModel>> getAllBudget(String jwtToken, currentPage, String sort, String status, String taskID) async {
    var response = await http.get(
      Uri.parse(
          '${BaseLink.localBaseLink}${BaseLink.getAllReqeustTransaction}?sizePage=10&currentPage=$currentPage&sortProperty=createdAt&sort=$sort&status=$status&taskId=$taskID'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"]['data'];
      List<BudgetTransactionModel> listBudget = [];
      listBudget.addAll(jsonData.map((listBudget) => BudgetTransactionModel.fromJson(listBudget)).cast<BudgetTransactionModel>());
      return listBudget;
    } else {
      throw Exception('Exception');
    }
  }
}
