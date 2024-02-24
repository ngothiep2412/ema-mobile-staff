import 'package:get/get.dart';
import 'package:hrea_mobile_staff/app/base/base_bindings.dart';

import '../controllers/task_schedule_controller.dart';

class TaskScheduleBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<TaskScheduleController>(
      () => TaskScheduleController(),
    );
  }
}
