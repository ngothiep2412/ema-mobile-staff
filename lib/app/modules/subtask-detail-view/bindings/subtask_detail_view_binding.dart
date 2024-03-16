import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/subtask_detail_view_controller.dart';

class SubtaskDetailViewBinding extends BaseBindings {
  String taskID = '';
  bool isNavigateDetail = false;
  bool isNavigateOverall = false;
  DateTime? endDateTaskParent;
  DateTime? startDateTaskParent;

  @override
  void injectService() {
    taskID = Get.arguments["taskID"] as String;
    isNavigateDetail = Get.arguments["isNavigateDetail"] as bool;
    isNavigateOverall = Get.arguments["isNavigateOverall"] as bool;

    endDateTaskParent = Get.arguments["endDate"] as DateTime;
    startDateTaskParent = Get.arguments["startDate"] as DateTime;
    Get.lazyPut<SubtaskDetailViewController>(
      () => SubtaskDetailViewController(
          taskID: taskID,
          isNavigateDetail: isNavigateDetail,
          isNavigateOverall: isNavigateOverall,
          endDateTaskParent: endDateTaskParent!,
          startDateTaskParent: startDateTaskParent!),
    );
  }
}
