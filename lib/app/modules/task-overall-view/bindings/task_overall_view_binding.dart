import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/task_overall_view_controller.dart';

class TaskOverallViewBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<TaskOverallViewController>(
      () => TaskOverallViewController(),
    );
  }
}
