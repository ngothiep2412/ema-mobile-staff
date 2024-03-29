import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/create_request_transaction_controller.dart';

class CreateRequestTransactionBinding extends BaseBindings {
  String taskID = '';
  @override
  void injectService() {
    taskID = Get.arguments["taskID"] as String;
    Get.lazyPut<CreateRequestTransactionController>(
      () => CreateRequestTransactionController(taskID: taskID),
    );
  }
}
