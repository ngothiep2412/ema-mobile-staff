import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';
import '../controllers/budget_detail_controller.dart';

class BudgetDetailBinding extends BaseBindings {
  String itemID = '';
  String taskID = '';
  bool statusTask = false;
  @override
  void injectService() {
    itemID = Get.arguments["itemID"] as String;
    taskID = Get.arguments["taskID"] as String;
    statusTask = Get.arguments["statusTask"] as bool;

    Get.put(
      BudgetDetailController(itemID: itemID, taskID: taskID, statusTask: statusTask),
    );
  }
}
