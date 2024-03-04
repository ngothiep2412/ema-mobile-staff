import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/task_calendar_month_controller.dart';

class TaskCalendarMonthBinding extends BaseBindings {
  String userID = '';
  String userName = '';
  String startDate = '';
  String endDate = '';
  @override
  void injectService() {
    userID = Get.arguments["userID"] as String;
    userName = Get.arguments["userName"] as String;
    startDate = Get.arguments["startDate"] as String;
    endDate = Get.arguments["endDate"] as String;

    Get.lazyPut<TaskCalendarMonthController>(
      () => TaskCalendarMonthController(userID: userID, userName: userName, startDate: startDate, endDate: endDate),
    );
  }
}
