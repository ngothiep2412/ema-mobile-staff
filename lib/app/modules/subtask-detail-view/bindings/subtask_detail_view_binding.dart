import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/subtask_detail_view_controller.dart';

class SubtaskDetailViewBinding extends BaseBindings {
  String taskID = '';
  @override
  void injectService() {
    taskID = Get.arguments["taskID"] as String;
    Get.put(
      SubtaskDetailViewController(taskID: taskID),
    );
  }
}
