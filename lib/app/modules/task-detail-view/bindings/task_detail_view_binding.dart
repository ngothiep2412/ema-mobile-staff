import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/task_detail_view_controller.dart';

class TaskDetailViewBinding extends BaseBindings {
  String taskID = '';
  bool isNavigateOverall = false;
  bool isNavigateNotification = false;
  bool isNavigateSchedule = false;

  @override
  void injectService() {
    taskID = Get.arguments["taskID"] as String;
    isNavigateOverall = Get.arguments["isNavigateOverall"] as bool;
    isNavigateNotification = Get.arguments["isNavigateNotification"] as bool;
    isNavigateSchedule = Get.arguments["isNavigateSchedule"] as bool;

    Get.lazyPut<TaskDetailViewController>(
      () => TaskDetailViewController(
          taskID: taskID,
          isNavigateOverall: isNavigateOverall,
          isNavigateNotification: isNavigateNotification,
          isNavigateSchedule: isNavigateSchedule),
    );
  }
}
