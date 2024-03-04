import 'dart:convert';

import 'package:hrea_mobile_staff/app/modules/subtask-detail-view/model/employee_model.dart';
import 'package:hrea_mobile_staff/app/resources/base_link.dart';
import 'package:http/http.dart' as http;

class TaskCalendarMonthApi {
  static Future<List<EmployeeModel>> getAllEmployee(String jwtToken, String idStaff, String startDate, String endDate) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getAllEmployeeV2}?fieldName=id&conValue=$idStaff&startDate=$startDate&endDate=$endDate'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );

    print('abc event' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)['result']['users'];
      List<EmployeeModel> listEmployee = [];
      listEmployee.addAll(jsonData.map((employee) => EmployeeModel.fromJson(employee)).cast<EmployeeModel>());
      return listEmployee;
    } else {
      throw Exception('Exception');
    }
  }
}
