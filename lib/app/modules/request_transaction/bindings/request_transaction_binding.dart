import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/request_transaction_controller.dart';

class RequestTransactionBinding extends BaseBindings {
  String taskID = '';
  bool statusTask = false;
  @override
  void injectService() {
    taskID = Get.arguments["taskID"] as String;
    statusTask = Get.arguments["statusTask"] as bool;
    Get.lazyPut<RequestTransactionController>(
      () => RequestTransactionController(taskID: taskID, statusTask: statusTask),
    );
  }
}
