import 'dart:convert';

import 'package:hrea_mobile_staff/app/modules/budget_detail/model/budget_item_model.dart';
import 'package:hrea_mobile_staff/app/resources/base_link.dart';
import 'package:hrea_mobile_staff/app/resources/response_api_model.dart';
import 'package:http/http.dart' as http;

class TransactionDetailApi {
  static Future<Transaction> getBudgetDetail(String transactionID, String jwtToken) async {
    var response = await http.get(Uri.parse('${BaseLink.localBaseLink}${BaseLink.getTransactionDetail}$transactionID'), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': 'Bearer $jwtToken',
    });

    print('budget detail' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"];
      return Future<Transaction>.value(Transaction.fromJson(jsonData));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateStatusTransaction(String transactionID, String jwtToken, String status, String rejectNote) async {
    Map<String, String> body = {
      "rejectNote": rejectNote,
    };
    var response = status == 'REJECTED'
        ? await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateStatusTransaction}$transactionID?status=$status'),
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              'Authorization': 'Bearer $jwtToken',
            },
            body: jsonEncode(body))
        : await http.put(
            Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateStatusTransaction}$transactionID?status=$status'),
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              'Authorization': 'Bearer $jwtToken',
            },
          );

    print('update detail' + response.statusCode.toString());
    var jsonData = jsonDecode(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonData));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonData));
    } else {
      throw Exception('Exception');
    }
  }
}
